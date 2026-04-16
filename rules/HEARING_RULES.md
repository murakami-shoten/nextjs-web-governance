# ヒアリング規約（HEARING_RULES）

> 本ルールはヒアリング（要件ヒアリング）から要件確定までのプロセスを定義する。
> 他の規約（DEV_RULES, SECURITY_RULES 等）は「ヒアリングが完了していること」を前提としているため、本ルールは**全ての規約より先に適用**される。

---

## 1. 必須条件（MUST）

### 1.1 ヒアリングの実施

- 仕様策定・実装を開始する前に、`docs/governance/requirements/HEARING_SHEET.md` の**全 Must 項目**についてユーザーへのヒアリングを完了すること
- Must 項目に `TBD（未質問）` が残っている場合、**仕様策定・計画立案・実装に進んではならない**
- Should 項目の `TBD（未質問）` は、リスクを明示した上で後続フェーズへ進むことを許容する

### 1.2 ヒアリング結果の保存

- ヒアリング結果は `docs/projects/<project_slug>/REQUIREMENTS_<project_slug>.md` に転記すること
- 要件定義書は `docs/governance/requirements/REQUIREMENTS_TEMPLATE.md` を複製して作成する（テンプレートは編集しない）
- TBD が残る場合は以下の形式で明示する:
  - `TBD（未質問）` — ヒアリング未実施（Must 項目では禁止）
  - `TBD（確認済/理由/期限）` — ヒアリング済みだが未確定（許容）

### 1.3 要件の合意

- ヒアリング結果を要件定義書に反映した後、以下を列挙してユーザーと合意を取ること:
  - 要件の矛盾
  - 未確定事項とその影響
  - リスク（SEO / 法務 / アクセシビリティ / セキュリティ / 運用）

---

## 2. ヒアリングプロセス

### 2.1 手順

1. `docs/governance/requirements/HEARING_SHEET.md` を確認し、未記入項目を抽出する
2. 未記入項目について**ユーザーに質問**して回答を得る（推測禁止）
3. `docs/governance/requirements/REQUIREMENTS_TEMPLATE.md` を複製し、`docs/projects/<project_slug>/REQUIREMENTS_<project_slug>.md` を作成する（テンプレートは編集しない）
4. 回答を新規作成した要件定義書に反映する（TBD は TBD のまま明示）
5. 要件の矛盾 / 未確定 / リスクを列挙してユーザーと合意を取る

### 2.2 ヒアリングの進め方

- **一問一答または少数ずつ進める**: 一度に全ての質問をせず、対話的に進めること
- **合意済みの要件は再質問しない**: ヒアリング済みの項目を繰り返し確認しない
- **推測禁止**: ユーザーが回答していない項目を AI エージェントが推測で埋めてはならない
- **日本語で対話**: ユーザーとの対話・質問は原則として日本語で行うこと

### 2.3 TBD 表記ルール

ヒアリングシート・要件定義書における TBD の扱い:

| 表記 | 意味 | Must 項目での許容 |
|---|---|---|
| `TBD（未質問）` | まだユーザーに質問していない | ❌ 禁止（仕様策定に進めない） |
| `TBD（確認済/理由/期限）` | ユーザーに確認したが未確定（理由と確定予定時期を明記） | ✅ 許容 |
| 具体的な回答 | ヒアリング完了 | ✅ 完了 |

---

## 3. spec-kit 環境での適用

spec-kit（`/speckit.specify`, `/speckit.plan` 等）を使用する環境では、本ルールは以下のように適用される:

- `/speckit.specify` を実行する前に §1.1 の必須条件を満たすこと
- spec.md の作成時は `$ARGUMENTS`（1行記述）だけでなく、`REQUIREMENTS_<slug>.md` を入力ソースとして参照すること
- `/speckit.plan` の Constitution Check に「HEARING_SHEET.md の Must 項目に TBD（未質問）が 0 件」を含めること
- plan.md の Requirements Traceability テーブルで、REQUIREMENTS の全 Must 要件が実装タスクにマッピングされていることを確認すること
- `/speckit.checklist` で、REQUIREMENTS の全 Must 要件が実装されていることを検証すること

---

## 4. ワークフロー選択

### 4.1 原則: Requirements-First

ヒアリング → 要件定義 → ワイヤーフレーム → SOW → 実装 の順で進める。

### 4.2 Design-First を検討する条件

以下のいずれかに該当する場合のみ Design-First を検討する:

- 既存のアーキテクチャ設計書 / 技術仕様をポーティングするプロジェクト
- 非機能要件（レイテンシ・スループット・コンプライアンス）が要件より先に固まっている場合
- 技術的実現可能性の検証（PoC）が先行するプロジェクト

Design-First の場合: 設計 → 要件（設計から導出）→ SOW → 実装 の順で進める。

---

## 5. ワイヤーフレームと SOW の工程順序

- 要件定義合意後、実装 SOW を作成する前にワイヤーフレームを作成・承認する
- ワイヤーフレームが確定しないと画面レベルの受入基準が書けないため、SOW §4（受入基準チェックリスト）の精度が落ちる
- フェーズ分割する場合は「設計フェーズ SOW → ワイヤーフレーム作成・承認 → 実装フェーズ SOW」の順とする

---

## 6. 関連ドキュメント

- ヒアリングシート: `docs/governance/requirements/HEARING_SHEET.md`
- 要件定義テンプレート: `docs/governance/requirements/REQUIREMENTS_TEMPLATE.md`
- SOW テンプレート: `docs/governance/requirements/SOW_TEMPLATE.md`
- 品質ゲート: `docs/governance/rules/QUALITY_GATES.md`
