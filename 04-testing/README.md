# Testing

| Type | Purpose | Share |
|---|---|---|
| Unit | Logic of each function/module | Most |
| Integration | Components working together (DB, API) | Some |
| E2E | Main user flows | Few |

- **MUST** add tests for new code and bug fixes (reproduce the bug in a test before fixing).
- **MUST** run affected tests and have them pass before reporting done.
- **MUST** keep tests independent, order-agnostic, and free of real external services.
- **MUST** name tests by behavior: `should_return_error_when_email_invalid`.
- **SHOULD** reach ≥ 80% coverage on business logic.
- **MUST NOT** delete, skip or alter tests to pass without fixing the cause.
