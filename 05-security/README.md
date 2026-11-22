# Security

- **MUST** validate all external input.
- **MUST** use parameterized queries; **MUST NOT** build SQL by string concatenation.
- **MUST** escape output (prevent XSS).
- **MUST** apply least privilege to users, services and databases.
- **MUST NOT** commit, print or log secrets / sensitive data.
- **MUST NOT** disable security checks (TLS verify, CSRF, auth) to make code work.
- **SHOULD** use well-established libraries for crypto / auth; **MUST NOT** implement custom crypto.
- **SHOULD** tell the user when a dependency has a known vulnerability.
- Secrets & env: see [09-env-config](../09-env-config/).
