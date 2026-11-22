# Engineering Standard

Standard for **AI coding agents**. Entry point: [AGENTS.md](AGENTS.md).

Keywords: **MUST** = required · **SHOULD** = recommended, deviate only with a reason · **MUST NOT** = forbidden.

| Section | Content |
|---|---|
| [01-principles](01-principles/) | General principles |
| [02-coding](02-coding/) | Coding conventions |
| [03-git](03-git/) | Branch, commit, PR |
| [04-testing](04-testing/) | Testing |
| [05-security](05-security/) | Security |
| [06-ci-cd](06-ci-cd/) | Build & deploy |
| [07-docs](07-docs/) | Documentation |
| [08-docker](08-docker/) | Docker & Compose |
| [09-env-config](09-env-config/) | Env & secrets |
| [templates](templates/) | Shared templates |
| [tools](tools/) | Docker image export / import scripts |

## Using it with an AI coding agent

**1. Add the standard to your project**
```sh
# as a submodule (easy to update)
git submodule add https://github.com/vietcf/engineering-standard-ai.git docs/engineering-standard
# or copy the folder into docs/engineering-standard/
```
Copy `tools/` to the project root if you use Docker.

**2. Create `AGENTS.md` at the project root** — keep it short, project-specific:
```md
# AGENTS.md
Follow docs/engineering-standard/AGENTS.md. Project rules below win on conflict.

## Project
- Stack: Node 22, PostgreSQL 16
- Install: `npm ci` · Lint: `npm run lint` · Test: `npm test` · Build: `npm run build`
- Run: `docker compose -f compose.yaml -f compose.dev.yaml -p myapp-dev up -d`

## Project-specific rules
- ...
```
The commands **must** be real — the agent runs them before reporting done.

**3. Point your agent at it**
| Agent | File it reads |
|---|---|
| Codex, Cursor, GitHub Copilot, most others | `AGENTS.md` (automatic) |
| Claude Code | `CLAUDE.md` → put one line: `@AGENTS.md` |

**4. Start each task with**
> Read AGENTS.md and follow the engineering standard. Task: ...

**Update**: `git submodule update --remote docs/engineering-standard`, then review the changes.
