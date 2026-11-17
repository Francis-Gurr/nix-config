---
name: review-comments
description: Use when writing code-review comments — Conventional Comments format (label (decoration): subject).
---

Format every review comment as a [Conventional Comment](https://conventionalcomments.org), with
these house rules:

- Include at least one `praise` per review.
- `nitpick` is always `(non-blocking)`.
- Each `issue` carries a suggested fix where possible.
- Signal how strongly you hold each point; trivial preferences are `nitpick`.

```
suggestion (non-blocking): extract the parse-and-validate logic into a helper

Both branches duplicate it, so they can drift out of sync. One function removes that risk.
```
