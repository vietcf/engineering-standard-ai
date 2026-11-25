# Database Migration

## Automatic migration — MUST
- The system applies pending migrations **automatically at startup**, before accepting traffic; no manual SQL step on upgrade.
- Every schema change is a versioned migration file in the repo; **MUST NOT** change a schema by hand.
- Track applied migrations in the database; re-running is a no-op.
- Take a lock so only one instance migrates at a time.
- On failure: stop startup, log the failing migration, exit non-zero. **MUST NOT** run on a half-migrated schema.

## Writing migrations
- **MUST NOT** edit or delete a migration that has been released; add a new one.
- **MUST** be tested on an empty database and on the previous release's schema with data.
- **MUST** keep data; dropping / truncating tables or columns needs human approval.
- **SHOULD** use a transaction when the database supports it.
- **SHOULD** stay compatible with the previous release (add first, remove in a later release).

## Before upgrading production — MUST
- Back up the database to `./backups` and confirm the backup can be restored.
- Apply manual config changes first: see [09-env-config](../09-env-config/).
