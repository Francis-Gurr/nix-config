---
name: to-workstream
description: Turn the current conversation into a draft workstream in the Obsidian vault, with no new interview.
disable-model-invocation: true
---

Synthesise what this conversation already settled into a workstream note. Do not interview me again; where something is genuinely unsettled, record it under `### Open questions`.

Vault conventions are in the `obsidian-notes` skill. Resolve the project with `obsidian-project`.

## Process

1. **Explore** the repo enough to describe its current state accurately, if you have not already. Use the domain language of `GLOSSARY.md` if the repo has one, and respect any ADRs in the area.
2. **Size it.** A workstream with a sibling of the same purpose is an update to that note, not a new one. Under three tasks' worth of work is a single task: write it from `Templates/Task.md` with `status: draft`, carry this conversation's decisions and open questions into its `## Notes`, call the Skill tool with "review-plan" on it, and stop.
3. **Sketch the seams** the work will be tested at, preferring existing seams and the highest one possible; the fewer, the better. Find existing tests to copy. Check the seams with me.
4. **Write** `Projects/<project>/<name>.md` from `Templates/Workstream.md`, `order` after its siblings. Name it for the outcome, in sentence case. The behaviours are the coverage list `to-tasks` slices from.

Done when the note exists with every prompt filled from the conversation, and I have seen it.

Next step: `/to-tasks`.
