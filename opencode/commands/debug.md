---
description: Triage and fix a bug across spec, backend and frontend — /debug <TICKET?> <symptom>
---

Debug this issue: $ARGUMENTS

Load `debug-triage`, `slice-state` and the skill for each layer involved. If a ticket is given, use
(or create from `_template`) its slice and record findings in `notes.md`, evidence in `refs/`.
Reproduce first, build the spec/backend/UI truth table, identify the root-cause layer, then propose
(or apply) the smallest fix with a regression test. Finish with the skill's report format and update
`slice.md` (status, tasks, Log, Next).
