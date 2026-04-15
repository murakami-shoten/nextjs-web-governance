# nextjs-web-governance

[![License: MIT](https://img.shields.io/github/license/murakami-shoten/nextjs-web-governance)](LICENSE)
[![GitHub stars](https://img.shields.io/github/stars/murakami-shoten/nextjs-web-governance)](https://github.com/murakami-shoten/nextjs-web-governance/stargazers)
[![GitHub last commit](https://img.shields.io/github/last-commit/murakami-shoten/nextjs-web-governance)](https://github.com/murakami-shoten/nextjs-web-governance/commits/main)

Web Starter Kit の開発規約・テンプレート・品質基準。Next.js + Docker + TypeScript に特化。

## 概要

このリポジトリは、Web 開発プロジェクトの品質と一貫性を担保するための規約・テンプレート・チェックリストを集約したものです。[Web Starter Kit](https://github.com/murakami-shoten/web-starter-kit) から規約群を独立させ、複数プロジェクトやツールから再利用できるようにしています。

## 対象技術スタック

- **フレームワーク**: Next.js（App Router）+ TypeScript
- **コンテナ**: Docker Compose（開発・テスト・CI をコンテナ内で完結）
- **ホスティング**: Vercel / セルフホスト対応
- **設計思想**: 疎結合・低ロックイン・国際標準準拠

## 構成

```
rules/              開発・アーキテクチャ・セキュリティ等の規約（13ファイル）
requirements/       要件定義・SOW・機能仕様書のテンプレート群
runbooks/           リリースチェックリスト等の運用手順書
speckit/            spec-kit 連携（インストーラー + テンプレートオーバーライド）
```

### rules/（規約）

| ファイル | 内容 |
|---|---|
| `DEV_RULES.md` | 開発規約（コミット規約、ブランチ戦略、コードスタイル） |
| `ARCHITECTURE_RULES.md` | アーキテクチャ規約（疎結合、レイヤー構成） |
| `SECURITY_RULES.md` | セキュリティ規約（CSP、HSTS、入力検証、ASVS） |
| `QUALITY_GATES.md` | 品質ゲート（7項目必須ゲート + 推奨ゲート） |
| `DESIGN_RULES.md` | UI/UXデザイン規約（ISO 9241、Nielsen ヒューリスティクス） |
| `SEO_RULES.md` | SEO規約（Google推奨準拠） |
| `PERFORMANCE_RULES.md` | パフォーマンス規約（CWV、フォント最適化） |
| `LOW_LOCKIN_RULES.md` | 低ロックイン方針 |
| `EMAIL_RULES.md` | メール送信規約（SPF/DKIM/DMARC） |
| `LLMO_RULES.md` | LLMO規約（LLM最適化、llms.txt） |
| `CONTENT_RULES.md` | コンテンツ可搬性（MDX運用） |
| `OBSERVABILITY_RULES.md` | 可観測性・ログ方針 |
| `OPERATIONS.md` | 運用規約 |

### requirements/（テンプレート）

| ファイル | 内容 |
|---|---|
| `HEARING_SHEET.md` | ヒアリングシート |
| `REQUIREMENTS_TEMPLATE.md` | 要件定義書テンプレート（EARS記法ガイド付き） |
| `SOW_TEMPLATE.md` | SOW（Statement of Work）テンプレート |
| `SOW_RELEASE_PREP_TEMPLATE.md` | リリース準備SOWテンプレート |
| `FEATURE_SPEC_TEMPLATE.md` | 機能仕様書テンプレート（BDD対応、Phase -1 Gate付き） |
| `BUGFIX_SPEC_TEMPLATE.md` | バグ修正仕様書テンプレート |
| `QUALITY_REPORT_TEMPLATE.md` | 品質保証レポートテンプレート |
| `GENERATE_REQUIREMENTS.md` | 要件定義書生成ガイド |

### speckit/（spec-kit 連携）

[spec-kit](https://github.com/github/spec-kit) のワークフローで本規約群を **仕組みとして強制する** ためのテンプレートオーバーライドとインストーラー。

詳細（導入手順・仕組み・コマンドフロー）は **[speckit/README.md](speckit/README.md)** を参照。

## 利用方法

### Web Starter Kit で使う場合

Web Starter Kit テンプレートから作成したプロジェクトでは、`docs/governance/` にサブモジュールとして組み込まれています。

```bash
# サブモジュールの初期化（クローン後）
git submodule update --init

# 規約の最新版に更新
cd docs/governance && git pull origin main && cd ../..
git add docs/governance && git commit -m "chore: update governance rules"
```

### spec-kit プロジェクトで使う場合

詳細は **[speckit/README.md](speckit/README.md)** を参照。クイックスタート：

```bash
curl -sL https://raw.githubusercontent.com/murakami-shoten/nextjs-web-governance/main/speckit/install.sh | bash
```

### 単独で使う場合

```bash
git submodule add https://github.com/murakami-shoten/nextjs-web-governance.git docs/governance
```

## ⚠️ 構造変更に関する注意

> **このリポジトリは複数のプロジェクトから Git サブモジュールとして参照されています。**
> 構造的改変は参照元プロジェクトのパス参照を破壊する可能性があります。

### 許可不要（通常のメンテナンス）

- 既存ファイルの内容修正・追記
- 新規ファイルの追加（既存ディレクトリ内）

### 要許可（構造的改変）

以下の変更を行う場合は、参照元プロジェクトへの影響を確認し、関係者の合意を得てから実施すること:

- ディレクトリ名の変更（`rules/`, `requirements/`, `runbooks/`, `speckit/`）
- 既存ファイルの移動・リネーム・削除
- ディレクトリ階層の変更
- `speckit/install.sh` の curl URL 変更（spec-kit 連携プロジェクトのドキュメントに影響）

### 参照元プロジェクト（既知）

- [murakami-shoten/web-starter-kit](https://github.com/murakami-shoten/web-starter-kit) — `docs/governance/` としてサブモジュール参照
- spec-kit 連携プロジェクト — 同じく `docs/governance/` としてサブモジュール参照

## ライセンス

MIT License - 詳細は [LICENSE](LICENSE) を参照。

