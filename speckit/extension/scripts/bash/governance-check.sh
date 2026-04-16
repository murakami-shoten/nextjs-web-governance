#!/usr/bin/env bash
# =============================================================================
# governance-check.sh
#
# NWG Governance Enforcer — structural validation script.
# Called by Extension commands at each spec-kit phase.
#
# Usage:
#   governance-check.sh --phase <pre-specify|gate-check|quality-gate>
#                       [--feature-dir <dir>]
#
# Exit codes:
#   0 — All checks passed
#   1 — One or more checks failed (blocks workflow progression)
# =============================================================================
set -euo pipefail

# --- Defaults ---
PHASE=""
FEATURE_DIR=""
RULES_DIR="docs/governance/rules"

# --- Parse arguments ---
while [[ $# -gt 0 ]]; do
  case $1 in
    --phase) PHASE="$2"; shift 2 ;;
    --feature-dir) FEATURE_DIR="$2"; shift 2 ;;
    *) shift ;;
  esac
done

if [ -z "$PHASE" ]; then
  echo "❌ Usage: governance-check.sh --phase <pre-specify|gate-check|quality-gate>"
  exit 1
fi

# --- Locate spec directory ---
SPEC_DIR=""
if [ -n "$FEATURE_DIR" ]; then
  SPEC_DIR=".specify/specs/$FEATURE_DIR"
elif [ -n "${SPECIFY_FEATURE:-}" ]; then
  SPEC_DIR=".specify/specs/$SPECIFY_FEATURE"
else
  # Find most recent spec dir
  SPEC_DIR=$(ls -td .specify/specs/*/ 2>/dev/null | head -1 || echo "")
fi

# --- Counters ---
ERRORS=0
WARNINGS=0
PASSES=0

# --- Helpers ---
error() { echo "❌ FAIL: $1"; ERRORS=$((ERRORS + 1)); }
warn()  { echo "⚠️  WARN: $1"; WARNINGS=$((WARNINGS + 1)); }
pass()  { echo "✅ PASS: $1"; PASSES=$((PASSES + 1)); }

# =============================================================================
# Common: Governance rules directory
# =============================================================================
echo ""
echo "🔍 NWG Governance Check — Phase: $PHASE"
echo "═══════════════════════════════════════════"

if [ ! -d "$RULES_DIR" ]; then
  error "docs/governance/rules/ が見つかりません。NWG が正しくインストールされているか確認してください。"
  echo ""
  echo "⛔ GOVERNANCE GATE FAILED"
  exit 1
fi

RULE_COUNT=$(find "$RULES_DIR" -maxdepth 1 -name "*.md" | wc -l | tr -d ' ')
pass "ガバナンスルール ${RULE_COUNT} 件検出 (docs/governance/rules/)"

# =============================================================================
# Phase: pre-specify
# =============================================================================
if [ "$PHASE" = "pre-specify" ]; then
  # At this phase, requirements.md doesn't exist yet.
  # Just verify governance rules are available so the AI can read them.

  if [ "$RULE_COUNT" -eq 0 ]; then
    error "docs/governance/rules/ にルールファイルがありません"
  else
    pass "ルールファイルが利用可能"
  fi

  # Check hearing sheet exists
  if [ -f "docs/governance/requirements/HEARING_SHEET.md" ]; then
    pass "HEARING_SHEET.md が利用可能"
  else
    error "HEARING_SHEET.md が見つかりません"
  fi
fi

# =============================================================================
# Phase: gate-check (before plan / tasks / implement)
# =============================================================================
if [ "$PHASE" = "gate-check" ]; then

  # --- requirements.md existence ---
  if [ -z "$SPEC_DIR" ] || [ ! -d "$SPEC_DIR" ]; then
    error "仕様ディレクトリが見つかりません (SPEC_DIR=$SPEC_DIR)"
    error "speckit-specify を先に実行してください"
  else
    REQ_FILE="$SPEC_DIR/requirements.md"

    if [ ! -f "$REQ_FILE" ]; then
      error "requirements.md が見つかりません: $REQ_FILE"
    else
      pass "requirements.md 存在確認"

      # --- Hearing level ---
      if grep -q 'ヒアリング深度' "$REQ_FILE" 2>/dev/null; then
        pass "ヒアリング深度が記載されている"
      else
        error "ヒアリング深度が requirements.md に記載されていません (HEARING_RULES §1.1)"
      fi

      # --- TBD（未質問）---
      TBD_COUNT=$(grep -c 'TBD（未質問）\|TBD (未質問)' "$REQ_FILE" 2>/dev/null || echo "0")
      if [ "$TBD_COUNT" -gt 0 ]; then
        error "Must 項目に TBD（未質問）が ${TBD_COUNT} 件残っています (HEARING_RULES §2.2)"
        grep -n 'TBD（未質問）\|TBD (未質問)' "$REQ_FILE" 2>/dev/null || true
      else
        pass "TBD（未質問）なし"
      fi

      # --- AI推測 ---
      AI_COUNT=$(grep -c 'AI推測\|AI 推測\|AI推定\|AI 推定' "$REQ_FILE" 2>/dev/null || echo "0")
      if [ "$AI_COUNT" -gt 0 ]; then
        error "AI 推測による回答が ${AI_COUNT} 件あります (HEARING_RULES §2.2 推測禁止)"
        grep -n 'AI推測\|AI 推測\|AI推定\|AI 推定' "$REQ_FILE" 2>/dev/null || true
      else
        pass "AI 推測なし"
      fi

      # --- NEEDS CLARIFICATION ---
      NC_COUNT=$(grep -c 'NEEDS.CLARIFICATION' "$REQ_FILE" 2>/dev/null || echo "0")
      if [ "$NC_COUNT" -gt 0 ]; then
        warn "未確定事項 (NEEDS CLARIFICATION) が ${NC_COUNT} 件残っています"
      fi
    fi
  fi
fi

# =============================================================================
# Phase: quality-gate (after implement)
# =============================================================================
if [ "$PHASE" = "quality-gate" ]; then

  # --- .env.example ---
  if [ -f ".env.example" ]; then
    pass ".env.example が存在する (DEV_RULES §4)"
  else
    error ".env.example が見つかりません (DEV_RULES §4)"
  fi

  # --- docker-compose.yml ---
  if [ -f "docker-compose.yml" ] || [ -f "compose.yml" ]; then
    pass "docker-compose.yml が存在する (DEV_RULES §5)"
  else
    error "docker-compose.yml が見つかりません (DEV_RULES §5)"
  fi

  # --- Web app .env.local.example ---
  # Check common web directories
  for webdir in web frontend; do
    if [ -d "$webdir" ]; then
      if [ -f "$webdir/.env.local.example" ]; then
        pass "$webdir/.env.local.example が存在する (DEV_RULES §4)"
      else
        error "$webdir/.env.local.example が見つかりません (DEV_RULES §4)"
      fi
      break
    fi
  done

  # --- requirements.md implementation check ---
  if [ -n "$SPEC_DIR" ] && [ -f "$SPEC_DIR/requirements.md" ]; then
    pass "requirements.md が存在する（実装との照合は AI コマンドで実施）"
  fi
fi

# =============================================================================
# Summary
# =============================================================================
echo ""
echo "═══════════════════════════════════════════"
echo "  Phase:    $PHASE"
echo "  PASS:     $PASSES"
echo "  FAIL:     $ERRORS"
echo "  WARNINGS: $WARNINGS"
echo "═══════════════════════════════════════════"

if [ "$ERRORS" -gt 0 ]; then
  echo ""
  echo "⛔ GOVERNANCE GATE FAILED — 後続フローへの進行を停止します"
  echo "   上記の ❌ FAIL 項目を解消してから再実行してください。"
  exit 1
fi

echo ""
echo "✅ GOVERNANCE GATE PASSED"
exit 0
