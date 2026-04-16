# 要件定義書の生成ルール（GENERATE_REQUIREMENTS）

（作成日: 2026-01-27 JST / 更新日: 2026-04-16 JST）

## 方針
- `docs/governance/requirements/REQUIREMENTS_TEMPLATE.md` はテンプレとして保持し、**編集しない**
- ヒアリング完了後、テンプレを複製してプロジェクト固有の要件定義書を作成する
- 要件定義書に合意したら、フェーズごとに SOW を作成し、スコープ/成果物/受入基準/リスクを明記する（テンプレ: `docs/governance/requirements/SOW_TEMPLATE.md`）

## 作成場所と命名

> **保存先は利用環境によって異なる**（詳細: `docs/governance/rules/HEARING_RULES.md` §1.3）

### spec-kit + NWG 環境
- 置き場所: `specs/<NNN>-<name>/`（spec-kit が管理する仕様ディレクトリ）
- ファイル名: `requirements.md`（spec.md と同階層に配置）
- SOW は同ディレクトリに `sow_<phase>.md` として保存

### WSK（spec-kit なし）環境
- 置き場所: `docs/projects/<project_slug>/`
- ファイル名: `REQUIREMENTS_<project_slug>.md`
  - `<project_slug>` は **英小文字 + 数字 + `-`** のみ（例: `my-corp-site`）
  - スペース、日本語、記号は避ける（差分・URL・CIとの相性を優先）
- SOW は `docs/governance/requirements/SOW_TEMPLATE.md` を複製し、同ディレクトリに `SOW_<phase>.md` として保存（例: `SOW_design.md`, `SOW_dev.md`）。`<phase>` は英小文字+数字+`-` で簡潔に。

## 生成コマンド例（mac/linux — WSK 環境）
```bash
PROJECT_SLUG="my-corp-site"
mkdir -p "docs/projects/${PROJECT_SLUG}"
cp "docs/governance/requirements/REQUIREMENTS_TEMPLATE.md" \
   "docs/projects/${PROJECT_SLUG}/REQUIREMENTS_${PROJECT_SLUG}.md"
```

## テンプレ保護（任意）
- CIでテンプレの差分を検知し、変更があれば失敗させる
- もしくは CODEOWNERS でテンプレ編集を制限する
