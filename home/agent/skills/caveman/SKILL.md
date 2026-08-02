---
name: caveman
description: Use when writing or editing any prose I will read later — Obsidian notes, skills, READMEs, docs, commit bodies, PR descriptions. Cuts filler and hedging while keeping full sentences. Not for chat replies, not for code.
---

Write tight. Say the thing once, then stop.

The register is "caveman lite": drop filler and hedging, but keep articles and full sentences. The
result reads as normal professional prose with the padding gone — not as fragments. Adapted from
[juliusbrussee/caveman](https://github.com/juliusbrussee/caveman).

## Cut

- **Filler**: just, really, basically, actually, simply, essentially, generally, quite.
- **Hedging**: "it might be worth", "you could consider", "it would probably be good to", "I think".
  If it is worth doing, say so; if it is a judgement call, say that instead.
- **Pleasantries**: "of course", "happy to", "great question".
- **Connective padding**: however, furthermore, additionally, in addition, that said. Most sentences
  do not need a hinge word.
- **Instruction padding**: "you should", "make sure to", "remember to", "it is important to". State
  the action.
- **Long forms**: "in order to" → "to", "the reason is because" → "because", "at this point in time"
  → "now", "utilize" → "use", "extensive" → "big".
- **Repetition**: merge bullets that make the same point twice. Keep one example where several show
  the same pattern.
- **Restating the obvious**: anything the structure, frontmatter, links or filename already say.

## Keep

Articles and full sentences — this is lite, not telegraphese. Also keep whatever carries meaning:

- The reason a decision was made, especially a rejected alternative.
- Anything counter-intuitive, or that cost time to discover.
- Concrete specifics: names, paths, numbers, exact settings.

**Never touch**: code blocks, inline code, URLs, file paths, commands, error strings, technical
terms, proper nouns, dates, version numbers, YAML frontmatter. Compress prose around them.

**Never invent abbreviations.** `cfg`, `impl`, `req` tokenize the same as the full word — no saving,
worse reading. Standard ones (API, DB, HTTP, CLI) are fine.

**Never compress into ambiguity.** If cutting a conjunction makes the order of steps unclear, or a
dropped clause makes two readings possible, keep the words. Brevity that costs a re-read has lost.

## Scope

Applies to written artefacts: notes, skills, docs, READMEs, commit bodies, PR descriptions.

Does not apply to chat replies, code, or code comments. Prose *inside* a code block is part of the
block — leave it.

Length is not the target. A note that needs ten lines gets ten lines. Cutting substance to hit a
word count is the failure this guards against, not the goal.
