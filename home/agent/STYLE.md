# Code style

## Comments

- Comments explain *why*, in one short line.

## Documentation

- When behaviour changes, update the docs that describe it (README, help text) in the same change.

## Simplicity

- Write the minimal solution for today's need.
- Reuse existing logic instead of duplicating it.
- When a non-essential addition errors, remove it rather than piling on workarounds.

## Error handling

- Let errors surface where a caller can still react; catch only what you handle.

## Consistency

- Match the style, naming and idioms of the surrounding file over any global default.
