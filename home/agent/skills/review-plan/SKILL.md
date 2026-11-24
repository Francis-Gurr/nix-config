---
name: review-plan
description: Review gate for a draft workstream or task in the Obsidian vault, checking it against the repo before it becomes todo. Use on a draft plan before work starts.
---

No plan becomes `todo` without this gate. The plan is the workstream or task I name, else the `draft` one this conversation produced: a workstream with every task linked to it, or a single task. Vault conventions are in the `obsidian-notes` skill.

## 1. Check the notes yourself

- Every note follows the `obsidian-notes` conventions and its template, with no `%%` prompt left.
- For a workstream: every behaviour is delivered by at least one task, and no task goes beyond the behaviours or into `Out of scope`.
- Every task's **Done when** names the seam or command that decides it.

## 2. Check against reality

Start a `general-purpose` subagent with a fresh context window, giving it every note in the plan and the repo it targets. It leaves the repo's working tree untouched and reports each claim as verified or unverified: one checked only against source is unverified. It checks:

- Do the named files, functions and paths exist?
- Does every named command run here (`command -v`, or its `--help` for a subcommand or flag)?
- Are the steps executable in the order given, and does each one state a checkable outcome?
- Do any steps contradict each other?
- What does the plan assume without saying?
- Would each done-when line catch a failure, or is it look-and-see?
- In a Nix repo: do the plan's snippets build? Apply them in a `git worktree` under a temp dir (`git add` new files, or the flake cannot see them), build every flake output they touch, and run the repo's hooks (nixfmt, statix, deadnix); then remove the worktree.

## 3. Apply and record

Apply the findings, and record them under `### Review` in the `## Notes` of the workstream, or of the task when it stands alone. Give each what was done about it, including those deliberately not acted on and why. Keep to findings that changed something or that someone would hit again.

## 4. Report

Report to me. Set the workstream and its tasks to `todo` once every finding that changes a step, its order or its verification is resolved.

Done when the review is recorded and every note in the plan is `todo`.
