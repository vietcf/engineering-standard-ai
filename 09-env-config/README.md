# Env & Config

## Principles — MUST
- Read config from **environment variables** (12-factor); never hard-code it in code or images.
- Run the same image in every environment; only env differs.
- **Validate env at startup**; exit immediately with a clear error if a required variable is missing.

## Files
| File | In Git | Content |
|---|---|---|
| `.env.sample` | ✅ | Every variable, **placeholders only** |
| `.env` | ❌ | Local dev values |
| `.env.<env>` | ❌ | Per-environment values (if no secret manager) |

`.gitignore` **MUST** include: `.env`, `.env.*`, `!.env.sample`

## Variable naming
- UPPER_SNAKE_CASE with a group prefix: `DB_HOST`, `DB_PORT`, `REDIS_URL`, `JWT_SECRET`.
- Runtime environment: `APP_ENV=dev|test|staging|prod`.

```dotenv
# .env.sample
APP_ENV=dev
APP_PORT=3000
DB_HOST=localhost
DB_PORT=5432
DB_USER=changeme
DB_PASSWORD=changeme
JWT_SECRET=changeme
```

## Config changes are manual — MUST
Database migration is automatic ([10-database](../10-database/)); `.env` and Compose changes on a deployed system are **not**. A human applies them by hand.

- The app, scripts and agents **MUST NOT** create, edit or overwrite `.env` / `.env.<env>` or Compose files on a deployed system.
- Agents change only the repo copies: `.env.sample` and `compose*.yaml`.
- New variables **SHOULD** have a safe default, so an upgrade works without editing `.env`.
- Each release that changes env or Compose **MUST** list the steps in `CHANGELOG.md` under `Manual steps`:

```md
### Manual steps
- .env: add `REDIS_URL` (required), rename `DB_PASS` → `DB_PASSWORD`, remove `OLD_FLAG`
- compose.prod.yaml: add service `redis`
```
- No changes → write `Manual steps: none`.

## Secrets
- Secrets **MUST NOT** be committed to Git, including history; if leaked → **rotate immediately**.
- Production **SHOULD** get secrets from a secret manager (Vault, AWS/GCP Secret Manager...) or Docker secrets.
- **MUST NOT** pass secrets via `ARG`/`ENV` in Dockerfiles or log them.
- See also [Security](../05-security/).
