# Code style

Conventions for both writing and reviewing code. Tool-agnostic; referenced by `AGENTS.md`
(when generating code) and the `review` skill (when critiquing it).

## Naming

- Identifiers communicate their purpose — clear over clever, but not unwieldy.

## Comments

- Explain *why*, not *what* — the code already says what.
- Don't add comments that just restate the code.
- Keep them to one short line where possible, not multi-line essays.

## Documentation

- When behaviour changes, update the docs that describe it (README, help text) so they don't drift.

## Simplicity

- Prefer the minimal solution; avoid over-engineering for speculative future needs.
- Reuse existing logic instead of duplicating it.
- When a non-essential addition errors, prefer removing it over piling on workarounds.

## Error handling

- Surface errors — don't swallow them in catch-all handlers or silent fallbacks; fail where a caller can still react.

## Consistency

- Match the style, naming, and idioms of the surrounding file over any global default.
