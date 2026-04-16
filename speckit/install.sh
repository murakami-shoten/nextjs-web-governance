#!/bin/bash
# =============================================================================
# install-for-speckit.sh
#
# spec-kit プロジェクトに nextjs-web-governance の規約群を導入するインストーラー。
#
# 使い方:
#   cd /path/to/your-speckit-project
#   curl -sL https://raw.githubusercontent.com/murakami-shoten/nextjs-web-governance/main/speckit/install.sh | bash
#
# 前提:
#   - spec-kit が初期化済みのプロジェクト（.specify/ が存在する）
#   - Git が利用可能
#
# 処理内容:
#   1. spec-kit プロジェクトかどうか確認
#   2. docs/governance/ に nextjs-web-governance をサブモジュール追加
#   3. テンプレートオーバーライドを .specify/templates/overrides/ に配置
#   4. constitution.md を事前定義版で上書き
# =============================================================================
set -euo pipefail

# --- 設定 ---
REPO_URL="https://github.com/murakami-shoten/nextjs-web-governance.git"
INSTALL_PATH="docs/governance"
OVERRIDES_SRC="$INSTALL_PATH/speckit/overrides"
OVERRIDES_DST=".specify/templates/overrides"

# --- 色定義 ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# --- ヘルパー関数 ---
info()  { echo -e "${GREEN}✅ $1${NC}"; }
warn()  { echo -e "${YELLOW}⚠️  $1${NC}"; }
error() { echo -e "${RED}❌ $1${NC}"; exit 1; }

# =============================================================================
# Step 1: 事前チェック
# =============================================================================
echo ""
echo "🔧 nextjs-web-governance → spec-kit 連携インストーラー"
echo "======================================================="
echo ""

# spec-kit プロジェクトかどうか確認
if [ ! -d ".specify" ]; then
  error ".specify/ ディレクトリが見つかりません。spec-kit プロジェクトのルートで実行してください。"
fi

# Git リポジトリかどうか確認
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
  error "Git リポジトリではありません。git init を先に実行してください。"
fi

# =============================================================================
# Step 2: 規約をサブモジュールとして追加
# =============================================================================
if [ -d "$INSTALL_PATH" ]; then
  warn "$INSTALL_PATH は既に存在します。サブモジュールの追加をスキップします。"
else
  echo "📥 nextjs-web-governance の規約群をダウンロード中..."
  git submodule add "$REPO_URL" "$INSTALL_PATH"
  info "規約を $INSTALL_PATH に配置しました。"
fi

# =============================================================================
# Step 3: テンプレートオーバーライドを配置
# =============================================================================
echo "📝 テンプレートオーバーライドを配置中..."

# オーバーライドソースの存在確認
if [ ! -d "$OVERRIDES_SRC" ]; then
  error "$OVERRIDES_SRC が見つかりません。nextjs-web-governance のバージョンが古い可能性があります。"
fi

# オーバーライド先ディレクトリを作成
mkdir -p "$OVERRIDES_DST"

# 各テンプレートをコピー（既存ファイルは上書きしない）
TEMPLATES=("spec-template.md" "plan-template.md" "constitution-template.md" "checklist-template.md" "tasks-template.md")
COPIED=0
SKIPPED=0

for template in "${TEMPLATES[@]}"; do
  src="$OVERRIDES_SRC/$template"
  dst="$OVERRIDES_DST/$template"

  if [ ! -f "$src" ]; then
    warn "ソースファイルが見つかりません: $src（スキップ）"
    continue
  fi

  if [ -f "$dst" ]; then
    warn "$dst は既に存在します。上書きしません。"
    SKIPPED=$((SKIPPED + 1))
  else
    cp "$src" "$dst"
    COPIED=$((COPIED + 1))
  fi
done

info "テンプレートオーバーライドを配置しました（${COPIED} 件コピー / ${SKIPPED} 件スキップ）。"

# =============================================================================
# 完了メッセージ
# =============================================================================
echo ""
echo "======================================================="
info "インストールが完了しました！"
echo ""
echo "📋 セットアップ済みの内容:"
echo ""
echo "  ✅ docs/governance/       — 規約群（サブモジュール）"
echo "  ✅ .specify/templates/overrides/ — テンプレートオーバーライド"
echo "     - spec-template.md    — HEARING GATE + EARS 記法 + 非機能要件テーブル + 規約参照指示"
echo "     - plan-template.md    — Governance Compliance Plan + 品質ゲート 7 項目 + Requirements Traceability"
echo "     - tasks-template.md   — ガバナンスタスク展開 + requirements.md 参照指示"
echo "     - constitution-template.md — Core Principles 9 項目 + Tiered Hearing（Top 10 違反頻出条項含む）"
echo "     - checklist-template.md — 規約準拠チェックリスト（Tiered Hearing 対応）"
echo ""
echo "📋 次のステップ:"
echo ""
echo "  1. AI エージェント（Claude Code 等）を起動"
echo "  2. speckit-constitution を実行して Constitution を生成する"
echo "     （オーバーライドテンプレートにより 9 原則が自動的に含まれます）"
echo "  3. speckit-specify で仕様策定を開始"
echo "  4. git add . && git commit -m 'feat: integrate governance rules'"
echo ""
echo "  ⚠️  コマンドのプレフィックスは AI エージェントにより異なります"
echo "     （例: Claude では / 、他のエージェントでは \$ 等）"
echo ""
echo "📖 詳細: https://github.com/murakami-shoten/nextjs-web-governance/tree/main/speckit"
echo "======================================================="

