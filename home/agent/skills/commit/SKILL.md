---
name: commit
description: Use when creating a git commit or writing a commit message.
---

## Convention

[Conventional Commits](https://www.conventionalcommits.org), subject line only (no body, no footer),
with a leading [gitmoji](https://gitmoji.dev) matching the type:

```
<emoji> <type>(<optional scope>): <subject>
```

- subject: imperative mood, lower-case, no trailing period
- `!` after the type/scope marks a breaking change (e.g. `✨ feat!:`)

```
✨ feat(auth): add password reset flow
🐛 fix: handle empty response from picker
♻️ refactor(snacks): extract git status helper
```

### commitlint is the source of truth

Repos with a commitlint config enforce this with a commit-msg hook. Read the rules from the resolved
config:

- Rules + the gitmoji for each type: `npx commitlint --print-config json`
  (emoji map under `prompt.questions.type.enum.<type>.emoji`, types under `type-enum`)
- Validate before committing: `printf '%s' "<message>" | npx commitlint` (exit 0 = valid)
- If a commit is rejected, fix only the rule named in brackets (the `[type-emoji]` error names the
  exact emoji), then retry. The hook always runs: `--no-verify` is off-limits.

If a repo has no commitlint, the canonical mapping lives in `~/dev/nix-config/commitlint.config.mjs`.

## Creating a commit

1. If nothing is staged, stage the relevant changes yourself.
2. If the changes are unrelated, stop and propose splitting them into separate commits.
3. Write the message and validate it against commitlint.
4. **Stop and show me the staged files and the proposed message.** Committing is the point past
   which review costs a rewrite. Skip this pause in my Obsidian vault (`~/notes/personal`).
5. Once I approve, commit and push in one go, with no second confirmation for the push.
