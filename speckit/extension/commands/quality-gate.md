---
description: "NWG Governance: Post-implementation quality gates and compliance verification"
scripts:
  sh: ../../scripts/bash/governance-check.sh
---

# NWG Governance Quality Gate

⛔ **This check runs automatically after /speckit.implement.**
ALL quality gates MUST pass before the implementation is considered complete.

## Step 1: Structural Check

Run the governance check script:

```bash
{SCRIPT} --phase quality-gate
```

This verifies structural requirements like `.env.example`, `docker-compose.yml`, etc.

## Step 2: Quality Gate Commands (ALL MUST PASS)

Execute the following commands. Replace `<service>` with the Docker Compose service name
from the project's `docker-compose.yml`:

1. **Lint**: `docker compose run --rm <service> npm run lint`
2. **Typecheck**: `docker compose run --rm <service> npm run typecheck`
3. **Format**: `docker compose run --rm <service> npm run format:check`
4. **Test**: `docker compose run --rm <service> npm test`
5. **Build**: `docker compose run --rm <service> npm run build`
6. **Secret scan**: `docker compose run --rm gitleaks` (if configured)
7. **Vuln scan**: `docker compose run --rm osv-scanner` (if configured)

If ANY command fails, STOP and report the error.
Do not mark implementation as complete until all gates pass.

## Step 2.5: Wireframe Compliance (conditional — DESIGN_RULES §9)

If approved wireframes exist for this feature:

1. Open each wireframe HTML file alongside the running implementation in the browser
2. Compare layout structure page by page:
   - Grid structure (column count, placement order)
   - Element presence (navigation, form fields, card components)
   - Left/right and top/bottom placement order
   - Responsive behavior (SP/PC)
3. If any deviation is found without user approval → **STOP and report**
4. Mark wireframe compliance items in the checklist (SOW §4.4)

If no approved wireframes exist, skip this step.

## Step 3: Dynamic Rule Compliance Verification

1. List ALL `.md` files in `docs/governance/rules/`
2. Read EACH file completely
3. Verify the implementation satisfies ALL Must requirements from each rule.
   For each rule file, check applicable items:

   **Examples of what to verify** (not exhaustive — read actual rule files):
   - Security headers configured (CSP, HSTS, etc.)
   - CAPTCHA/spam protection on all forms
   - Input validation server-side
   - Rate limiting implemented
   - Docker Compose for all commands
   - `.env.example` and `.env.local.example` exist
   - SEO meta tags on every page
   - Accessibility requirements met
   - Performance targets documented
   - Architecture layer separation respected

4. Report PASS/FAIL for each rule category

## Step 4: Checklist Generation

Run `/speckit.checklist` to generate the full governance compliance report
using the checklist-template.md override.

## Step 5: Summary Report

```
═══════════════════════════════════
NWG Governance Quality Gate Report
  Quality Gates: X/7 passed
  Rule Compliance: X/Y rules verified
  Checklist: Generated ✅ / Pending ⚠️
═══════════════════════════════════
```

If any quality gate command failed or critical rule violations exist:
→ **Report to user. Implementation is NOT complete.**
