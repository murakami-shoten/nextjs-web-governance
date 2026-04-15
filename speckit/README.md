# spec-kit 連携

[spec-kit](https://github.com/github/spec-kit) は、AI を活用した仕様駆動開発（Spec-Driven Development）のツールキットです。本規約群はテンプレートオーバーライドにより spec-kit のワークフローと統合できます。

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
3. `.specify/memory/constitution.md` を事前定義版テンプレートで上書き

## 導入後のコマンドフロー

以下は spec-kit の標準ワークフローです。導入後はテンプレートオーバーライドにより、各ステップで本規約群の品質基準が自動的に反映されます。

```
/speckit-constitution   ← 任意。8原則は既に constitution.md に記載済み。
        ↓                 実行するとプロジェクト名等の残りのプレースホルダーを埋める。
                           既存の原則を上書きせず、追記・補完する動作。
/speckit-specify        ← 仕様策定。override 版テンプレートにより EARS 記法ガイドや
        ↓                 非機能要件テーブルが仕様書に自動的に含まれる。
/speckit-plan           ← 実装計画。品質ゲート 7 項目チェックリストと受入基準テーブル
        ↓                 が計画書に自動的に含まれる。
/speckit-tasks          ← plan.md からタスク分解
        ↓
/speckit-implement      ← 実装（品質ゲート通過が計画に組み込み済み）
```

> **注意**:
> - 本ドキュメントでは `/speckit-*` の表記を使用していますが、コマンドのプレフィックスは AI エージェントにより異なります（例: Claude では `/`、他のエージェントでは `$` 等）。実際のプレフィックスは使用する AI エージェントの spec-kit 設定に従ってください。
> - コマンド名自体も spec-kit のバージョンにより変わる可能性があります。最新の情報は [spec-kit README](https://github.com/github/spec-kit) を参照してください。

## テンプレートオーバーライドの仕組み

### 目的

spec-kit はデフォルトで汎用テンプレート（`spec-template.md`, `plan-template.md` 等）を使用して仕様書や計画書を生成する。これらの汎用テンプレートには本規約群固有の品質基準（EARS 記法、品質ゲート 7 項目、CSP/SEO 要件等）が含まれないため、AI エージェントが仕様策定・計画立案する際に規約が考慮されない問題があった。

テンプレートオーバーライドにより、spec-kit の各ワークフロー段階で規約準拠を構造的に保証する。

### 各テンプレートの役割

| テンプレート | spec-kit ワークフロー | 追加内容 | 効果 |
|---|---|---|---|
| `constitution-template.md` | `/speckit-constitution`（憲法策定） | Core Principles 8 項目を事前定義 | プロジェクトの最上位原則として規約が位置づけられる |
| `spec-template.md` | `/speckit-specify`（仕様策定） | EARS 記法ガイド、非機能要件テーブル（Security/Performance/SEO/A11y） | 仕様書の作成時に品質観点が漏れなく検討される |
| `plan-template.md` | `/speckit-plan`（実装計画） | 品質ゲート 7 項目チェックリスト、受入基準テーブル、`frontend/` レイアウト | 実装前に品質ゲート通過が計画に組み込まれる |

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
│                                                      │
│  3. constitution.md を事前定義版で上書き              │
└──────────────────────────────────────────────────────┘
         ↓
┌──────────────────────────────────────────────────────┐
│ 開発時（AI エージェントが spec-kit コマンドを実行）    │
│                                                      │
│  /speckit-constitution                               │
│    → constitution.md に 8原則が記載済み               │
│    → AI はプロジェクト固有情報を追記するだけ          │
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
└── overrides/          ← テンプレートオーバーライド
    ├── spec-template.md
    ├── plan-template.md
    └── constitution-template.md
```
