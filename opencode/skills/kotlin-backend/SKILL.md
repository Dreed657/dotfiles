---
name: kotlin-backend
description: Working in swo-zapps-checklog, the Kotlin/Spring Boot Checklog backend (JDK 25, Gradle multi-module). Use for implementing endpoints, services, persistence, tests, running the dev server, and debugging backend issues.
---

# Kotlin backend (`~/projects/swo-zapps-checklog`)

Read the repo's `AGENTS.md`, `README.md` and `docs/` first. They win over this file.

## Commands (always via scripts — they load `.env` and the Zscaler truststore)

| Task | Command |
|---|---|
| Build | `scripts/build.sh` |
| Test | `scripts/test.sh [gradle args]` e.g. `scripts/test.sh :checklog-rest:test --tests '*Questions*'` |
| Lint | `scripts/lint.sh --fix` (run before finishing) |
| Run | `scripts/start.sh` (background, waits for `localhost:8080/hello`, log `build/bootrun.log`) / `scripts/stop.sh` |

Never use `scripts/run.sh` (it never returns). Docker services (Postgres) are assumed running —
do not start/stop them. Never put credentials in the repo (`~/.gradle/gradle.properties`, `~/.certs/`).

## Modules

- `checklog-rest` — controllers in `api/`, DTO↔domain `mappers/`, `security/`. Controllers implement
  the interfaces generated from `checklog-api.yaml` (artifact `com.softwareone.zyncc:checklog-api`,
  version in `gradle/libs.versions.toml`).
- `checklog-core` — domain and business logic.
- `checklog-db` — persistence, migrations.
- `checklog-service` — Spring Boot app entry point/wiring.

## Conventions

- Follow the contract exactly: generated models in, generated models out; map in `mappers/`.
- Kotlin nullability mirrors spec `required`/`nullable`; no `!!` on request data.
- Errors: throw domain exceptions, translate centrally to the contract's status + error body.
- Transactions at the service layer; keep controllers thin.
- Every bug fix gets a regression test at the failing layer.
- Copy patterns from neighbouring controllers/tests rather than inventing new ones.

## Debugging

- Logs: `build/bootrun.log`. Reproduce with `curl -i localhost:8080/<path>` (bare paths, no `/api`).
- Common setup failures (401 from Artifactory, PKIX, hanging `compileKotlin`, port 8080 busy):
  see README "Running from the CLI".
