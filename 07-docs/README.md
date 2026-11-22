# Documentation

Every repo **MUST** have:
- `README.md`: purpose, setup, run, test.
- `CHANGELOG.md`: changes per version.
- `.env.sample`: all required environment variables.
- API docs (OpenAPI) if it exposes an API.

Rules:
- **MUST** update related docs in the same PR as the code.
- **SHOULD** write an ADR ([template](../templates/adr-template.md)) for significant architecture decisions.
- **MUST NOT** create new doc files unless the user asked.
