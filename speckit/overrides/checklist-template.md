# Governance Compliance Checklist

<!--
  This checklist is used by the /speckit.checklist command.
  After implementation, the AI agent MUST verify all applicable items below
  against the governance rules in docs/governance/rules/.
  
  Mark items as:
  - [x] Verified and compliant
  - [ ] Not yet verified
  - [N/A] Not applicable (with reason)
-->

## HEARING_RULES / Requirements Compliance

### ヒアリング完了（HEARING_RULES §1.1）
- [ ] ヒアリング深度（L1/L2/L3）が適切に選択されている
- [ ] requirements.md がこのディレクトリに作成済みでヒアリング結果が保存されている
- [ ] [L1] HEARING_SHEET.md の全 Must 項目が `TBD（未質問）` でない
- [ ] [L2] FEATURE_HEARING_CHECKLIST.md の Must 項目が完了している
- [ ] [L3] BUGFIX_SPEC §1 の必須項目（再現手順・重大度・影響範囲）が完了している

### 要件実装の検証（HEARING_RULES §3）
- [ ] requirements.md の全 Must 機能要件に対応する実装が存在する
- [ ] requirements.md の全 Must 非機能要件（Security/Performance/SEO/A11y）が検証済み
- [ ] plan.md の Requirements Traceability テーブルの全項目が Verified
- [ ] 実装が requirements.md と乖離している箇所は合意済み（変更理由が記録されている）

## DEV_RULES Compliance

### Coding Standards (§2)
- [ ] No magic numbers — all numeric literals (except 0, 1, -1) have named constants with JSDoc comments
- [ ] Constants centralized in `src/features/<domain>/constants.ts` using `as const` arrays with derived union types
- [ ] TypeScript `strict: true` — no `any` usage without documented justification
- [ ] ESLint configured with `eslint-config-next/core-web-vitals` + `eslint-config-prettier`
- [ ] Prettier configured with `format:check` script available
- [ ] Server/Client boundary respected: default Server Component, `"use client"` only when necessary
- [ ] Business logic in pure TypeScript functions (no React/Next.js dependency)
- [ ] No duplicate implementations — existing shared utils/components reused

### Environment Variables (§4)
- [ ] Required env vars validated at startup with fail-fast (crash if missing)
- [ ] `NODE_ENV` NOT explicitly set in any `.env*` file
- [ ] `.env.local.example` exists as template for Next.js env vars
- [ ] Root `.env.example` exists for Docker Compose env vars
- [ ] No secrets committed to Git

### Docker-First (§5)
- [ ] All npm/node commands documented as `docker compose run --rm <service>` commands
- [ ] `docker compose up` works without host Node.js/npm installed
- [ ] Port numbers configurable and documented

### Testing (§2.9)
- [ ] Unit tests exist for business logic, API Route Handlers, shared utils
- [ ] Test files colocated with source files (e.g., `route.test.ts` next to `route.ts`)
- [ ] Tests are hermetic (external deps mocked)

### Git (§3)
- [ ] Commit messages follow Conventional Commits format
- [ ] Custom error pages implemented: `not-found.tsx`, `error.tsx`, `global-error.tsx` (§8.2)

## SECURITY_RULES Compliance

- [ ] Content-Security-Policy (CSP) headers configured
- [ ] Security headers set: HSTS, X-Content-Type-Options, X-Frame-Options, Referrer-Policy
- [ ] All user inputs validated server-side (Zod or equivalent)
- [ ] Rate limiting on form submissions and API endpoints
- [ ] CSRF protection on mutation endpoints
- [ ] No sensitive data in client-side code or logs

## ARCHITECTURE_RULES Compliance

- [ ] Layer separation respected: UI → domain → infra (no upward dependencies)
- [ ] Feature-First directory structure: `src/features/<domain>/` for shared domain logic
- [ ] Route-specific components colocated in `app/[route]/_components/`
- [ ] Global shared UI only in `src/components/`
- [ ] Dependencies abstracted for vendor lock-in risk items

## SEO_RULES Compliance

- [ ] Title tags and meta descriptions on every page
- [ ] Single `<h1>` per page with proper heading hierarchy
- [ ] Sitemap.xml configured and accessible
- [ ] robots.txt properly configured
- [ ] Structured data (JSON-LD) where applicable
- [ ] Canonical URLs set

## PERFORMANCE_RULES Compliance

- [ ] Core Web Vitals targets: LCP < 2.5s, CLS < 0.1, INP < 200ms
- [ ] Fonts self-hosted via `next/font` or `@fontsource-variable/*` (no external requests)
- [ ] Images optimized with `next/image` (WebP/AVIF, responsive sizes)
- [ ] CSS chunk sizes verified after build

## DESIGN_RULES Compliance

- [ ] WCAG 2.2 AA accessibility requirements met
- [ ] Consistency in UI patterns (ISO 9241 / Nielsen's heuristics)
- [ ] Error prevention prioritized over error recovery
- [ ] Mobile-responsive design implemented

### Wireframe Compliance (DESIGN_RULES §9 — conditional)

*Skip this section if no approved wireframes exist for this feature.*

- [ ] Each page compared side-by-side with approved wireframe
- [ ] Grid structure matches (column count, placement order)
- [ ] All specified elements present (navigation, form fields, card structure)
- [ ] Left/right and top/bottom placement order matches
- [ ] Responsive behavior matches (SP/PC)
- [ ] Any deviations documented and user-approved

## Quality Gates (ALL MUST PASS)

- [ ] `docker compose run --rm <service> npm run lint`
- [ ] `docker compose run --rm <service> npm run typecheck`
- [ ] `docker compose run --rm <service> npm run format:check`
- [ ] `docker compose run --rm <service> npm test`
- [ ] `docker compose run --rm <service> npm run build`
- [ ] `docker compose run --rm gitleaks` (secret scan)
- [ ] `docker compose run --rm osv-scanner` (dependency vulnerability scan)
