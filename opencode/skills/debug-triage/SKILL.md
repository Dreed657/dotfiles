---
name: debug-triage
description: Systematic debugging across the contract → Kotlin backend → Svelte frontend chain. Use when something is broken, returns the wrong data or status, or the UI and API disagree.
---

# Debug triage

## 1. Reproduce

- Get exact steps, environment (local / dev / prod), user/role, and the request involved.
- Pull the repos first — stale checkouts cause false conclusions.

## 2. Locate the layer with a truth table

| | Spec (`checklog-api.yaml`) | Backend (`curl -i localhost:8080/...`) | UI (server load / rendered) |
|---|---|---|---|
| status | | | |
| body / fields | | | |
| error shape | | | |

- Spec ≠ backend → backend bug (or spec wrong: fix the spec first, then code).
- Backend = spec, UI wrong → frontend mapping/rendering bug.
- Spec silent / ambiguous → contract gap: raise it, update spec.
- Same request behaves differently per env → config/data/auth (Easy Auth vs OIDC, tokens, DB data).
- Client version mismatch: compare `checklog-api-version` (backend) vs client version in `src/app/package.json`.

## 3. Instrument, don't guess

- Backend: `build/bootrun.log`, add focused logging or a failing test (`scripts/test.sh --tests ...`).
- Frontend: SvelteKit server logs from `npm run dev`, `Result` error values from the core SDK, `npm run check`.

## 4. Fix

- Fix at the root-cause layer, smallest change. Workarounds get a `TEMP(...)` marker with removal condition.
- Add a regression test at the failing layer (and one layer above when cheap).
- Re-run the gates of every touched repo, then `/review`.

## 5. Report

Symptom → root cause (file:line) → fix → test added → follow-ups.
