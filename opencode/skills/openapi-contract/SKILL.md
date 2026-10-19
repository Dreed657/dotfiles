---
name: openapi-contract
description: How to change and consume the OpenAPI specs in swo-zyncc-api-spec (yaml-specs, Gradle server artifacts, orval/openapi-generator clients, versioning). Use when editing a spec, regenerating clients, or checking contract drift.
---

# OpenAPI contracts (`~/projects/swo-zyncc-api-spec`)

Read `README.md` and `clients/README.md` first; they are authoritative.

## Layout

- `yaml-specs/<api>.yaml` — specs; `yaml-specs/common/` — shared components.
- `servers/<api>/build.gradle` — Kotlin/Spring server interfaces + models (openapi-generator).
- `clients/clients.json` — registry of every published client; `clients/<dir>/` — one per client.
  - orval clients (`checklog-client-ts`, `-svelte`, `-react`): `npm run generate`.
  - openapi-generator clients (python, workflow-ts): `./gradlew :clients:<dir>:openApiGenerate`.
- Releases: semantic-release, conventional commits, lockstep versions for everything.

## Rules for editing a spec

- Additive changes preferred (new optional fields, new endpoints). Breaking changes
  (removed/renamed fields, new required request fields, type/enum changes, status-code changes)
  need a `feat!:` / `BREAKING CHANGE:` commit and a migration note in the slice spec.
- Every operation: `operationId`, tags, all realistic responses (`400/401/403/404/409/422/500` as
  applicable) with a schema, examples for request and response.
- Explicit `required` and `nullable`; enums with stable casing (the UI has `TEMP(checklog-client: status casing)`
  workarounds — do not make it worse).
- Reuse `components/schemas` and `common/`; no inline duplicate schemas.
- Pagination/sort follow the existing patterns (`toPagination`, `*_SORT_FIELDS` in the TS client).

## Drift check

For each endpoint compare: spec ↔ Kotlin controller (implements the generated interface?) ↔
UI usage (imports types from the client, handles every declared status). Report mismatches as
"spec says X, code does Y".
