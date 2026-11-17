---
name: retro
description: "Conduct a retrospective on a finished task or workstream from the Obsidian vault."
disable-model-invocation: true
---

The user has asked for a **retrospective**: suggest improvements to the coding agent's **environment** so future runs go better, and record them in the vault. Vault conventions are in the `obsidian-notes` skill; resolve the task or workstream with `obsidian-project`.

Two modes, chosen by what the user names (default: the task this session worked on):

- **Task retro**: one finished task.
- **Workstream retro**: a workstream whose tasks are all `done`.

## Task retro

1. Call the Skill tool with `writing-for-agents` for the writing style guide.
2. Read the primary sources: this session, or the session log the user points at, plus the task note. With no task note, create a `done` one for the work per `obsidian-project`.
3. Look for candidates in the categories below.
4. Write them under `### Retro` in the task's `## Notes`, most severe first, each with its category and a concrete fix, and show the user.
5. A task with no workstream records its unapplied fixes in `Todos.md` (see [Todos](#todos)), then is archived per `obsidian-project`. Done when every candidate is written, shown, and either applied or in `Todos.md`.

## Workstream retro

1. Read every task's `### Retro` and the workstream's `## Notes`.
2. Collate them into `### Retro` in the workstream's `## Notes`: merge duplicates, rank by severity, and name the patterns that recur across tasks.
3. Record the proposed changes in `Todos.md` (see [Todos](#todos)), linking back to the workstream.
4. Show the user the summary, then archive the workstream and its tasks per `obsidian-project`. Done when the notes sit in `Archive/Projects/<project>/`.

## Todos

One line per proposed change to a skill, `AGENTS.md`, `CODING_STANDARDS.md`, a check or tooling, linking back to the note it came from. A change applied in this session needs no line.

Search `Todos.md` and the vault for each finding first. A repeat finding adds this note as another backlink on its existing line, rewording the line if the finding has moved on; it never gets a second line. An earlier task or retro may already hold a fix or workaround: use it rather than proposing a new one.

## Categories

- **Navigation**: how easy was it for the agent to find the right files? Are there hidden dependencies between files? Would a **navigation pointer** make it easier? _Use when_ the session took a long time to find a piece of information.
- **Automated checks**: are there automated checks that could catch errors the agent made? Linting, typing, tests, filesystem linters? Read the repo's own check command first (its `package.json`/build-tool `lint`/`check` scripts, its CI workflow), so a check that already exists but sits unwired or silently broken is the finding, not a reinvention. A repo with no **guardrail** (no pre-commit hook and no CI job running its lint/typecheck/test command) is itself a finding: an un-linted repo is a standing missed opportunity, not a neutral default. _Use when_ the agent made a mistake an automated check could have caught, or the repo has no guardrail at all.
- **Coding standards**: should the **reviewer agent** be given a new rule to enforce? Should an existing rule be removed or clarified? Classify the violation first: a **mechanical** one (a fixed syntactic pattern, a banned API, an import shape, a file-location rule) gets a deterministic check, full stop: a custom rule in the repo's own linter, a new pre-commit hook, or a new CI job, whichever the repo's language and existing guardrail make cheapest. Default to building the check over writing the rule. Reserve `CODING_STANDARDS.md` for genuine **judgement calls** (cross-file consistency, "matches the surrounding style," anything no guardrail could ever substitute for). _Use when_ the reviewer agent failed to catch a mistake.
- **Global AGENTS.md**: are there any steering instructions that should be moved to coding standards (or automated checks) instead? _Use when_ the AGENTS.md file is particularly large - in the repo OR the user's global scope.
- **Skills**: did a skill steer the agent wrong, leave a gap, or go unused when it should have fired? Is its description weak, or a step missing a completion criterion? _Use when_ the agent improvised where a skill should have guided it.
- **Tool economy**: did the agent make expensive tool calls that could be streamlined? Is there any custom tooling (CLI's, MCP's) that is particularly token-inefficient? _Use when_ the agent made an expensive tool call.
- **No-ops**: look for instructions in steering files that don't modify the agent's behaviour. _Use when_ the steering files are large and unwieldy.
- **Information access**: look for opportunities to increase the agent's access to information. Teeing dev server logs, readonly access to third-party services. _Use when_ a crucial piece of information was not available to the agent.

## Reference

### Implementation vs review

All work goes through implementation and review. The implementation agent carries the most **context pressure**: exploration, writing code, debugging. The review agent receives a diff and carries the least, so `code-review` is where coding standards are enforced; a mechanical rule still belongs in a deterministic check.

### Where a fix goes

- `AGENTS.md` (global at `~/dev/nix-config/home/agent/AGENTS.md`, or a repo's own): loaded into every session, so use it sparingly, mostly for **navigation pointers**.
- `CODING_STANDARDS.md` (global, beside `AGENTS.md`, or a repo's own): judgement-call rules, loaded during implementation and checked by `code-review`.
- Docs: reference files reached by pointers. Look for existing docs before writing new ones.
- Skills: for workflows and user-invoked commands. Follow `writing-for-agents`. Global skills live in `~/dev/nix-config/home/agent/skills/`.
