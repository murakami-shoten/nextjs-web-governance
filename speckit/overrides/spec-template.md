# Feature Specification: [FEATURE NAME]

<!--
  HEARING GATE (HEARING_RULES.md §1):
  この spec を作成する前に、ヒアリング深度を判定し要件を確認すること:
  
  ■ L1（初期構築）:
    1. HEARING_SHEET.md の全 Must 項目が TBD（未質問）でないこと
    2. requirements.md をこのディレクトリに作成し、ヒアリング結果を保存すること
    3. 本 spec は requirements.md の内容に基づいて策定すること
  
  ■ L2（機能追加）:
    1. FEATURE_HEARING_CHECKLIST.md の Must 項目が完了していること
    2. requirements.md をこのディレクトリに作成し、ヒアリング結果を保存すること
    3. 本 spec は requirements.md の内容に基づいて策定すること
  
  ■ L3（バグ修正）:
    1. BUGFIX_SPEC_TEMPLATE.md §1 の項目（再現手順・重大度・影響範囲）が完了していること
    2. requirements.md をこのディレクトリに作成し、バグ概要を保存すること
  
  保存先: このファイルと同階層の requirements.md
  詳細: docs/governance/rules/HEARING_RULES.md §1.1
-->

**Feature Branch**: `[###-feature-name]`  
**Created**: [DATE]  
**Status**: Draft  
**Input**: User description: "$ARGUMENTS"  
**Requirements Document**: `requirements.md`（このディレクトリ内）

## User Scenarios & Testing *(mandatory)*

<!--
  IMPORTANT: User stories should be PRIORITIZED as user journeys ordered by importance.
  Each user story/journey must be INDEPENDENTLY TESTABLE - meaning if you implement just ONE of them,
  you should still have a viable MVP (Minimum Viable Product) that delivers value.
  
  Assign priorities (P1, P2, P3, etc.) to each story, where P1 is the most critical.
  Think of each story as a standalone slice of functionality that can be:
  - Developed independently
  - Tested independently
  - Deployed independently
  - Demonstrated to users independently
-->

### User Story 1 - [Brief Title] (Priority: P1)

[Describe this user journey in plain language]

**Why this priority**: [Explain the value and why it has this priority level]

**Independent Test**: [Describe how this can be tested independently - e.g., "Can be fully tested by [specific action] and delivers [specific value]"]

**Acceptance Scenarios**:

1. **Given** [initial state], **When** [action], **Then** [expected outcome]
2. **Given** [initial state], **When** [action], **Then** [expected outcome]

---

### User Story 2 - [Brief Title] (Priority: P2)

[Describe this user journey in plain language]

**Why this priority**: [Explain the value and why it has this priority level]

**Independent Test**: [Describe how this can be tested independently]

**Acceptance Scenarios**:

1. **Given** [initial state], **When** [action], **Then** [expected outcome]

---

### User Story 3 - [Brief Title] (Priority: P3)

[Describe this user journey in plain language]

**Why this priority**: [Explain the value and why it has this priority level]

**Independent Test**: [Describe how this can be tested independently]

**Acceptance Scenarios**:

1. **Given** [initial state], **When** [action], **Then** [expected outcome]

---

[Add more user stories as needed, each with an assigned priority]

### Edge Cases

<!--
  ACTION REQUIRED: The content in this section represents placeholders.
  Fill them out with the right edge cases.
-->

- What happens when [boundary condition]?
- How does system handle [error scenario]?

## Requirements *(mandatory)*

<!--
  ACTION REQUIRED: Fill out functional requirements.
  
  EARS Notation Guide (docs/governance/requirements/REQUIREMENTS_TEMPLATE.md §2.5):
  Use EARS (Easy Approach to Requirements Syntax) for requirements involving
  conditional logic, error handling, or user interactions.
  
  Patterns:
  - Event-driven:  WHEN [event] THE SYSTEM SHALL [action]
  - Conditional:   IF [precondition], WHEN [event] THE SYSTEM SHALL [action]
  - Negative:      WHEN [invalid input/error] THE SYSTEM SHALL [error handling]
  
  Use EARS for: conditional logic, error handling, user interaction flows, state transitions.
  Use plain language for: static content, design requirements, NFR target values.
-->

### Functional Requirements

- **FR-001**: System MUST [specific capability, e.g., "allow users to create accounts"]
- **FR-002**: System MUST [specific capability, e.g., "validate email addresses"]  
- **FR-003**: Users MUST be able to [key interaction, e.g., "reset their password"]
- **FR-004**: System MUST [data requirement, e.g., "persist user preferences"]
- **FR-005**: System MUST [behavior, e.g., "log all security events"]

*Example of marking unclear requirements:*

- **FR-006**: System MUST authenticate users via [NEEDS CLARIFICATION: auth method not specified - email/password, SSO, OAuth?]
- **FR-007**: System MUST retain user data for [NEEDS CLARIFICATION: retention period not specified]

### Non-Functional Requirements *(mandatory for web projects)*

<!--
  Governance Reference:
  - Security: docs/governance/rules/SECURITY_RULES.md (CSP, HSTS, input validation)
  - Performance: docs/governance/rules/PERFORMANCE_RULES.md (CWV targets)
  - SEO: docs/governance/rules/SEO_RULES.md (meta, structured data, sitemap)
  - Accessibility: docs/governance/rules/DESIGN_RULES.md (WCAG 2.2 AA)
-->

| Category | Requirement | Target | Must/Should |
|---|---|---|---|
| Security | CSP / Security headers applied | Per SECURITY_RULES.md | Must |
| Performance | Core Web Vitals in Good range | LCP < 2.5s, CLS < 0.1, INP < 200ms | Must |
| SEO | Meta tags, sitemap, structured data | Per SEO_RULES.md | Must |
| Accessibility | WCAG compliance level | [e.g., WCAG 2.2 AA or NEEDS CLARIFICATION] | Should |

### Key Entities *(include if feature involves data)*

- **[Entity 1]**: [What it represents, key attributes without implementation]
- **[Entity 2]**: [What it represents, relationships to other entities]

## Success Criteria *(mandatory)*

<!--
  ACTION REQUIRED: Define measurable success criteria.
  These must be technology-agnostic and measurable.
-->

### Measurable Outcomes

- **SC-001**: [Measurable metric, e.g., "Users can complete account creation in under 2 minutes"]
- **SC-002**: [Measurable metric, e.g., "System handles 1000 concurrent users without degradation"]
- **SC-003**: [User satisfaction metric, e.g., "90% of users successfully complete primary task on first attempt"]
- **SC-004**: [Business metric, e.g., "Reduce support tickets related to [X] by 50%"]

## Assumptions

<!--
  ACTION REQUIRED: The content in this section represents placeholders.
  Fill them out with the right assumptions based on reasonable defaults
  chosen when the feature description did not specify certain details.
-->

- [Assumption about target users, e.g., "Users have stable internet connectivity"]
- [Assumption about scope boundaries, e.g., "Mobile support is out of scope for v1"]
- [Assumption about data/environment, e.g., "Existing authentication system will be reused"]
- [Dependency on existing system/service, e.g., "Requires access to the existing user profile API"]

## Governance References

<!--
  MANDATORY: The AI agent MUST read the governance rule files listed below
  when creating this specification. These contain concrete constraints that
  MUST be reflected in the Non-Functional Requirements table above.
  
  At minimum:
  - Read HEARING_RULES → confirm hearing level (L1/L2/L3) and complete before spec creation
  - Read requirements.md (this directory) → use as primary input source for this spec
  - Read SECURITY_RULES → populate SEC-xxx rows in NFR table
  - Read PERFORMANCE_RULES → populate PERF-xxx rows
  - Read SEO_RULES → populate SEO-xxx rows
  - Read DESIGN_RULES → populate A11Y-xxx rows
  - Read DEV_RULES → ensure coding constraints are captured in FR or Assumptions
-->

- **Hearing**: [docs/governance/rules/HEARING_RULES.md](docs/governance/rules/HEARING_RULES.md) ← **READ: hearing enforcement, requirements completion check**
- **Development**: [docs/governance/rules/DEV_RULES.md](docs/governance/rules/DEV_RULES.md) ← **READ: coding standards, env rules, test requirements**
- **Architecture**: [docs/governance/rules/ARCHITECTURE_RULES.md](docs/governance/rules/ARCHITECTURE_RULES.md) ← **READ: layer structure, dependency direction**
- **Security**: [docs/governance/rules/SECURITY_RULES.md](docs/governance/rules/SECURITY_RULES.md) ← **READ: CSP, headers, validation**
- **Quality Gates**: [docs/governance/rules/QUALITY_GATES.md](docs/governance/rules/QUALITY_GATES.md)
- **Design/UX**: [docs/governance/rules/DESIGN_RULES.md](docs/governance/rules/DESIGN_RULES.md)
- **SEO**: [docs/governance/rules/SEO_RULES.md](docs/governance/rules/SEO_RULES.md)
- **Performance**: [docs/governance/rules/PERFORMANCE_RULES.md](docs/governance/rules/PERFORMANCE_RULES.md)
