---
description: Create or resume a slice (ticket plan + state) — /slice <TICKET or name> [description]
---

Slice: $ARGUMENTS

Load the `slice-state` skill.

- If a slice folder matching the ticket exists in `~/projects/docs/slices/`: resume it. Read
  `slice.md`, re-check waiting gates (PRs merged? artifacts published?), update the state, then
  summarise status, tracks, open gates and **Next**, and continue with Next if it is actionable
  in this session (ask which role to act as if unclear).
- If not: act as the `architect` agent — create the folder from `_template`, ask for the ticket
  description, acceptance criteria and context (repos/projects) if missing, store any attached
  references in `refs/`, write the plan and set status `started`.

Always finish by updating `slice.md` (status, tracks, gates, tasks, Log, Next).
