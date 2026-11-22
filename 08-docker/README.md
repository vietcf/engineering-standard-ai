# Docker & Docker Compose

## General
- Containerized projects **MUST** use Docker; multi-container setups **MUST** use Docker Compose.
- **SHOULD** keep one shared base `compose.yaml`; environment files override only the differences.

## Structure
```
project/
├── compose.yaml          # shared services
├── compose.dev.yaml      # dev overrides
├── compose.test.yaml     # test overrides
├── compose.staging.yaml  # staging overrides
├── compose.prod.yaml     # prod overrides
├── .env.sample
├── .dockerignore
├── docker/<service>/Dockerfile
├── data/                 # runtime system data
│   ├── <database>/       # e.g. data/postgres, data/redis
│   └── uploads/          # user-uploaded files
├── backup/               # backups (DB dumps, uploads archives)
├── certs/                # TLS certificates / keys
└── dist/                 # exported images (see tools/)
```
Run: `docker compose -f compose.yaml -f compose.<env>.yaml -p myapp-<env> up -d`

## Dockerfile — MUST
- Use an official/trusted base image with a **pinned version** (`node:22-alpine`, not `latest`).
- Use multi-stage builds when there is a build step.
- Run as a non-root user (`USER`).
- Contain no secrets; include a `.dockerignore` (`.git`, `.env`, `node_modules`...).
- Keep the image minimal; no unnecessary packages.

```dockerfile
FROM node:22-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM node:22-alpine
WORKDIR /app
ENV NODE_ENV=production
COPY package*.json ./
RUN npm ci --omit=dev && npm cache clean --force
COPY --from=build /app/dist ./dist
USER node
EXPOSE 3000
CMD ["node", "dist/index.js"]
```
*Node example — adapt to the actual runtime.*

## Production container security — SHOULD
```yaml
services:
  app:
    read_only: true
    user: "1000:1000"
    cap_drop: [ALL]
    security_opt: ["no-new-privileges:true"]
    ports: ["127.0.0.1:3000:3000"]   # expose only required ports
    networks: [backend]
    healthcheck:
      test: ["CMD", "wget", "-qO-", "http://localhost:3000/health"]
      interval: 30s
      retries: 3
    deploy:
      resources:
        limits: { cpus: "1", memory: 512M }
    volumes:                         # mount only data that must persist
      - ./data/uploads:/app/uploads
      - ./certs:/app/certs:ro
```
- **MUST NOT** use `privileged: true`.

## Environment isolation — MUST
- Each environment has its own project name: `myapp-dev`, `myapp-test`, `myapp-staging`, `myapp-prod`.
- Volumes, networks and data are **not** shared across environments.
- Production **MUST NOT** bind mount source code.

## Data, backup, certs — MUST
| Folder | Content | Mount |
|---|---|---|
| `./data/<database>` | Database files (`data/postgres`, `data/mysql`, `data/redis`...) | read-write, DB service only |
| `./data/uploads` | User-uploaded files | read-write, app only |
| `./backup` | Backups of `data/` (DB dumps, uploads archives) | backup job only |
| `./certs` | TLS certificates / keys | `:ro` |

- All persistent data **MUST** live under `./data`; containers **MUST NOT** store data elsewhere.
- `data/`, `backup/`, `certs/` **MUST** be in `.gitignore` and `.dockerignore`; keep the folders with `.gitkeep`.
- Private keys in `certs/` **MUST NOT** be committed or baked into images.
- Backups **SHOULD** be timestamped (`backup/postgres_YYYYMMDD-HHMMSS.sql.gz`) and **SHOULD** be copied off the host.
- **MUST NOT** delete or overwrite `data/` or `backup/` without human approval.

## Image export / import (offline deploy)
Projects **SHOULD** include [tools/](../tools/) scripts (`.sh` for Linux/macOS, `.bat` for Windows):

| Script | Usage | Default |
|---|---|---|
| `docker-export` | `[version\|latest] [out_dir]` | highest local `X.Y.Z` tag → `<project>/dist` |
| `docker-import` | `[version\|latest] [dist_dir]` | highest `X.Y.Z` file in `<project>/dist` |

- Image name = `$IMAGE_NAME`, or the project folder name (lowercase, spaces → `-`).
- File name: `<name>_<version>.tar`.

```sh
tools/docker-export.sh                 # myapp:<highest X.Y.Z> -> dist/myapp_1.2.0.tar
tools/docker-export.sh 1.1.0           # myapp:1.1.0
tools/docker-import.sh                 # load highest version in dist/
tools/docker-import.sh 1.1.0 /mnt/usb  # load /mnt/usb/myapp_1.1.0.tar
```
- Release images **MUST** be tagged `X.Y.Z` (SemVer, optional `v`); `latest`, `dev`... are ignored.
- `dist/` **MUST** be in `.gitignore`.
