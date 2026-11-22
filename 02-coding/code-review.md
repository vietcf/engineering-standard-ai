# Code Review

**Agent opening a PR**
- **MUST** keep PRs small (< ~400 lines) with one purpose; self-review the diff first.
- **MUST** describe what, why, how it was tested, and what is not verified.
- **MUST NOT** approve or merge its own PR.

**Agent reviewing**
- **MUST** check: correct logic, readability, tests, security, compliance with this standard.
- **MUST** cite file:line and the reason for each comment; prefix minor ones with `nit:`.
- **MUST** report only evidence-based issues, not speculation.

**Merge when**: ≥ 1 human approval, CI green, all comments resolved.
