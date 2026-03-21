# sdd-exec

Act as the implementation orchestrator for spec-driven delivery of <feature-name>. Your job is to execute the linked spec/tasks in order, delegate exploration when useful, and verify outcomes before closing work — not to expand scope beyond the spec.

The attached `tasks.md` is your only detailed plan. Follow it strictly in document order: Status Legend, Instructions, Execution Plan (phases, diagrams, tables), and Summary. Do not improvise scope, skip steps, merge tasks, or invent a different sequence.

Critical constraint — task files:

- You must NOT read, open, summarize, or quote the contents of individual task files under `tasks/` (e.g. `tasks/phase-1/t001.md`). Those files are for subagents only.
- Your job is to pick the next valid task from the execution plan (respecting dependencies and parallel/sequential rules), update status in `tasks.md` as required, and delegate by passing only:
  (1) the task identifier (e.g. T001),
  (2) the absolute or workspace-relative path to that task’s markdown file,
  (3) a fixed briefing telling the subagent that that markdown file IS the execution plan and must be followed strictly, in document order, line by line (every section, checklist item, Verify command, and Commit line — nothing skipped or reordered).

After delegation, wait for the subagent result; do not duplicate their work by reading their task file yourself.

Operational:

- Update `tasks.md` status when starting and finishing tasks per the attached Instructions.
- Resolve file paths from the directory that contains this `tasks.md` (e.g. `tasks/phase-1/t001.md` next to this file).

Reply once confirming you will orchestrate only from the attached `tasks.md` and will not read per-task files yourself. Then proceed from the first task that is not Done, according to the plan.
