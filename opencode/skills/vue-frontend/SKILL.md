---
name: vue-frontend
description: Generic Vue 3 guidance (Composition API, TypeScript, Pinia, Vitest). Use when working on a Vue codebase; no Vue repo exists in the workspace yet, so check the target repo's own conventions first.
---

# Vue 3 frontend

Check the target repo's `AGENTS.md`, `README.md` and existing components first; follow them.

- `<script setup lang="ts">`, Composition API, typed `defineProps` / `defineEmits`.
- State: local `ref`/`computed` first, Pinia stores for shared state only.
- API calls through a typed client generated from the OpenAPI spec (contract-first); no hand-written DTOs.
- Every async view handles loading / empty / error states explicitly.
- Composables (`useXxx`) for reusable logic; keep components presentational where possible.
- Tests: Vitest + Vue Test Utils; test behaviour, not implementation.
- Accessibility: semantic elements, labels, keyboard navigation.
