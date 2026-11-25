# Changelog

## 1.1.0 — 2026-11-25
- Add `10-database`: automatic migration at startup.
- `09-env-config`: `.env` and Compose changes are applied by hand and listed under `Manual steps`.
- Rename `backup/` to `backups/`.

### Manual steps
- Rename an existing `backup/` folder to `backups/`; update paths in Compose, `.gitignore` and `.dockerignore`.

## 1.0.0 — 2026-11-22
- Initial standard for AI coding agents: principles, coding, git, testing, security, CI/CD, docs, Docker, env config.
- `AGENTS.md` entry point, PR and ADR templates.
- `tools/docker-export` and `tools/docker-import` (`.sh`, `.bat`).
