---
name: svelte-frontend
description: Working in swo-spi-services_portal-ui-zyncc (SvelteKit 2 / Svelte 5 runes Zyncc portal, Checklog feature). Use for building routes, feature modules, forms, tables, API client usage, tests and debugging UI issues.
---

# Svelte frontend (`~/projects/swo-spi-services_portal-ui-zyncc`)

Read first: repo `AGENTS.md`, `docs/ZYNCC.md` (mandatory for checklog work), `docs/ARCHITECTURE.md`,
`docs/DEVELOPMENT_GUIDE.md`, `docs/MESSAGES_GUIDE.md`, `src/app/AGENTS.md` (Svelte MCP tooling),
and `~/projects/docs/ZYNCC-UI-REPO.md`.

## Ground rules

- We own `src/app/` only. `src/iac/` and `.github/workflows/` belong to another team.
- **npm**, not pnpm. Branches `SC-XXX` → `develop`; rebase, never merge.
- Stack: SvelteKit 2, Svelte 5 runes, `adapter-node`, base path `/zyncc`, Tailwind v4,
  `@softwareone/spi-sv5-library`, superforms + zod, `@tanstack/table-core`, `@software-one/spi-core-sdk-ts`
  (HTTP client + `Result`). **No TanStack Query.**
- The SvelteKit server calls the Kotlin backend directly (no proxy, no browser calls to the API).
- Auth: OIDC PKCE locally, Azure Easy Auth when deployed.

## Building a feature

- Copy the reference module `questions-library`; don't copy code marked `DEVIATION(...)`.
- Look for existing helpers in order: libraries → `$shared` → `$features/checklog` → custom shim
  marked `TEMP(<source>: <topic>)`.
- Types and helpers come from `@software-one/spi-zyncc-checklog-client-ts`; never hand-write DTOs.
- Data loading in `+page.server.ts` / form actions; handle every status the contract declares
  with explicit loading / empty / error UI.
- Use Svelte 5 runes (`$state`, `$derived`, `$props`, `$effect` sparingly); no legacy stores for new code.

## Commands (in `src/app/`)

`npm run dev` · `npm run check` · `npm run lint` · `npm run format` · `npm run test` · `npm run build`

CI currently runs nothing on our PRs (see WORKSPACE.md) — run check/lint/test locally every time.

## Reference

`~/projects/svelte/` (other team's apps + Svelte how-to) is read-only reference.
`svelte-playground/` and `svelte-migration-assessment/` are history/assumptions — do not follow.
