# CI/CD

**CI** (every PR): `install → lint → test → build`.

| Environment | Trigger |
|---|---|
| dev | merge to `main` |
| staging | after dev / `rc` tag |
| production | release tag `vX.Y.Z`, human approval |

- **MUST** be able to run the CI steps locally before pushing.
- **MUST** define pipelines as code in the repo.
- **MUST** version with [SemVer](https://semver.org/).
- **MUST NOT** bypass failing CI (`--no-verify`, `continue-on-error`, removing jobs).
- **MUST NOT** deploy to staging / prod or create release tags without approval.
