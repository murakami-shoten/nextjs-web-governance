# spec-kit 連携

[spec-kit](https://github.com/github/spec-kit) は、AI を活用した仕様駆動開発（Spec-Driven Development）のツールキットです。本規約群は **2 つの仕組み** で spec-kit のワークフローと統合します:

1. **テンプレートオーバーライド** — 各フェーズの出力フォーマットにガバナンス要件を埋め込む
2. **NWG Governance Extension** — 各フェーズの前後で hooks を発火し、ルール準拠を検証する

> **前提**: spec-kit の利用には Python 3.11+ と [uv](https://docs.astral.sh/uv/) が必要です。

## 導入手順

```bash
# 1. spec-kit プロジェクトを作成（未作成の場合）
specify init my-project --ai claude
cd my-project

# 2. インストーラーを実行（サブモジュール追加 + テンプレートオーバーライド配置）
curl -sL https://raw.githubusercontent.com/murakami-shoten/nextjs-web-governance/main/speckit/install.sh | bash

# 3. コミット
git add . && git commit -m "feat: integrate governance rules"
```

インストーラーが自動で行うこと：

1. `docs/governance/` に本リポジトリをサブモジュール追加
2. `speckit/overrides/` 内のテンプレートを `.specify/templates/overrides/` にコピー
3. NWG Governance Extension をインストール（`specify extension add --dev`）

## 導入後のコマンドフロー

以下は spec-kit の標準ワークフローです。導入後は **テンプレートオーバーライド**（出力フォーマット制御）と **Extension hooks**（進行可否ゲート）の二重防御により、各ステップで規約準拠が検証されます。

```
/speckit-constitution   ← 任意。9原則 + Priority Resolution が constitution.md に含まれる。
        ↓
  🔌 [before_specify hook] → pre-check: ヒアリング深度判定 + rules/*.md 動的走査
        ↓
/speckit-specify        ← 仕様策定。HEARING GATE + Design Deliverables + 動的ルール走査。
        ↓                 推測禁止: Must 未回答は TBD として残す。
  🔌 [before_plan hook] → gate-check: requirements.md 検証 + TBD/AI推測 検出
        ↓
/speckit-plan           ← 実装計画。品質ゲート 7 項目 + Requirements Traceability。
        ↓
  🔌 [before_tasks hook] → gate-check: requirements.md 検証
        ↓
/speckit-tasks          ← タスク分解。Phase 2.5 (Design Review Gate) + ガバナンスタスク。
        ↓
  🔌 [before_implement hook] → gate-check: 上記 + ワイヤーフレーム承認検証
        ↓
/speckit-implement      ← 実装。
        ↓
  🔌 [after_implement hook] → quality-gate: 品質ゲート 7 項目実行 + 全ルール準拠検証
        ↓
/speckit-checklist      ← 最終チェック。全規約準拠を体系的に検証。
```

> **注意**:
> - 本ドキュメントでは `/speckit-*` の表記を使用していますが、コマンドのプレフィックスは AI エージェントにより異なります（例: Claude では `/`、他のエージェントでは `$` 等）。実際のプレフィックスは使用する AI エージェントの spec-kit 設定に従ってください。
> - コマンド名自体も spec-kit のバージョンにより変わる可能性があります。最新の情報は [spec-kit README](https://github.com/github/spec-kit) を参照してください。

## テンプレートオーバーライドの仕組み

### 目的

spec-kit はデフォルトで汎用テンプレート（`spec-template.md`, `plan-template.md` 等）を使用して仕様書や計画書を生成する。これらの汎用テンプレートには本規約群固有の品質基準（EARS 記法、品質ゲート 7 項目、CSP/SEO 要件等）が含まれないため、AI エージェントが仕様策定・計画立案する際に規約が考慮されない問題があった。

テンプレートオーバーライドにより、各ワークフロー段階の **出力フォーマット** にガバナンス要件を埋め込む。Extension hooks により、各段階の **進行可否** を検証する。

### 各テンプレートの役割

| テンプレート | spec-kit ワークフロー | 追加内容 | 効果 |
|---|---|---|---|
| `constitution-template.md` | `/speckit-constitution`（憲法策定） | Core Principles 9 項目（Top 10 違反頻出条項含む）+ Tiered Hearing レベル参照 | プロジェクトの最上位原則として規約が位置づけられ、具体条項が AI のコンテキストに常駐 |
| `spec-template.md` | `/speckit-specify`（仕様策定） | HEARING GATE（L1/L2/L3 分岐）、EARS 記法ガイド、非機能要件テーブル、規約ファイル直接参照指示 | ヒアリング結果（requirements.md）の保存を強制し、仕様書の作成時に品質観点が漏れなく検討される |
| `plan-template.md` | `/speckit-plan`（実装計画） | Constitution Check（Tiered Hearing 対応）、Governance Compliance Plan、品質ゲート 7 項目、Requirements Traceability | AI が requirements.md と規約ファイルを直接読み、条項をタスクにマッピングする |
| `tasks-template.md` | `/speckit-tasks`（タスク分解） | ガバナンスタスク展開指示（requirements.md 読み込み、品質ゲート実行、チェックリスト検証） | plan.md のガバナンス項目が確実にタスクに展開される |
| `checklist-template.md` | `/speckit-checklist`（品質チェック） | ヒアリング完了検証（L1/L2/L3 分岐）、requirements.md 実装検証、規約別チェックリスト | 実装後の規約準拠を体系的に検証 |

### テンプレート解決の仕組み

```
spec-kit の「テンプレート解決スタック」を活用:

  resolve_template("spec-template") の探索順:

    1. .specify/templates/overrides/spec-template.md  ← governance 版（最優先）✅
    2. .specify/presets/<preset>/templates/spec-template.md
    3. .specify/extensions/<ext>/templates/spec-template.md
    4. .specify/templates/spec-template.md              ← spec-kit デフォルト

  → overrides/ にファイルがあれば、spec-kit デフォルトは使われない
```

### 処理フロー

```
┌──────────────────────────────────────────────────────┐
│ インストール時（install.sh 実行）                      │
│                                                      │
│  1. docs/governance/ にサブモジュール追加             │
│     → speckit/overrides/ を含む規約群がローカルに展開 │
│                                                      │
│  2. speckit/overrides/*.md を                         │
│     .specify/templates/overrides/ にコピー            │
└──────────────────────────────────────────────────────┘
         ↓
┌──────────────────────────────────────────────────────┐
│ 開発時（AI エージェントが spec-kit コマンドを実行）    │
│                                                      │
│  /speckit-constitution                               │
│    → resolve_template() で overrides/constitution-  │
│      template.md を取得し、constitution.md を生成     │
│    → 9原則 + Tiered Hearing が自動的に含まれる       │
│                                                      │
│  /speckit-specify                                    │
│    → create-new-feature.sh が resolve_template() で  │
│      overrides/spec-template.md を取得               │
│    → 生成される spec.md に EARS 記法ガイドや          │
│      非機能要件テーブルが含まれる                     │
│                                                      │
│  /speckit-plan                                       │
│    → setup-plan.sh が resolve_template() で           │
│      overrides/plan-template.md を取得               │
│    → 生成される plan.md に品質ゲート 7 項目           │
│      チェックリストが含まれる                         │
└──────────────────────────────────────────────────────┘
```

## テンプレートの更新

`speckit/overrides/` のテンプレートを更新した場合、既存プロジェクトへの反映手順:

```bash
# 1. governance サブモジュールを最新に更新
cd docs/governance && git pull origin main && cd ../..

# 2. overrides を再コピー
cp docs/governance/speckit/overrides/*.md .specify/templates/overrides/

# 3. コミット
git add docs/governance .specify/templates/overrides/
git commit -m "chore: update governance template overrides"
```

## ディレクトリ構成

```
speckit/
├── README.md           ← このファイル（仕組み・導入手順・コマンドフロー）
├── install.sh          ← インストーラースクリプト
├── overrides/          ← テンプレートオーバーライド（出力フォーマット制御）
│   ├── spec-template.md         ← 仕様策定（Design Deliverables + 動的ルール走査 + NFR）
│   ├── plan-template.md         ← 実装計画（品質ゲート + Requirements Traceability）
│   ├── tasks-template.md        ← タスク分解（Phase 2.5 + ガバナンスタスク展開）
│   ├── constitution-template.md ← 憲法（9原則 + Priority Resolution）
│   └── checklist-template.md    ← 品質チェック（全規約コンプライアンス）
└── extension/          ← NWG Governance Extension（進行可否ゲート）
    ├── extension.yml            ← マニフェスト（hooks 定義）
    ├── commands/
    │   ├── pre-check.md         ← before_specify: ヒアリング深度 + ルール走査
    │   ├── gate-check.md        ← before_plan/tasks/implement: requirements 検証
    │   └── quality-gate.md      ← after_implement: 品質ゲート + ルール準拠
    └── scripts/bash/
        └── governance-check.sh  ← 構造チェックスクリプト
```

## ヒアリング結果の保存先

spec-kit 環境では、ヒアリング結果は `specs/<NNN>-<name>/requirements.md` に保存する（spec.md と同階層）。

- `/speckit.implement` は `specs/<NNN>/` 内の全ファイルを自動で読み込むため、requirements.md も自動的に参照される
- WSK 環境（spec-kit なし）では `docs/projects/<slug>/REQUIREMENTS_<slug>.md` に保存する
- 詳細: `docs/governance/rules/HEARING_RULES.md` §1.3
