# [PROJECT_NAME] Constitution

<!--
  This constitution is pre-configured with nextjs-web-governance principles.
  Customize the descriptions and add project-specific details as needed.
  Reference: docs/governance/ for full rule details.
-->

## Core Principles

### I. Requirements-First
Every implementation MUST begin with requirements discovery. No coding before requirements are agreed upon. The workflow is: Hearing → Requirements → Wireframe → SOW → Implementation.
- Hearing enforcement details: `docs/governance/rules/HEARING_RULES.md`
- Implementation MUST NOT begin until HEARING_RULES.md §1 requirements are met
- Use `docs/governance/requirements/HEARING_SHEET.md` to gather requirements
- Create project-specific requirements from `docs/governance/requirements/REQUIREMENTS_TEMPLATE.md`
- Never guess or assume — ask the user when information is missing
- Use `[NEEDS CLARIFICATION]` markers for unresolved items
<!-- Customize: Add project-specific requirements workflow notes here -->

### II. Low Lock-in Architecture
Systems MUST be loosely coupled and vendor-independent. Avoid deep dependency on any single provider, framework, or platform.
- Follow dependency direction rules in `docs/governance/rules/ARCHITECTURE_RULES.md`
- Prefer standard APIs over proprietary ones
- Content stored in portable formats (MDX recommended)
- Infrastructure decisions documented with alternatives considered
<!-- Customize: Add project-specific architecture constraints here -->

### III. Security by Default
Security controls MUST be applied from day one, not added later. CSP, HSTS, input validation, and authentication are mandatory standard equipment.
- Content Security Policy (CSP) with strict directives
- Security headers: HSTS, X-Content-Type-Options, X-Frame-Options, Referrer-Policy
- Server-side input validation on all user inputs
- Rate limiting on form submissions and API endpoints
- Full details: `docs/governance/rules/SECURITY_RULES.md`
<!-- Customize: Add project-specific security requirements here -->

### IV. Quality Gates (NON-NEGOTIABLE)
All 7 quality gates MUST pass before any deployment. No exceptions without documented justification, deadline, and mitigation plan.
1. Lint (`npm run lint`)
2. Typecheck (`npm run typecheck`)
3. Format check (`npm run format:check`)
4. Unit/Integration test (`npm test`)
5. Build (`npm run build`)
6. Secret scan (gitleaks)
7. Dependency vulnerability scan (osv-scanner)
- Full details: `docs/governance/rules/QUALITY_GATES.md`
<!-- Customize: Add project-specific quality requirements here -->

### V. Docker-First Development
Development environment MUST work with Docker alone. No host Node.js or npm required. All commands (lint, test, build, etc.) run via `docker compose run`.
- Container configuration via `.env` (not committed) + `.env.example` (committed)
- Next.js environment via `web/.env.local` + `web/.env.local.example` (directory name is `web/` by default; configurable per project)
- Port numbers chosen to avoid conflicts, configurable via settings
<!-- Customize: Add project-specific Docker/environment notes here -->

### VI. SEO Standards
Technical SEO MUST comply with Google recommendations. Every page requires proper meta tags, structured data where applicable, and sitemap coverage.
- Title tags, meta descriptions, canonical URLs on every page
- Single `<h1>` per page with proper heading hierarchy
- Sitemap.xml and robots.txt properly configured
- Full details: `docs/governance/rules/SEO_RULES.md`
<!-- Customize: Add project-specific SEO targets here -->

### VII. Performance Standards
Core Web Vitals MUST be in the Good range. Font loading, image optimization, and CSS bundle size are controlled from the start.
- LCP < 2.5s, CLS < 0.1, INP < 200ms
- Font optimization with `next/font` (self-hosted, no external requests)
- Image optimization with `next/image` (WebP/AVIF, responsive sizes)
- Full details: `docs/governance/rules/PERFORMANCE_RULES.md`
<!-- Customize: Add project-specific performance targets here -->

### VIII. Design Principles
UI/UX design MUST follow ISO 9241 and Nielsen's heuristics. Accessibility (WCAG 2.2 AA) is a baseline requirement, not an optional enhancement.
- Consistency and standards across all interfaces
- Error prevention over error recovery
- Recognition over recall in navigation and controls
- Full details: `docs/governance/rules/DESIGN_RULES.md`
<!-- Customize: Add project-specific design guidelines here -->

### IX. Concrete Rules — Top Violations to Watch

<!--
  These are the governance rules MOST COMMONLY violated in AI-assisted implementations.
  The AI agent MUST check these BEFORE writing any code.
  For full details, ALWAYS read the source files in docs/governance/rules/.
-->

1. **NO magic numbers** — Use named constants with JSDoc (DEV_RULES §2.3)
2. **Constants centralized** — `as const` arrays in `src/features/<domain>/constants.ts` (DEV_RULES §2.8)
3. **Env fail-fast** — Validate required env vars at startup; crash if missing (DEV_RULES §4)
4. **NO explicit NODE_ENV** — Never set `NODE_ENV` in `.env*` files; let Next.js set it automatically (DEV_RULES §4)
5. **Docker-first** — All npm/node commands via `docker compose run --rm <service>` (DEV_RULES §5)
6. **CSP headers mandatory** — Configure Content-Security-Policy in middleware or next.config (SECURITY_RULES)
7. **Server-side validation** — Never trust client input; validate with Zod or equivalent on server (SECURITY_RULES)
8. **Feature-First structure** — `src/features/<domain>/` for domain-shared logic; route-specific components colocated in `app/[route]/_components/` (ARCHITECTURE_RULES §2.2)
9. **No `any` type** — TypeScript `strict: true`; justify exceptions with comments (DEV_RULES §2.1)
10. **Unit tests required** — Business logic, API Route Handlers, shared utils, security code (DEV_RULES §2.9)

## Development Workflow

<!-- Customize: Describe the development workflow for this project -->

- **Branch strategy**: `main` → production, `staging` → staging, `dev` → development
- **Commit convention**: Conventional Commits format (see `DEV_RULES.md` §3)
- **Environment switching**: Via environment variables (dev/staging/production)
- **Secrets**: Never in Git. Use `.env` files (git-ignored) with `.env.example` templates

## Governance

- This constitution reflects the governance rules in `docs/governance/`
- **MANDATORY**: Before writing any implementation code, the AI agent MUST read the applicable rule files in `docs/governance/rules/` and verify compliance against the Concrete Rules above
- To update rules: modify the source files in `docs/governance/`, then regenerate this constitution via `/speckit-constitution`
- All implementations MUST pass Constitution Check before proceeding
- Quality Gates are enforced at every deployment boundary
- Amendments to this constitution require documentation and version bump

**Version**: 1.1.0 | **Ratified**: [RATIFICATION_DATE] | **Last Amended**: [LAST_AMENDED_DATE]
