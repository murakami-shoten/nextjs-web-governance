# Implementation Plan: [FEATURE]

**Branch**: `[###-feature-name]` | **Date**: [DATE] | **Spec**: [link]
**Input**: Feature specification from `/specs/[###-feature-name]/spec.md`

**Note**: This template is filled in by the `/speckit.plan` command. See `.specify/templates/plan-template.md` for the execution workflow.

## Summary

[Extract from feature spec: primary requirement + technical approach from research]

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. Default stack is listed below — adjust as needed.
-->

**Language/Version**: TypeScript 5.x / Node.js 22.x  
**Framework**: Next.js 16.x (App Router) / React 19.x  
**Primary Dependencies**: [e.g., React Hook Form, Zod, next-intl or NEEDS CLARIFICATION]  
**Storage**: [if applicable, e.g., PostgreSQL, Prisma, headless CMS or N/A]  
**Testing**: Vitest + React Testing Library + Playwright  
**Target Platform**: Web (Docker-based development)  
**Performance Goals**: Core Web Vitals Good range (LCP < 2.5s, CLS < 0.1, INP < 200ms)  
**Constraints**: Docker-first (no host Node.js required), CSP/Security headers mandatory  
**Scale/Scope**: [domain-specific, e.g., 10k users, 50 screens or NEEDS CLARIFICATION]

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- [ ] ヒアリング深度（L1/L2/L3）を判定済み（HEARING_RULES.md §1.1）
- [ ] requirements.md がこのディレクトリに作成済みで、ヒアリング結果が保存されていること
- [ ] [L1のみ] HEARING_SHEET.md の Must 項目に TBD（未質問）が 0 件であること
- [ ] [L2のみ] FEATURE_HEARING_CHECKLIST.md の Must 項目が完了していること
- [ ] [L3のみ] BUGFIX_SPEC §1 の必須項目（再現手順・重大度・影響範囲）が完了していること
- [Gates determined based on constitution file]

## Governance Compliance Plan *(MANDATORY)*

<!--
  GATE: This section MUST be completed before Phase 0 research.
  
  INSTRUCTIONS FOR AI AGENT:
  Before creating the implementation plan, you MUST:
  1. List ALL .md files in docs/governance/rules/
  2. READ each rule file completely
  3. Extract ALL clauses that apply to this feature
  4. Fill in the compliance table mapping each applicable clause to an implementation task
  5. If a clause does not apply, explicitly mark it as "N/A" with reason
  
  DO NOT rely on the example rows below — they are illustrative only.
  Always scan docs/governance/rules/*.md for the current set of rules.

  Common items that are frequently missed by AI agents:
  - Docker Compose: .env for port configuration, no hardcoded ports (DEV_RULES §4-5)
  - Forms: CAPTCHA/spam protection is MANDATORY for all forms (SECURITY_RULES §4, EMAIL_RULES)
  - Environment: .env.example and .env.local.example templates must exist (DEV_RULES §4)
  - Security headers: CSP, HSTS, X-Content-Type-Options, etc. (SECURITY_RULES §2)
  
  This ensures governance rules are not lost between constitution and implementation.
-->

**Rule Source**: `docs/governance/rules/*.md` — scan ALL files and extract applicable clauses.

| Rule File | Clause | Requirement | Implementation Task | N/A Reason |
|---|---|---|---|---|
| *(example)* DEV_RULES §2.3 | No magic numbers | Named constants with JSDoc | | |
| *(example)* SECURITY_RULES §4 | Form spam protection | CAPTCHA + rate limiting | | |
| *(auto-populated from rule scan)* | | | | |

## Quality Gates *(MANDATORY)*

<!--
  These 7 gates MUST all pass before deployment.
  Reference: docs/governance/rules/QUALITY_GATES.md §2
  All commands MUST be executed via Docker Compose (DEV_RULES §5).
  Replace <service> with your docker-compose service name (e.g., web).
-->

- [ ] **Lint** — `docker compose run --rm <service> npm run lint`
- [ ] **Typecheck** — `docker compose run --rm <service> npm run typecheck`
- [ ] **Format check** — `docker compose run --rm <service> npm run format:check`
- [ ] **Unit/Integration test** — `docker compose run --rm <service> npm test`
- [ ] **Build** — `docker compose run --rm <service> npm run build`
- [ ] **Secret scan** — `docker compose run --rm gitleaks`
- [ ] **Dependency vuln scan** — `docker compose run --rm osv-scanner`

> **No exceptions.** If a gate must be skipped, document the reason, deadline, and mitigation in the Complexity Tracking section below.

## Wireframe Plan *(CONDITIONAL — HEARING_RULES §5)*

<!--
  This section is CONDITIONAL. Include it ONLY when:
  - spec.md "Design Deliverables" indicates wireframes are required
  - requirements.md §4 specifies wireframe creation
  
  If wireframes are NOT required, write "N/A — no wireframe required" and skip.
-->

**Wireframe Required**: [Yes / No — from spec.md Design Deliverables]

| Item | Detail |
|---|---|
| Method | [AI-generated HTML mock / User-provided / External tool] |
| Pages | [List of pages requiring wireframes] |
| Quality Criteria | DESIGN_RULES.md §8 (SP+PC, real content, error/empty states) |
| Deliverable Location | `specs/[feature]/wireframes/` |
| Gate | Phase 2.5 in tasks.md — `[APPROVAL]` blocks Phase 3+ |

> ⚠️ When wireframes are required, implementation (Phase 3+) MUST NOT begin until approved.

## Requirements Traceability *(MANDATORY)*

<!--
  GATE: requirements.md の全 Must 要件が実装計画にマッピングされていること。
  
  INSTRUCTIONS FOR AI AGENT:
  1. READ requirements.md（このディレクトリ内）
  2. 各 Must 要件（機能・非機能）を以下のテーブルに記載
  3. 各要件に対応する実装タスクを割り当て
  4. 対応する実装タスクがない要件は理由を明記
  
  詳細: docs/governance/rules/HEARING_RULES.md §3
-->

| Req Source | Req ID | Requirement Summary | Implementation Task | Verified |
|---|---|---|---|---|
| requirements.md §x | [ID] | [from requirements] | [task reference] | [ ] |
| requirements.md §x | [ID] | [from requirements] | [task reference] | [ ] |

## Acceptance Criteria Checklist

<!--
  Map functional and non-functional requirements from the spec to verification methods.
  Reference: docs/governance/requirements/SOW_TEMPLATE.md §4
-->

### Functional Requirements

| Req ID | Requirement Summary | Verification Method | Done |
|---|---|---|---|
| FR-001 | [from spec] | [e.g., E2E test: feature.spec.ts] | [ ] |
| FR-002 | | | [ ] |

### Non-Functional Requirements

| Req ID | Requirement Summary | Verification Method | Done |
|---|---|---|---|
| SEC-001 | CSP / Security headers | Header inspection script | [ ] |
| PERF-001 | CWV Good range | Lighthouse CI | [ ] |
| SEO-001 | Meta / sitemap / structured data | Automated crawl check | [ ] |
| A11Y-001 | WCAG compliance | Pa11y CI | [ ] |

## Project Structure

### Documentation (this feature)

```text
specs/[###-feature]/
├── plan.md              # This file (/speckit.plan command output)
├── research.md          # Phase 0 output (/speckit.plan command)
├── data-model.md        # Phase 1 output (/speckit.plan command)
├── quickstart.md        # Phase 1 output (/speckit.plan command)
├── contracts/           # Phase 1 output (/speckit.plan command)
└── tasks.md             # Phase 2 output (/speckit.tasks command - NOT created by /speckit.plan)
```

### Source Code (repository root)
<!--
  ACTION REQUIRED: Replace the placeholder tree below with the concrete layout
  for this feature. Delete unused options and expand the chosen structure with
  real paths. The delivered plan must not include Option labels.
  
  Convention: Next.js apps go in a dedicated subdirectory (default: web/).
  The directory name is configurable per project (e.g., frontend/, app/).
  See AGENTS.md §2.4 and DEV_RULES §1.
-->

```text
# [REMOVE IF UNUSED] Option 1: Standard (Next.js in web/)
web/
├── src/
│   ├── app/           # App Router pages & layouts
│   ├── components/    # Reusable UI components
│   ├── features/      # Feature-First domain modules
│   ├── lib/           # Shared utilities & helpers
│   └── config/        # App configuration (env validation, etc.)
├── public/            # Static assets
└── __tests__/         # Test files

# [REMOVE IF UNUSED] Option 2: Single project (non-Next.js)
src/
├── models/
├── services/
├── cli/
└── lib/

tests/
├── contract/
├── integration/
└── unit/

# [REMOVE IF UNUSED] Option 3: Full-stack (web + backend)
web/
├── src/
│   ├── app/
│   ├── components/
│   ├── features/
│   └── lib/
└── __tests__/

backend/
├── src/
│   ├── models/
│   ├── services/
│   └── api/
└── tests/
```

**Structure Decision**: [Document the selected structure and reference the real
directories captured above]

## Complexity Tracking

> **Fill ONLY if Constitution Check or Quality Gates have violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|--------------------------------------|
| [e.g., Quality gate skip] | [current need] | [why gate cannot pass yet] |

## Governance References

<!--
  MANDATORY: The AI agent MUST read the governance rule files listed below
  when creating or updating this plan. These are NOT just informational links —
  they contain concrete implementation constraints that MUST be reflected in
  the Governance Compliance Plan section above.
  
  At minimum, read DEV_RULES, SECURITY_RULES, and ARCHITECTURE_RULES.
  Read others as applicable to the feature scope.
-->

- **Hearing**: [docs/governance/rules/HEARING_RULES.md](docs/governance/rules/HEARING_RULES.md) ← **READ: hearing enforcement, requirements completion check**
- **Development**: [docs/governance/rules/DEV_RULES.md](docs/governance/rules/DEV_RULES.md) ← **READ: coding standards, env rules, test requirements**
- **Architecture**: [docs/governance/rules/ARCHITECTURE_RULES.md](docs/governance/rules/ARCHITECTURE_RULES.md) ← **READ: layer structure, dependency direction**
- **Security**: [docs/governance/rules/SECURITY_RULES.md](docs/governance/rules/SECURITY_RULES.md) ← **READ: CSP, headers, validation**
- **Quality Gates**: [docs/governance/rules/QUALITY_GATES.md](docs/governance/rules/QUALITY_GATES.md)
- **Performance**: [docs/governance/rules/PERFORMANCE_RULES.md](docs/governance/rules/PERFORMANCE_RULES.md)
- **SEO**: [docs/governance/rules/SEO_RULES.md](docs/governance/rules/SEO_RULES.md)
- **Design/UX**: [docs/governance/rules/DESIGN_RULES.md](docs/governance/rules/DESIGN_RULES.md)
- **Content**: [docs/governance/rules/CONTENT_RULES.md](docs/governance/rules/CONTENT_RULES.md)
