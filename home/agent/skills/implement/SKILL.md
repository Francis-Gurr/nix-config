---
name: implement
description: "Implement a task from the Obsidian vault, then take it through review to done."
disable-model-invocation: true
---

Implement one vault task. Resolve it with the `obsidian-project` skill: the task the user names, else the `in-progress` task for this repo. State its title, set it `in-progress`, and read its `## Summary`, `## Steps`, `## Notes` and its workstream's `## Notes`. If the reference is ambiguous, ask.

A task is **done** only when it is reviewed, fixed, committed and pushed. Work these stages in order; each ends where the next begins.

1. **Build.** Work the `## Steps` in order, calling the Skill tool with "tdd" at the seams named by the task's **Done when** and its workstream's **Testing**. Run typechecking and single test files regularly, and the full suite once at the end.
2. **Agent review.** Call the Skill tool with "code-review". Fix every hard violation and every Spec finding; settle each judgement call by fixing it or noting why not. Done when the fixes are in and the full suite passes.
3. **Human review and QA.** Hand the work to the user: what changed, how to test it, and which review findings you left and why. Wait for their findings.
4. **Address findings.** Fix what the user raised, rerun the suite, and return to stage 3 until the user is satisfied.
5. **Commit.** Stage the changes and commit per the `commit` skill, pausing for the user's approval; then push.
6. **Close.** Once pushed, tick the `## Steps` and set the task `done`; a tick asserts the work is on the remote. Record anything learned that contradicts the plan in the task's `## Notes`. Tell the user to run `/retro` for the task.
