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

[Gates determined based on constitution file]

## Quality Gates *(MANDATORY)*

<!--
  These 7 gates MUST all pass before deployment.
  Reference: docs/governance/rules/QUALITY_GATES.md §2
  All commands MUST be executed via Docker Compose (DEV_RULES §5).
-->

- [ ] **Lint** — `docker compose run --rm frontend npm run lint`
- [ ] **Typecheck** — `docker compose run --rm frontend npm run typecheck`
- [ ] **Format check** — `docker compose run --rm frontend npm run format:check`
- [ ] **Unit/Integration test** — `docker compose run --rm frontend npm test`
- [ ] **Build** — `docker compose run --rm frontend npm run build`
- [ ] **Secret scan** — `docker compose run --rm gitleaks`
- [ ] **Dependency vuln scan** — `docker compose run --rm osv-scanner`

> **No exceptions.** If a gate must be skipped, document the reason, deadline, and mitigation in the Complexity Tracking section below.

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
  
  Convention: Next.js apps go in frontend/ directory (AGENTS.md §2.4).
-->

```text
# [REMOVE IF UNUSED] Option 1: Standard (Next.js in frontend/)
frontend/
├── src/
│   ├── app/           # App Router pages & layouts
│   ├── components/    # Reusable UI components
│   ├── lib/           # Shared utilities & helpers
│   └── styles/        # Global CSS
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

# [REMOVE IF UNUSED] Option 3: Full-stack (frontend + backend)
frontend/
├── src/
│   ├── app/
│   ├── components/
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

- **Development**: [docs/governance/rules/DEV_RULES.md](docs/governance/rules/DEV_RULES.md)
- **Architecture**: [docs/governance/rules/ARCHITECTURE_RULES.md](docs/governance/rules/ARCHITECTURE_RULES.md)
- **Security**: [docs/governance/rules/SECURITY_RULES.md](docs/governance/rules/SECURITY_RULES.md)
- **Quality Gates**: [docs/governance/rules/QUALITY_GATES.md](docs/governance/rules/QUALITY_GATES.md)
- **Performance**: [docs/governance/rules/PERFORMANCE_RULES.md](docs/governance/rules/PERFORMANCE_RULES.md)
- **SEO**: [docs/governance/rules/SEO_RULES.md](docs/governance/rules/SEO_RULES.md)
- **Design/UX**: [docs/governance/rules/DESIGN_RULES.md](docs/governance/rules/DESIGN_RULES.md)
