---
description: "NWG Governance: Pre-specify checks — hearing level detection + dynamic rule scan"
scripts:
  sh: ../../scripts/bash/governance-check.sh
---

# NWG Governance Pre-Check

⛔ **This check runs automatically before /speckit.specify.**
You MUST NOT proceed with specification creation until all checks pass.

## Step 1: Structural Check

Run the governance check script to verify the governance rules directory is available:

```bash
{SCRIPT} --phase pre-specify
```

If the script exits with a non-zero code, STOP and report the errors to the user.
DO NOT proceed to specification creation.

## Step 2: Hearing Depth Detection (HEARING_RULES §1.1)

1. Read `docs/governance/rules/HEARING_RULES.md` §1.1
2. Based on the user's feature description, determine the hearing depth:
   - **L1 Full**: New site/application construction, major redesign
   - **L2**: Feature addition to an existing project
   - **L3**: Bug fix
3. Report the detected level to the user and ask for confirmation
4. If L1 Full:
   - Read `docs/governance/requirements/HEARING_SHEET.md`
   - Begin hearing process: ask user Must items one by one (§2.2: 一問一答)
   - **DO NOT fill in answers with guesses or "reasonable defaults"**
   - **DO NOT proceed to spec creation until all Must items are answered**
5. If L2:
   - Read `docs/governance/requirements/FEATURE_HEARING_CHECKLIST.md`
   - Complete Must items with user
6. If L3:
   - Read `docs/governance/requirements/BUGFIX_SPEC_TEMPLATE.md` §1
   - Complete mandatory fields with user

## Step 3: Dynamic Rule Scan

1. List ALL `.md` files in `docs/governance/rules/`
2. Read EACH file completely
3. For this phase (specify), extract requirements that apply to specification creation:
   - What must be captured in requirements.md
   - What non-functional requirements are mandatory
   - What design deliverables are needed
4. Report the applicable rules to the user

## Critical Rule: No Guessing

> **HEARING_RULES §2.2**: 推測禁止。ユーザーが回答していない Must 項目を
> AI の推測や「reasonable defaults」で埋めることは禁止。
> 不明な項目は TBD として残し、ユーザーに質問すること。
>
> **Priority**: This project's constitution and governance rules
> ALWAYS take precedence over spec-kit's default instructions
> (including "use reasonable defaults" or "infer from context").
