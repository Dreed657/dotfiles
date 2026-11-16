---
name: slice-state
description: How to create, resume and update a slice folder (docs/slices/<TICKET>-<slug>/) — the shared plan and state for a ticket across sessions and roles. Load at the start and end of any work on a ticket.
---

# Slice state

A **slice** is one ticket's plan + state, stored on disk so any session (or person) can continue.
Template: `~/projects/docs/slices/_template/`.

```text
docs/slices/<TICKET>-<slug>/
├── slice.md      canonical plan + state (the ONLY file roles must keep current)
├── notes.md      free-form working notes, findings, commands that worked
├── refs/         screenshots, designs, payload samples, logs (link them from slice.md)
└── handoffs/     optional longer handoff notes: <yyyy-mm-dd>-<role>.md
```

## Resume (start of every session)

1. Find the slice: `ls ~/projects/docs/slices/ | grep -i <ticket>`.
2. Read `slice.md` fully: status, tracks, gates, last log entries, **Next**.
3. Check `waiting-external` gates are still pending (PR merged? artifact published?) and update them.
4. Pull the repos listed in Context before trusting code.

## Update (end of every action — mandatory)

Before ending your turn after any meaningful action, edit `slice.md`:

1. Set **Status** and the affected **Tracks**.
2. Tick/update **Gates** and **Tasks**.
3. Append one entry to **Log** (newest last, never rewrite old entries):
   `- <yyyy-mm-dd HH:MM> | <role> | <what was done> | <status before → after> | <links: PR/commit/version> `
4. Rewrite **Next** so a fresh session knows exactly what to do (or what it is waiting for).
5. Bump `updated:` in the front matter.

## Overall status

| Status | Meaning |
|---|---|
| `created` | folder exists, plan not done |
| `started` | architect plan written, ready to build |
| `in-progress` | builder working |
| `waiting-external` | blocked on others (PR review, artifact publish, answers). Say on what in Next. Work on another slice. |
| `blocked` | cannot proceed, needs a decision |
| `review-ready` | builder done, reviewer to run |
| `changes-requested` | reviewer found blockers/must-fix → builder |
| `done` | all gates passed, reviewer approved, merged |

Transitions: architect `created → started` · builder `started|changes-requested → in-progress → review-ready`
(or `→ waiting-external/blocked` and back) · reviewer `review-ready → changes-requested | done`.

## Tracks

Per-workstream status, only for tracks the slice needs. Values:
`todo | in-progress | blocked | waiting-external | review-ready | done | n/a`.
Common tracks: `contract`, `backend`, `frontend`, `review`; add `infra`, `data`, `docs`, `release`, ...
as needed. Each track names its repo and branch/PR.

## Roles

- **architect** — creates the folder, fills Ticket/Context/Plan/Gates/Tasks, sets `started`.
- **builder** (default build agent) — does tasks, keeps Tasks/Tracks/Gates/Log/Next current.
- **reviewer** — appends a Review section entry + Log, sets `changes-requested` or `done`.
