---
name: to-tasks
description: Break a draft workstream into tracer-bullet task notes in the Obsidian vault, then put the plan through its review gate.
disable-model-invocation: true
---

Break a workstream into **tasks**: tracer-bullet vertical slices, ordered by what blocks what. The workstream is the one I name, else the `draft` workstream this conversation produced. Vault conventions are in the `obsidian-notes` skill.

## 1. Gather context

Read the workstream note in full. Explore the repo if you have not already, using the domain language of `GLOSSARY.md` if the repo has one. Look for prefactoring that makes the work easier: make the change easy, then make the easy change.

## 2. Draft vertical slices

- Each task cuts a narrow but complete path through every layer it touches, with tests: vertical, never one layer at a time.
- A finished task is demoable or verifiable on its own.
- Each task fits one fresh context window.
- Prefactoring comes first.

**Wide refactors are the exception.** A single mechanical change whose blast radius spans the codebase (renaming a shared symbol) goes as **expand, migrate, contract**: add the new form beside the old; migrate callers in batches, one task each; delete the old form in a final task.

Sequence lives in `order`. A task blocked by others gets a higher `order` than all of them; tasks that can run in parallel share a value.

## 3. Check with me

Show the breakdown as a numbered list: title, `order`, and the end-to-end behaviour each delivers. Ask whether the granularity is right, whether each `order` reflects a real dependency, and whether anything should merge or split. Iterate until I approve.

## 4. Write the tasks

One note per task from `Templates/Task.md` in `Projects/<project>/`, with `project`, `workstream`, `order` and `status: draft`:

- `## Summary`: the behaviour it delivers, then a **Done when:** line that is checkable, ideally a command whose output decides it.
- `## Steps`: the work as checkboxes, in order.
- `## Notes`: empty, or decisions specific to this task.

Leave file paths and code snippets out unless a step cannot be stated without one.

## 5. Review gate

No plan becomes `todo` without this.

1. Check every note against the `obsidian-notes` conventions yourself.
2. Start a read-only `Plan` subagent with a fresh context window, giving it every note in the plan and the repo it targets. It checks the plan **against reality**: do the named files, functions, paths and commands exist; are the steps executable in the order given; do any steps contradict each other; what does it assume without saying; would each done-when line catch a failure, or is it look-and-see?
3. Apply the findings, and record them under `### Review` in the workstream's `## Notes`, each with what was done about it, including those deliberately not acted on and why. Keep to findings that changed something or that someone would hit again.
4. Report to me. Set the workstream and its tasks to `todo` once every finding that changes a step, its order or its verification is resolved.

Done when every task note exists, the review is recorded, and the statuses are `todo`.

Next step: `/implement` on the first task by `order`.
