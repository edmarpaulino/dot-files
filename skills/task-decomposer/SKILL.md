---
name: task-decomposer
description: Reads spec.md + design.md and produces atomic task files (tasks.md + tasks/phase-N/tXXX.md) with dependency graphs, complexity ratings, and verification criteria. Use when you have a spec and design ready and want to decompose them into tasks, or when someone says "decompose tasks", "create task files", "break down the spec into tasks", "generate task files", "decompor as tasks". Do NOT use for writing the spec itself (use tlc-spec-driven specify phase), creating architecture designs (use tlc-spec-driven design phase), or executing tasks (use tlc-spec-driven execute phase).
---

# Task Decomposer

Transform a `spec.md` + `design.md` into an executable task graph. Each task is atomic, independently verifiable, and carries its own commit message.

```
spec.md + design.md → tasks.md + tasks/phase-N/tXXX.md
```

---

## Step 1 — Read the Spec and Design

Load both files before producing any output:

1. Read `spec.md` — extract requirement IDs (e.g. `IEF-01`), acceptance criteria, edge cases
2. Read `design.md` — extract every component marked `[MODIFY]`, `[NEW]`, or `[DELETE]` with its file path

Map each `[MODIFY/NEW/DELETE]` entry to the requirement ID it satisfies. This is the source of truth for task scope.

---

## Step 2 — Classify Each Change

Rate every identified change before grouping:

| Complexity | Emoji | Criteria                                                  |
| ---------- | ----- | --------------------------------------------------------- |
| Simple     | 🟢    | ≤1 file, mechanical change (rename, remove, add prop)     |
| Medium     | 🟡    | 2–3 files, clear pattern but requires judgment            |
| Complex    | 🔴    | 3+ files or architectural decision with cascading effects |

**One change per task.** Never bundle unrelated files into a single task.

**Complexity minimization is mandatory.** The target distribution is: all Simple, some Medium, almost no Complex. Before rating any change as Medium or Complex, ask: "Can I split this into smaller tasks that each touch fewer files?" A Complex task is a last resort — acceptable only when the coupling is truly architectural and cannot be separated without breaking the implementation. If you rate a task Complex, document why it cannot be split further.

---

## Step 3 — Group into Phases

Phase boundaries follow dependency chains, not arbitrary size limits.

**Rules:**

- Tasks with no dependencies on each other **within the same phase** can be marked parallel (`‖`)
- An **integration checkpoint** (build + test + lint) ends each phase — never skip it
- Final phase is always a **full validation** (build + test + lint + format:check + manual checks)
- Sequential dependency between tasks: `T001 → T002`
- Parallel tasks that converge: `T001 ‖ T002 → T003`

**Typical phase shape:**

```
Phase 1: Prerequisites (always sequential)
Phase N: Feature work (mix of parallel and sequential)
Phase N+1: Integration checkpoint
Phase Last: Full validation
```

---

## Step 4 — Write `tasks.md`

Output the master file at `.specs/features/[feature]/tasks.md`:

```markdown
# [Feature Name] — Tasks

**Spec**: `spec.md`
**Design**: `design.md`
**Status**: Draft

---

## Status Legend

| Status | Emoji | Meaning     |
| ------ | ----- | ----------- |
| To Do  | ⬜    | Not started |
| Doing  | 🔵    | In progress |
| Done   | ✅    | Completed   |

| Complexity | Emoji | Meaning                          |
| ---------- | ----- | -------------------------------- |
| Simple     | 🟢    | ≤1 file, trivial change          |
| Medium     | 🟡    | 2-3 files, clear pattern         |
| Complex    | 🔴    | 3+ files, architectural decision |

---

## Instructions

1. Orchestrator **must not** read or modify task files under `tasks/`; only pass _task id_ + _path_ to the subagent.
1. When you start a task, set its status to `Doing` in `tasks.md`.
1. When you finish a task, set its status to `Done` in `tasks.md`.
1. Delegate every task to a subagent based on task's complexity (see **Complexity** above).
1. When you delegate, tell the subagent explicitly that the linked task markdown **is** the execution plan—not a summary to improvise from. They **must** follow that file **strictly, in document order, line by line**: every section, checklist item, **Verify** command, and **Commit** line, with no skipped or reordered steps. The subagent is also responsible for: updating `**Status**` in the task file to `🔵 Doing` when starting, ticking each `## Done When` checkbox as it completes, and setting `**Status**` to `✅ Done` when finished.

---

## Execution Plan

### Phase 1: [Phase Name] ([Dependency pattern])

[ASCII dependency graph]

| Task                          | Description | Complexity | Status   | Requirement |
| ----------------------------- | ----------- | ---------- | -------- | ----------- |
| [T001](tasks/phase-1/t001.md) | ...         | 🟢 Simple  | ⬜ To Do | REQ-01      |

[repeat for each phase]

---

## Summary

| Phase     | Tasks | 🟢 Simple | 🟡 Medium | 🔴 Complex | Status |
| --------- | ----- | --------- | --------- | ---------- | ------ |
| 1         | N     | n         | n         | n          | ⬜     |
| **Total** | **N** | **n**     | **n**     | **n**      | ⬜     |
```

---

## Step 5 — Write Individual Task Files

One file per task at `tasks/phase-N/tXXX.md`. Use zero-padded numbers (t001, t002, …).

### Required Sections

````markdown
# TXXX: [Short imperative title]

**Phase**: N — [Phase Name]
**Complexity**: [🟢/🟡/🔴] [Simple/Medium/Complex]
**Status**: ⬜ To Do
**Requirement**: [REQ-ID or —]

---

## What

[One paragraph: what changes and why it matters.]

## Where

- `path/to/file.ts` → [MODIFY / NEW / DELETE]
- `path/to/file.ts` → [MODIFY / NEW / DELETE]

## Depends On

[Task IDs, e.g. T002, T003, or "None"]

## Done When

- [ ] [Specific, observable outcome]
- [ ] [Specific, observable outcome]
- [ ] `npm run build` passes
- [ ] `npm run test` passes

## Verify

```bash
[Commands to verify the change is correct]
```
````

## Commit

```
[conventional-commit-type(scope): imperative sentence]
```

````

### Optional Sections

Add **`## Reuses`** when the task leverages an existing component without modifying it:

```markdown
## Reuses

[Component name] at `path/to/file` — used as-is for [reason].
````

Add **`## Implementation Guide`** for Medium/Complex tasks where the approach is not self-evident. Include before/after code snippets when they eliminate ambiguity:

```markdown
## Implementation Guide

[Concise description of the non-obvious approach, with code snippets if needed.]
```

---

## Checkpoints and Validation Tasks

Integration checkpoints have no `## Commit` section (they produce no code):

````markdown
# TXXX: Integration checkpoint — Phase N

**Phase**: N — [Phase Name]
**Complexity**: 🟢 Simple
**Status**: ⬜ To Do
**Requirement**: —

---

## What

Run full build + test suite + lint to validate all Phase N changes together.

## Where

- Root workspace

## Depends On

[All tasks in the phase]

## Done When

- [ ] `npm run build` passes
- [ ] `npm run test` passes
- [ ] `npm run lint` passes

## Verify

```bash
npm run build && npm run test && npm run lint
```
````

````

The **final validation task** adds `format:check` and manual verification steps:

```markdown
## Done When

- [ ] `npm run build` passes
- [ ] `npm run test` passes
- [ ] `npm run lint` passes
- [ ] `npm run format:check` passes

## Manual Verification Checklist

- [ ] [Specific user-facing behavior to confirm]
- [ ] [Specific user-facing behavior to confirm]
````

---

## ASCII Dependency Graph Reference

Use ASCII to show phase execution shape. Examples:

**Sequential:**

```
T001 → T002 → T003 → T004
```

**Parallel then converge:**

```
     ┌→ T001 ─┐
     │        ├→ T003 → T004
     └→ T002 ─┘
```

**Sequential into parallel then converge:**

```
       ┌→ T005 ─┐
T004 ──┼→ T006 ─┼→ T008
       └→ T007 ─┘
```

---

## Conventional Commit Types

| Type       | When to use                              |
| ---------- | ---------------------------------------- |
| `feat`     | New user-facing capability               |
| `fix`      | Correcting broken behavior               |
| `perf`     | Performance improvement, no API change   |
| `refactor` | Internal restructure, no behavior change |
| `test`     | Adding or fixing tests only              |
| `chore`    | Build, tooling, dependencies             |
| `docs`     | Documentation only                       |

Scope mirrors the package or directory changed: `ide-extension`, `cli`, `core`, `skills-catalog`.

---

## Output Checklist

Before presenting the decomposition to the user, verify:

- [ ] Every `[MODIFY/NEW/DELETE]` entry in `design.md` is covered by at least one task
- [ ] Every requirement ID in `spec.md` maps to at least one task
- [ ] No task touches more than one logical concern
- [ ] Every Complex task has a written justification for why it cannot be split further
- [ ] Every phase ends with an integration checkpoint (except the last, which has full validation)
- [ ] `tasks.md` summary totals match the actual count of task files
- [ ] Each task file has: What, Where, Depends On, Done When, Verify — Commit is optional only for checkpoints
