# セキュリティ規約（SECURITY_RULES）

（作成日: 2026-01-27 JST）

---

## 1. 基準（国際標準/定石）

- OWASP ASVS を“チェックリストの物差し”として使う（少なくとも L1 相当を狙う）
- CSP / セキュリティヘッダーをベース標準として組み込む
- CI相当で「依存脆弱性」「シークレット漏洩」「DAST（コンテナ）」を必須化する（QUALITY_GATES参照）

---

## 2. セキュリティヘッダー（必須）

最低限、以下を標準化（値は要件に応じて調整）:
- Content-Security-Policy（CSP）
- Strict-Transport-Security（HSTS）
- X-Content-Type-Options
- Referrer-Policy
- Permissions-Policy
- (必要に応じて) Cross-Origin-* 系

### 2.1 Next.js 固有の必須設定

- `next.config.mjs` に **`poweredByHeader: false`** を設定する（必須）
  - Next.js はデフォルトで `X-Powered-By: Next.js` レスポンスヘッダーを付与し、フレームワーク情報が露出する
  - OWASP Secure Headers Project で `X-Powered-By` の削除が推奨されている
  - Next.js 公式ドキュメントでも推奨設定として記載

```js
// next.config.mjs
const nextConfig = {
  poweredByHeader: false,  // セキュリティ: X-Powered-By ヘッダーを無効化
  // ...
};
```

> **注意**: 技術スタックの隠蔽だけをセキュリティ対策としないこと。Wappalyzer 等のツールは JS バンドルや HTML 構造からも技術スタックを検出可能。本質的な対策（依存性更新、脆弱性スキャン、CSP 等）を優先する。

### 2.2 UI文言での外部サービス名・技術スタック名の露出禁止

`poweredByHeader: false`（§2.1）は HTTP ヘッダーレベルの対策だが、**ユーザー向け UI 文言**にも同様の原則を適用する。外部サービス名や技術スタック名が UI に含まれると、攻撃者にシステム構成（利用 API・外部サービス・インフラ）を推測させる手がかりとなる。

**ルール:**
- ラベル、注記、エラーメッセージ、ツールチップ、i18n メッセージに外部サービス名・技術スタック名を含めない
- ユーザーに見せる文言は機能・役割ベースで記述する

**例外:**
- プライバシーポリシー、利用規約、法的開示が必要なページでの記載

```
❌ Bad: 「bitFlyer の残高が優先されます」
❌ Bad: 「Stripe で決済処理中です」
❌ Bad: 「PostgreSQL への接続に失敗しました」

✅ Good: 「連携済みの残高が優先されます」
✅ Good: 「決済処理中です」
✅ Good: 「データベースへの接続に失敗しました」
```

**根拠:** OWASP の情報漏洩（Information Disclosure）防止原則に基づく。HTTPヘッダー（§2.1）と UI 文言の両面で多層防御（Defense in Depth）を実現する。

---

## 3. CSP（Next.js）

### 3.1 基本方針

- Next.js のガイドに沿って、nonce等を含む構成を採用する
- `unsafe-inline` を避ける方針を優先（難しい場合は理由と期限を明記）

### 3.2 GTM / GA4 / Google Ads 利用時の CSP ドメインプリセット

GTM 経由で GA4・Google Ads コンバージョン計測を導入する場合、CSP で複数の Google ドメインを許可する必要がある。不足があると **コンバージョンタグがブロックされ、広告最適化に必要なデータが欠損する**（広告出稿中はインシデント級の影響）。

> **実例**: `connect-src` に `*.google.com` が不足していたことで、Google Ads の `ccm/collect` エンドポイントがブロックされ、コンバージョン計測データが送信できない事象が発生した。

#### 必要なドメイン一覧

| ディレクティブ | ドメイン | 用途 |
|---|---|---|
| **script-src** | `https://www.googletagmanager.com` | GTM コンテナスクリプト |
| | `https://www.google-analytics.com` | GA4 スクリプト |
| | `https://www.google.com` | reCAPTCHA / Google Ads |
| | `https://www.google.co.jp` | Google Ads（日本向け） |
| | `https://googleads.g.doubleclick.net` | Google Ads コンバージョンタグ |
| **connect-src** | `https://www.googletagmanager.com` | GTM 設定の取得 |
| | `https://*.google-analytics.com` | GA4 データ送信 |
| | `https://*.analytics.google.com` | GA4 データ送信（別ドメイン） |
| | `https://*.google.com` | Google Ads `ccm/collect`・`pagead/1p-conversion` 等 |
| | `https://*.googleadservices.com` | Google Ads `pagead/conversion` |
| | `https://*.g.doubleclick.net` | DoubleClick 計測 |
| | `https://googleads.g.doubleclick.net` | Google Ads コンバージョン送信 |
| **img-src** | `https://www.googletagmanager.com` | GTM プレビューモード等 |
| | `https://*.google.com` | Google Ads ピクセル（`pagead/1p-conversion` 等。ワイルドカード必須） |
| | `https://www.google.co.jp` | Google Ads ピクセル（日本向け） |
| | `https://*.googleadservices.com` | Google Ads コンバージョンピクセル |
| | `https://googleads.g.doubleclick.net` | DoubleClick ピクセル |
| | `https://*.google-analytics.com` | GA4 ピクセル |
| **frame-src** | `https://td.doubleclick.net` | DoubleClick iframe |
| | `https://www.googletagmanager.com` | GTM プレビューモード |

#### 推奨実装パターン（`next.config.mjs`）

`NEXT_PUBLIC_GTM_ID` の有無で条件分岐し、**GTM を使わないプロジェクトでは不要なドメインを許可しない**設計とする。

```javascript
// next.config.mjs — CSP 構築部分（抜粋）

// GTM / GA4 / Google Ads 用 CSP ドメインプリセット
const gtmCspDomains = process.env.NEXT_PUBLIC_GTM_ID
  ? {
      scriptSrc: [
        "https://www.googletagmanager.com",
        "https://www.google-analytics.com",
        "https://www.google.com",
        "https://www.google.co.jp",
        "https://googleads.g.doubleclick.net",
      ],
      connectSrc: [
        "https://www.googletagmanager.com",
        "https://*.google-analytics.com",
        "https://*.analytics.google.com",
        "https://*.google.com",
        "https://*.googleadservices.com",
        "https://*.g.doubleclick.net",
        "https://googleads.g.doubleclick.net",
      ],
      imgSrc: [
        "https://www.googletagmanager.com",
        "https://*.google.com",
        "https://www.google.co.jp",
        "https://*.googleadservices.com",
        "https://googleads.g.doubleclick.net",
        "https://*.google-analytics.com",
      ],
      frameSrc: [
        "https://td.doubleclick.net",
        "https://www.googletagmanager.com",
      ],
    }
  : { scriptSrc: [], connectSrc: [], imgSrc: [], frameSrc: [] };

// CSP ヘッダー構築時に展開する
// 例: `script-src 'self' 'nonce-${nonce}' ${gtmCspDomains.scriptSrc.join(" ")};`
```

> **注意**: Google のサービスは新しいドメインを追加することがあるため、GTM 導入後はブラウザの DevTools コンソールで CSP 違反がないか定期的に確認すること。新たなブロックが発見された場合は、対象ドメインを追加し、本テンプレートにもフィードバックする。
>
> **公式リファレンス**: [Google Tag Platform — CSP guide](https://developers.google.com/tag-platform/security/guides/csp) に必要ドメインの一次情報がある。上記プリセットはこのガイドおよび実運用での検証結果に基づく。

### 3.3 Google Maps 利用時の CSP ドメイン

Google Maps をサイトに埋め込む場合、埋め込み方式に応じて以下の CSP ドメインを許可する必要がある。

#### iframe 方式（API キー不要）

| ディレクティブ | ドメイン | 用途 |
|---|---|---|
| **frame-src** | `https://www.google.com` | Google Maps 埋め込み iframe |

#### Maps JavaScript API 方式

| ディレクティブ | ドメイン | 用途 |
|---|---|---|
| **script-src** | `https://maps.googleapis.com` | Maps API スクリプト |
| **connect-src** | `https://maps.googleapis.com` | タイルデータ・ジオコーディング等 |
| **img-src** | `https://maps.gstatic.com` | 地図タイル画像 |
| | `https://maps.googleapis.com` | ストリートビュー等の画像 |
| **font-src** | `https://fonts.gstatic.com` | 地図ラベル用フォント |

> **推奨実装パターン**: §3.2 の GTM/GA4 プリセットと同様に、`NEXT_PUBLIC_GOOGLE_MAPS_API_KEY` の有無で条件分岐し、Maps を使わないプロジェクトでは不要なドメインを許可しない設計とする。

---

## 4. 入力・フォーム

### 4.1 入力検証（必須）

- すべてのフォーム入力に対し、**サーバーサイドでの検証を必須**とする（クライアント側検証は UX 目的のみ、セキュリティ境界ではない）
- 検証項目: 型、サイズ上限、形式（正規表現）、必須/任意
- バリデーションライブラリ（例: Zod）でスキーマを定義し、API Route Handler の入口で適用する

### 4.2 スパム対策 / CAPTCHA（必須）

**ユーザー入力を受け付けるすべてのフォーム**（問い合わせ、会員登録、コメント等）に対し、スパム対策を必須で実装する。

#### 推奨サービス（低ロックイン順）

| サービス | 特徴 | ロックイン度 |
|---|---|---|
| [Cloudflare Turnstile](https://developers.cloudflare.com/turnstile/) | 無料・プライバシー重視・GDPR 対応・ユーザー操作不要 | 低 |
| [hCaptcha](https://www.hcaptcha.com/) | 無料プラン有・プライバシー重視・GDPR 対応 | 低 |
| [Google reCAPTCHA v3](https://developers.google.com/recaptcha/docs/v3) | 無料・ユーザー操作不要（スコアベース）・Google 依存 | 中 |

> **選定基準**: プロジェクトの要件定義（HEARING_SHEET.md）でスパム対策方式を合意する。特に指定がなければ **Cloudflare Turnstile** を推奨（無料・ユーザー負荷ゼロ・プライバシー準拠）。

#### 実装要件

1. **クライアント側**: CAPTCHA ウィジェットをフォームに埋め込み、トークンを取得する
2. **サーバー側**: API Route Handler でトークンを**必ずサーバーサイドで検証**する（クライアント側のみの検証は不可）
3. **環境変数**: サイトキー（`NEXT_PUBLIC_CAPTCHA_SITE_KEY`）とシークレットキー（`CAPTCHA_SECRET_KEY`）を環境変数で管理する
4. **フォールバック**: CAPTCHA サービス障害時のフォールバック動作を設計に含める（例: 一時的に honeypot + レート制限のみで受付）
5. **CSP 対応**: 使用する CAPTCHA サービスのドメインを CSP に追加する（§3 参照）

```typescript
// サーバーサイドトークン検証の例（Cloudflare Turnstile）
const verifyResponse = await fetch(
  "https://challenges.cloudflare.com/turnstile/v0/siteverify",
  {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      secret: process.env.CAPTCHA_SECRET_KEY,
      response: captchaToken,
      remoteip: clientIp, // optional
    }),
  }
);
const result = await verifyResponse.json();
if (!result.success) {
  return NextResponse.json({ error: "CAPTCHA検証に失敗しました" }, { status: 403 });
}
```

### 4.3 CSRF 対策

- フォーム送信には CSRF トークンまたは `SameSite=Strict` Cookie を使用する
- API Route Handler が外部サイトからの POST を受け付けないよう、`Origin` / `Referer` ヘッダーを検証する

### 4.4 レート制限（必須）

フォーム送信およびパブリック API に対し、レート制限を実装する。

| 対象 | 推奨制限値 | 実装方法 |
|---|---|---|
| 問い合わせフォーム | 同一 IP から 5 件/時間 | サーバーサイドで制限（例: Upstash Rate Limit、in-memory Map） |
| 認証系 API（ログイン等） | 同一 IP から 10 回/15分 | 同上 |
| パブリック API | 用途に応じて設計 | ミドルウェアで制限 |

> **注意**: レート制限の値はプロジェクト要件に応じて調整する。上記は最低基準。

---

## 5. 依存関係とサプライチェーンセキュリティ

### 5.1 依存脆弱性スキャン（必須）

- 依存脆弱性スキャンを必須化（例: OSV-Scanner）

### 5.2 秘密情報の保護（必須）

- シークレット（鍵/トークン）検出を必須化（例: gitleaks）
- `.env` や秘密鍵はコミット禁止（テンプレのみOK）

### 5.3 サプライチェーン攻撃の緩和（推奨）

npm 公開レジストリ（`registry.npmjs.org`）は GitHub / Microsoft が運営するプロプライエタリサービスだが、**誰でもアカウントを作成してパッケージを公開**でき、事前審査は存在しない。そのため、悪意あるパッケージの混入リスクが構造的に存在する:

- **タイポスクワッティング**: 人気パッケージに似た名前（例: `lodahs`）で悪意あるパッケージを公開
- **postinstall 悪用**: `npm install` 時に自動実行されるスクリプトで任意コード（環境変数窃取等）を実行
- **アカウント乗っ取り**: 正規メンテナの認証情報を窃取し、既存パッケージに悪意あるバージョンを publish
- **スロップスクワッティング**: AI が幻覚した架空パッケージ名を攻撃者が先に登録

以下の多層防御を推奨する（**コスト0で導入可能**）:

| 対策 | 方法 | 効果 |
|---|---|---|
| **install スクリプト無効化** | `.npmrc` に `ignore-scripts=true` | `npm install` 時の任意コード実行を防止 |
| **lockfile 厳密インストール** | Docker / CI では `npm ci` を使用（DEV_RULES §5） | 未承認の依存バージョン変更を防止 |
| **レジストリ署名検証** | `npm audit signatures` を品質ゲートに追加 | レジストリ上でのパッケージ改ざんを検出 |
| **新規依存の事前レビュー** | 依存追加時に「なぜ必要か」を明記（DEV_RULES §6） | 不要な依存の混入防止 |

#### `.npmrc` 推奨設定

プロジェクトルートに `.npmrc` を配置し、Git にコミットする:

```ini
# サプライチェーン攻撃の緩和（SECURITY_RULES §5.3）
# postinstall スクリプトの自動実行を無効化
ignore-scripts=true
```

> **注意**: `ignore-scripts=true` 設定時、一部のパッケージは postinstall スクリプトに依存しており、
> そのままでは正常に動作しない場合がある。下記の対処手順を参照すること。

#### `ignore-scripts=true` でパッケージが動かない場合の対処

**症状**: `npm ci --ignore-scripts` 後にビルドエラーやランタイムエラーが発生する。
`postinstall` スクリプトでコード生成やネイティブバイナリのセットアップを行うパッケージが原因。

**対処手順**:

1. エラーメッセージからどのパッケージの postinstall が必要か特定する
2. Dockerfile で `npm ci` の **後に** 該当パッケージのセットアップコマンドを明示的に実行する
3. 何が実行されているかがコードで明示されるため、むしろ保守性は向上する

**よくある例**:

```dockerfile
# 共通: lockfile 厳密インストール（postinstall は実行しない）
COPY package.json package-lock.json ./
RUN npm ci --ignore-scripts

# --- 以下、必要なパッケージのみ明示的に実行 ---

# Prisma: スキーマからクライアントコードを生成
COPY prisma ./prisma
RUN npx prisma generate

# sharp: Next.js 画像最適化用のネイティブバイナリを取得（v0.33+ は通常不要）
# RUN npx sharp install

# bcrypt: ネイティブモジュールのビルド（bcryptjs を使う場合は不要）
# RUN npx node-pre-gyp install --fallback-to-build
```

**判断基準**:

| パッケージの種類 | 例 | `ignore-scripts` の影響 | 対処 |
|---|---|---|---|
| 純粋な JS ライブラリ | React, Zod, microcms-js-sdk, nodemailer | なし（そのまま動く） | 不要 |
| コード生成が必要 | Prisma, GraphQL codegen | 生成コマンドが実行されない | Dockerfile で `npx <tool> generate` |
| ネイティブバイナリが必要 | sharp, bcrypt | バイナリのダウンロード/ビルドがされない | prebuild 版を優先 or Dockerfile で明示実行 |
| prebuilt バイナリ方式 | @swc/core, esbuild, sharp v0.33+ | なし（optional deps で自動取得） | 不要 |

> **ポイント**: 一般的な Web 制作の依存（Next.js + React + Zod + Framer Motion + CMS SDK 等）は
> ほとんどが純粋な JS または prebuilt バイナリ方式であり、**大半のプロジェクトではそのまま動作する**。
> 影響が出るのは主に Prisma 等のコード生成ツールやネイティブモジュールに限られる。

#### プライベートレジストリについて

大規模組織やコンプライアンス要件が厳しいプロジェクトでは、プライベートレジストリ（JFrog Artifactory, Verdaccio, GitHub Packages 等）の導入も選択肢となる。ただし運用コストが高く、先進的なパッケージの即座利用が制限される場合がある。導入可否はヒアリング（HEARING_SHEET.md §6）でユーザーと合意すること。

---

## 6. DAST（動的診断）

- **コンテナ戦略**: E2E同様、DAST専用コンテナ（ZAP等）を `docker compose` に追加する構成を採用
- CI上でWebサーバーとセットで立ち上げ、診断を実行する。これによりローカル環境でも同様の診断が可能
- staging/preview に対しても同様に「パッシブ中心」のスキャンを回すことを推奨
- 重大アラートをブロック条件にする

---

## 7. セキュリティ変更のDefinition of Done

- 関連するヘッダー/CSPの影響範囲を説明できる
- 既存ページが壊れない（または意図した変更）
- QUALITY_GATES のセキュリティ系チェックを通過

---

## 付録：主要リファレンス（一次情報）

- OWASP ASVS（チェックリストの物差し）  
  https://owasp.org/www-project-application-security-verification-standard/
- OWASP Secure Headers Project  
  https://owasp.org/www-project-secure-headers/
- Next.js: Security Headers / Custom Headers  
  https://nextjs.org/docs/app/api-reference/next-config-js/headers
- Next.js: Content Security Policy（CSP）ガイド  
  https://nextjs.org/docs/app/building-your-application/configuring/content-security-policy
- Next.js: poweredByHeader 設定  
  https://nextjs.org/docs/app/api-reference/config/next-config-js/poweredByHeader
- Secret scan: gitleaks  
  https://github.com/gitleaks/gitleaks
- Dependency vuln scan: OSV-Scanner  
  https://github.com/google/osv-scanner
- DAST（簡易）: OWASP ZAP Baseline（GitHub Action例）  
  https://github.com/zaproxy/action-baseline
- Performance: Lighthouse CI  
  https://github.com/GoogleChrome/lighthouse-ci
- a11y: pa11y-ci  
  https://github.com/pa11y/pa11y-ci
- WCAG 2.2  
  https://www.w3.org/TR/WCAG22/
- OpenTelemetry spec（可観測性の標準）  
  https://github.com/open-telemetry/opentelemetry-specification
