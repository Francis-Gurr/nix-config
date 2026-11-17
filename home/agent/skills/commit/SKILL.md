---
name: commit
description: Commit message phrasing. Use when writing a commit message or creating a commit.
---

Format is [Conventional Commits](https://www.conventionalcommits.org) with a leading [gitmoji](https://gitmoji.dev), subject line only: no body and no trailers, `Co-Authored-By` included.

```
✨ feat(auth): add password reset flow
🐛 fix: handle empty response from picker
```

- Imperative mood, lower-case, no full stop: "add", not "added" or "adds".
- Name the change the reader will look for, in the project's own words. Phrase it per the `writing` skill.
- One logical change per commit. If staged changes are unrelated, propose splitting them.

The repo's commitlint owns the rules, including the emoji for each type. Validate before committing with `printf '%s' "<message>" | node_modules/.bin/commitlint`; where no repo config exists, run that from `~/dev/nix-config`. Fix only the rule named in brackets, then retry. Run `git commit` through `direnv exec . git commit` when the hook needs tools from the repo's dev shell (nix-config's needs `pnpm`). `--no-verify` is off-limits.
