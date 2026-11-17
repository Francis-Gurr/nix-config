---
name: research
description: Investigate a question against high-trust primary sources and capture the cited findings in the Obsidian vault. Use when the user wants a topic researched, docs or API facts gathered, or reading legwork delegated to a background agent.
---

Spin up a **background agent** to do the research, so you keep working while it reads. Start it with a fresh context window. If you are already a subagent, do the research yourself; never spawn another agent for it.

Its job:

1. Investigate the question against **primary sources** (official docs, source code, specs, first-party APIs), not a secondary write-up of them. Follow every claim back to the source that owns it.
2. Write the findings to a single Markdown file, citing each claim's source.
3. Save it to the Obsidian vault (conventions in the `obsidian-notes` skill): under `## Notes` of the task that asked, if it is short; otherwise as a `type: note` in `Resources/` (create the folder if absent), linked from that task. Say where it went.
