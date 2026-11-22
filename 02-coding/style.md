# Code Style

- **MUST** use the formatter + linter configured in the repo; **MUST NOT** change their config without approval.
- **MUST** keep functions single-purpose; **SHOULD** return early and avoid nesting deeper than 3 levels.
- **MUST** handle errors explicitly; **MUST NOT** silently swallow exceptions.
- **MUST** read config / secrets from env; **MUST NOT** hard-code them.
- **SHOULD** write comments that explain **why**, not **what**.
- **MUST NOT** leave dead code, commented-out code or debug logs (`console.log`, `print`).
- **MUST NOT** reformat / refactor code outside task scope.
