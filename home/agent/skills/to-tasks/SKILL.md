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
- A finished task is demoable or verifiable on its own, at one of the workstream's seams.
- Each task fits one fresh context window.
- Prefactoring comes first.
- Every behaviour in the workstream is delivered by at least one task, and every task serves at least one behaviour.

**Wide refactors are the exception.** A single mechanical change whose blast radius spans the codebase (renaming a shared symbol) goes as **expand, migrate, contract**: add the new form beside the old; migrate callers in batches sized by blast radius (per package or directory), one task each; delete the old form in a final task. When batches cannot stay green alone, they share an integration branch and a final integrate-and-verify task is the first point that must pass.

Sequence lives in `order`. A task blocked by others gets a higher `order` than all of them; tasks that can run in parallel share a value.

## 3. Check with me

Show the breakdown as a numbered list: title, `order`, the behaviours it delivers, and the end-to-end behaviour in a line. Ask whether the granularity is right, whether each `order` reflects a real dependency, and whether anything should merge or split. Iterate until I approve.

## 4. Write the tasks

One note per task from `Templates/Task.md` in `Projects/<project>/`, with `project`, `workstream` and `order`, keeping `status: draft`.

## 5. Review

Call the Skill tool with "review-plan" on the workstream.

Done when every task note exists and `review-plan` has set the plan to `todo`.

Next step: `/implement` on the first task by `order`.
