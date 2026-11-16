---
name: python-django
description: Working in the legacy Django repos (swo-zapps-lictionary, swo-zapps-zyncc-workflow) and Python API clients generated from swo-zyncc-api-spec. Use for Django models/views/DRF, Celery tasks, tests and debugging.
---

# Python / Django

Legacy repos: `swo-zapps-lictionary` (Django + React/Rematch) and `swo-zapps-zyncc-workflow`
(Django + Backbone/CoffeeScript). Read each repo's `AGENTS.md`, `README.md`, `Makefile` and `docs/`
first — they define how to run and test (docker-compose, `runtests.py`).

## Conventions

- Match the existing Django/DRF version and style; do not modernise opportunistically.
- Validation in serializers/forms, not views. Permissions explicit on every view.
- ORM: watch N+1 (`select_related` / `prefetch_related`), wrap multi-write operations in
  `transaction.atomic`.
- Migrations: one per change, reviewed, reversible where possible; never edit applied migrations.
- Celery tasks idempotent; pass IDs, not model instances.
- If a service is described by a spec in `swo-zyncc-api-spec`, the spec wins (contract-first);
  Python clients there are generated with openapi-generator (`./gradlew :clients:<dir>:openApiGenerate`).
- Every bug fix gets a regression test.
