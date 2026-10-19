---
name: contract-first-slice
description: End-to-end workflow for a contract-first full slice from swo-zyncc-api-spec (OpenAPI) through swo-zapps-checklog (Kotlin) to swo-spi-services_portal-ui-zyncc (Svelte). Use when planning or building any feature that crosses spec, backend and frontend.
---

# Contract-first full slice

Order is fixed: **spec → backend → frontend → verify**. Never let code lead the contract.

## 0. Prepare

```bash
for r in swo-zyncc-api-spec swo-zapps-checklog swo-spi-services_portal-ui-zyncc; do
  git -C ~/projects/$r fetch && git -C ~/projects/$r status -sb; done
```

Create branch `SC-XXX-<slug>` in each touched repo (rebase, never merge).
Create or resume the slice folder in `~/projects/docs/slices/` (`/slice`, `slice-state` skill) and
record every step below in its Gates / Tracks / Log.

## Gates (the slice waits between them)

1. Contract PR opened → slice `waiting-external` on team review (do other work meanwhile).
2. Contract PR merged → released versions published (Maven `checklog-api`, npm client). Record versions.
3. Backend and frontend bump to the released versions → `in-progress`.
4. Integrated verification → `review-ready` → reviewer.

The local loop below lets BE/FE start before gate 2, but they must not merge on SNAPSHOT/local deps.

## 1. Contract (`swo-zyncc-api-spec`)

- Edit `yaml-specs/checklog-api.yaml` (shared bits in `yaml-specs/common/`). See `openapi-contract` skill.
- Validate visually: `docker compose up -d` (Swagger UI).
- Server stubs (Kotlin): `servers/zyncc-checklog-api` → artifact `com.softwareone.zyncc:checklog-api`.
- TS client: `clients/checklog-client-ts` (orval) → `@software-one/spi-zyncc-checklog-client-ts`.
- Conventional commits; the repo releases in lockstep via semantic-release.

### Local loop before the spec is released

```bash
# backend artifact
cd ~/projects/swo-zyncc-api-spec && ./gradlew publishToMavenLocal -Pversion=0.0.0-SC-XXX-SNAPSHOT
# set checklog-api-version in swo-zapps-checklog/gradle/libs.versions.toml (mavenLocal() is enabled)

# TS client
cd clients/checklog-client-ts && npm run generate && npm run build
# in src/app of the UI repo: npm install <path-to>/clients/checklog-client-ts  (DO NOT commit this)
```

Revert local versions to the released ones before merging.

## 2. Backend (`swo-zapps-checklog`)

Load `kotlin-backend`. Implement the generated API interface in `checklog-rest`, logic in
`checklog-core`/`checklog-service`, persistence/migrations in `checklog-db`. Map errors to the
contract's status codes and bodies. `scripts/test.sh`, `scripts/lint.sh --fix`, `scripts/start.sh`.

## 3. Frontend (`swo-spi-services_portal-ui-zyncc/src/app`)

Load `svelte-frontend`. Read `docs/ZYNCC.md`. Use client types/helpers, never hand-written DTOs.
Handle loading / empty / error states for every status the contract declares.
`npm run check && npm run lint && npm run test`.

## 4. Verify

- Run backend (`scripts/start.sh`) + UI (`npm run dev`) and exercise the happy path and each error.
- Truth table per endpoint: expected (spec) vs actual (backend) vs rendered (UI).
- Invoke the `reviewer` agent (`/review`). Blockers must be zero.

## Definition of done

Spec merged & released → backend and UI pinned to the released version → all gates green →
reviewer approves → no local `file:` / SNAPSHOT references remain.
