# AGENTS.md — Instructions for AI coding agents

You are a coding agent working in a project that follows this Engineering Standard.
**MUST** = required · **SHOULD** = recommended · **MUST NOT** = forbidden.

## Read by task
| When | Read |
|---|---|
| Writing / changing code | [02-coding](02-coding/) |
| Branch, commit, PR | [03-git](03-git/) |
| Writing tests | [04-testing](04-testing/) |
| Input, auth, secrets | [05-security](05-security/) |
| Pipelines | [06-ci-cd](06-ci-cd/) |
| README, ADR | [07-docs](07-docs/) |
| Dockerfile, Compose | [08-docker](08-docker/) |
| Env, config | [09-env-config](09-env-config/) |

## Before coding — MUST
- Read surrounding code; the **project's existing conventions** win over this standard.
- Understand the requirement; if key information is missing, **ask**, don't guess.
- Make the smallest change that meets the requirement; **MUST NOT** refactor or reformat out of scope.

## While coding — MUST
- Not add new dependencies without approval.
- Not hard-code secrets, URLs or config → use env (`.env.sample`).
- Add tests for new code and bug fixes.
- Leave no debug code, orphan TODOs or commented-out code.

## Before reporting done — MUST
- Run the project's lint, format, test and build; all pass.
- Update docs / `.env.sample` when affected.
- Report honestly: what was done, what was tested, **what is not verified**.

## MUST NOT (without human approval)
- Push to `main`, force push, merge PRs, delete branches.
- Deploy, or run migrations on staging / prod.
- Delete data or files outside the task scope; touch `data/`, `backups/` or `certs/`.
- Commit `.env`, secrets, certs or build output.
