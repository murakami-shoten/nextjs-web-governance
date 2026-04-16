# ヒアリング規約（HEARING_RULES）

> 本ルールはヒアリング（要件ヒアリング）から要件確定までのプロセスを定義する。
> 他の規約（DEV_RULES, SECURITY_RULES 等）は「ヒアリングが完了していること」を前提としているため、本ルールは**全ての規約より先に適用**される。

---

## 1. 必須条件（MUST）

### 1.1 ヒアリング深度の判定（最初に行うこと）

仕様策定・実装を開始する前に、**ヒアリング深度（Tiered Hearing Level）を判定**すること。

| レベル | コンテキスト | 判定基準 | 使用するテンプレート |
|---|---|---|---|
| **L1: Full** | 初期構築・大規模リニューアル | 新規プロジェクト、または既存プロジェクトの大幅な再構築 | `HEARING_SHEET.md` → `REQUIREMENTS_TEMPLATE.md` |
| **L2: Feature** | 機能追加・改修 | 既存プロジェクトへの機能追加、既存機能の変更 | `FEATURE_HEARING_CHECKLIST.md` → `FEATURE_SPEC_TEMPLATE.md` |
| **L3: Bugfix** | バグ修正 | バグ報告への対応、不具合の修正 | `BUGFIX_SPEC_TEMPLATE.md` §1 |

**判断がつかない場合は L2 を選択**し、ヒアリング中に L1 へのエスカレートが必要と判断された場合は切り替える。

**いずれのレベルでも以下の原則は共通:**
- 推測禁止（ユーザーに確認する）
- 未確定事項は `TBD` または `[NEEDS CLARIFICATION]` で明示
- 合意済みの要件は再質問しない

### 1.2 レベル別の必須条件

#### L1: Full（初期構築）

- `docs/governance/requirements/HEARING_SHEET.md` の**全 Must 項目**についてユーザーへのヒアリングを完了すること
- Must 項目に `TBD（未質問）` が残っている場合、**仕様策定・計画立案・実装に進んではならない**
- Should 項目の `TBD（未質問）` は、リスクを明示した上で後続フェーズへ進むことを許容する

#### L2: Feature（機能追加）

- `docs/governance/requirements/FEATURE_HEARING_CHECKLIST.md` の**全 Must 項目**についてユーザーへのヒアリングを完了すること
- 既存の要件定義書（REQUIREMENTS）が存在する場合、それを読んだ上で差分のみヒアリングする
- 影響範囲の確認を必ず行うこと（既存機能への副作用がないか）

#### L3: Bugfix（バグ修正）

- `docs/governance/requirements/BUGFIX_SPEC_TEMPLATE.md` の **§1 バグ概要**（再現手順・重大度・影響範囲）をユーザーに確認すること
- クリティカルパス（CV 導線・決済・認証等）のバグは、`BUGFIX_SPEC_TEMPLATE.md` を使用して完全な仕様書を作成すること
- タイポ・1行修正で解決する軽微なバグは即席修正で十分（ヒアリング不要）

### 1.3 ヒアリング結果の保存

ヒアリング結果は**仕様ディレクトリ**に保存する。保存先は利用環境に応じて決まる:

| 環境 | 保存先 | 備考 |
|---|---|---|
| **spec-kit + NWG** | `specs/<NNN>-<name>/requirements.md` | spec.md と同階層。implement が自動参照 |
| **WSK（spec-kit なし）** | `docs/projects/<slug>/REQUIREMENTS_<slug>.md` | AGENTS.md が参照を指示 |

- 要件定義書のテンプレートは `docs/governance/requirements/REQUIREMENTS_TEMPLATE.md` を複製して作成する（テンプレートは編集しない）
- TBD が残る場合は以下の形式で明示する:
  - `TBD（未質問）` — ヒアリング未実施（Must 項目では禁止）
  - `TBD（確認済/理由/期限）` — ヒアリング済みだが未確定（許容）

### 1.4 要件の合意

- ヒアリング結果を要件定義書に反映した後、以下を列挙してユーザーと合意を取ること:
  - 要件の矛盾
  - 未確定事項とその影響
  - リスク（SEO / 法務 / アクセシビリティ / セキュリティ / 運用）

---

## 2. ヒアリングプロセス

### 2.1 レベル別の手順

#### L1: Full（初期構築）

1. `docs/governance/requirements/HEARING_SHEET.md` を確認し、未記入項目を抽出する
2. 未記入項目について**ユーザーに質問**して回答を得る（推測禁止）
3. `docs/governance/requirements/REQUIREMENTS_TEMPLATE.md` を複製し、仕様ディレクトリに `requirements.md` として作成する（テンプレートは編集しない）
4. 回答を要件定義書に反映する（TBD は TBD のまま明示）
5. 要件の矛盾 / 未確定 / リスクを列挙してユーザーと合意を取る

#### L2: Feature（機能追加）

1. 既存の要件定義書（requirements.md）が存在すれば読み込む
2. `docs/governance/requirements/FEATURE_HEARING_CHECKLIST.md` の Must 項目をユーザーに確認する
3. 既存の要件定義書に追記するか、`docs/governance/requirements/FEATURE_SPEC_TEMPLATE.md` を使用して機能仕様書を作成する
4. 影響範囲（既存機能への副作用）を明確にする
5. ユーザーと合意を取る

#### L3: Bugfix（バグ修正）

1. バグの再現手順・重大度・影響範囲をユーザーに確認する
2. 複雑なバグの場合は `docs/governance/requirements/BUGFIX_SPEC_TEMPLATE.md` を使用してバグ修正仕様書を作成する
3. §2（動作分析: 現在の動作 / 期待する動作 / 変更してはならない動作）を明確にする
4. ユーザーと合意を取る

### 2.2 ヒアリングの進め方（全レベル共通）

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

### 3.1 保存先

- ヒアリング結果は `specs/<NNN>-<name>/requirements.md` に保存する（spec.md と同階層）
- `/speckit.implement` は `specs/<NNN>/` 内の全ファイルを自動で読み込むため、requirements.md も自動的に参照される

### 3.2 各フェーズでの適用

| フェーズ | 適用ルール |
|---|---|
| `/speckit.specify` | spec.md を作成する前に §1.1 でヒアリング深度を判定し、requirements.md をこのディレクトリに保存すること |
| `/speckit.plan` | Constitution Check で requirements.md の存在と Must 項目の完了を確認すること |
| `/speckit.tasks` | requirements.md を読み、plan.md の Governance Compliance Plan / Requirements Traceability をタスクに展開すること |
| `/speckit.implement` | 自動参照（テンプレート変更不要） |
| `/speckit.checklist` | requirements.md の全 Must 要件が実装されていることを検証すること |

### 3.3 レベル別のテンプレート展開

| レベル | /speckit.specify での入力 | 出力ファイル |
|---|---|---|
| L1 | HEARING_SHEET.md → REQUIREMENTS_TEMPLATE.md を複製 | `specs/<NNN>/requirements.md` + `spec.md` |
| L2 | FEATURE_HEARING_CHECKLIST.md の結果 | `specs/<NNN>/requirements.md` + `spec.md` |
| L3 | BUGFIX_SPEC_TEMPLATE.md §1 の結果 | `specs/<NNN>/requirements.md` + `spec.md` |

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

- ヒアリングシート（L1 用）: `docs/governance/requirements/HEARING_SHEET.md`
- 機能追加ヒアリングチェックリスト（L2 用）: `docs/governance/requirements/FEATURE_HEARING_CHECKLIST.md`
- バグ修正仕様書テンプレート（L3 用）: `docs/governance/requirements/BUGFIX_SPEC_TEMPLATE.md`
- 要件定義テンプレート: `docs/governance/requirements/REQUIREMENTS_TEMPLATE.md`
- 機能仕様書テンプレート: `docs/governance/requirements/FEATURE_SPEC_TEMPLATE.md`
- SOW テンプレート: `docs/governance/requirements/SOW_TEMPLATE.md`
- 品質ゲート: `docs/governance/rules/QUALITY_GATES.md`

（作成日: 2026-04-15 JST / 更新日: 2026-04-16 JST）
