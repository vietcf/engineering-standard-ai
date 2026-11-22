# Commit Message

**MUST** follow [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <short summary, imperative mood>

<body: why the change (optional)>
```

**type**: `feat`, `fix`, `refactor`, `docs`, `test`, `chore`, `perf`, `ci`

Example: `feat(auth): add Google login`

- **MUST** keep the subject line ≤ 72 characters.
- **MUST** make each commit one meaningful change.
- **MUST NOT** commit `.env`, secrets or build output.
- **MUST NOT** commit unless the user asked for it.
