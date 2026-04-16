---
description: "NWG Governance: Gate check before plan/tasks/implement"
scripts:
  sh: ../../scripts/bash/governance-check.sh
---

# NWG Governance Gate Check

⛔ **This check runs automatically before /speckit.plan, /speckit.tasks,
and /speckit.implement.** You MUST NOT proceed until all checks pass.

## Step 1: Structural Check

Run the governance check script:

```bash
{SCRIPT} --phase gate-check
```

If the script exits with a non-zero code, STOP and report the errors to the user.
**DO NOT proceed to the next workflow step.** The errors must be resolved first.

### What the script checks:

- `requirements.md` exists in the feature spec directory
- Hearing depth (ヒアリング深度) is recorded
- No Must items have status `TBD（未質問）`
- No answers have basis `AI推測`
- Reports `NEEDS CLARIFICATION` count as warnings

## Step 2: Dynamic Rule Enforcement

1. List ALL `.md` files in `docs/governance/rules/`
2. Read EACH file completely
3. Cross-reference ALL mandatory (Must) requirements against `requirements.md`:
   - Every Must requirement from each rule file must be addressed
   - Items with `TBD（未質問）` or `AI推測` are violations — STOP
   - Items with `TBD（確認済）` with a reason and deadline are acceptable
4. Report PASS/FAIL for each rule file

## Step 3: Wireframe Gate (before /speckit.implement only)

If the current phase is `/speckit.implement`:

1. Read `spec.md` — check the "Design Deliverables" section
2. If wireframes are required (Required: Yes):
   - Read `tasks.md` — find Phase 2.5 (Design Review Gate)
   - Verify the `[APPROVAL]` task is checked: `- [x]`
   - If NOT checked → **STOP**: "Wireframes must be approved before implementation"
3. If wireframes are not required: Skip this check

## Step 4: Report

Summarize all checks:

```
═══════════════════════════════════
NWG Governance Gate Check
  Phase: [plan / tasks / implement]
  Requirements.md: ✅ / ❌
  Hearing complete: ✅ / ❌
  Rule compliance: ✅ X/Y rules passed
  Wireframe gate: ✅ / ❌ / N/A
═══════════════════════════════════
```

If any check is ❌ → **STOP and report to user. Do not proceed.**
