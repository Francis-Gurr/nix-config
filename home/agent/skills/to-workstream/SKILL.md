---
name: to-workstream
description: Turn the current conversation into a draft workstream in the Obsidian vault, with no new interview.
disable-model-invocation: true
---

Synthesise what this conversation already settled into a workstream note. Do not interview me again; where something is genuinely unsettled, record it as an open question in `## Notes`.

Vault conventions are in the `obsidian-notes` skill. Resolve the project with `obsidian-project`.

## Process

1. **Explore** the repo enough to describe its current state accurately, if you have not already. Use the domain language of `GLOSSARY.md` if the repo has one, and respect any ADRs in the area.
2. **Size it.** Under three tasks' worth of work is a single task: write it from `Templates/Task.md` instead, in the same shape, and stop. A workstream with a sibling of the same purpose is an update to that note, not a new one.
3. **Sketch the seams** the work will be tested at, preferring existing seams and the highest one possible; the fewer, the better. Check them with me.
4. **Write** `Projects/<project>/<name>.md` from `Templates/Workstream.md`, `status: draft`, `order` after its siblings. Name it for the outcome, in sentence case.

Done when the note exists with every section of the template below filled from the conversation, and I have seen it.

## Template

`## Summary` carries the spec; `## Notes` carries everything else.

```markdown
## Summary

<The problem, from my perspective, in one or two sentences.>

<The solution, from my perspective: what is true once this is done.>

**Seams:** <where the work is tested>.

**Out of scope:** <what this deliberately leaves out>.

## Tasks

<the base block from the template, unchanged>

## Notes

### Decisions

- **<decision>.** <why, and the alternative rejected>.

### Open questions

- <anything unsettled, or omit the heading>
```

Leave file paths and code snippets out of the summary; they go stale. The exception is a prototype's snippet that states a decision more precisely than prose (a state machine, a schema, a type): put it under the decision it belongs to, trimmed to the decision-rich part.

Next step: `/to-tasks`.
