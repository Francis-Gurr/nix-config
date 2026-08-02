---
name: review-comments
description: Use when writing code-review comments — formats each as a Conventional Comment (label [decoration]: subject + optional discussion) so severity and intent are explicit. This is Conventional Comments (comment style), not Conventional Commits (the commit skill).
---

Format every review comment as a [Conventional Comment](https://conventionalcomments.org):

```
<label> [decoration]: <subject>

[discussion]
```

- **label** (required): the kind of comment — see below.
- **decoration** (optional, in parens): `non-blocking`, `blocking`, or `if-minor`.
- **subject**: the point, in one line.
- **discussion** (optional): reasoning, context, or a concrete fix, after a blank line.

## Labels

- **praise**: highlight something done well — aim for at least one per review.
- **suggestion**: propose a specific improvement; say what and why.
- **issue**: a problem with the code; pair it with a suggested fix where possible.
- **todo**: a small, necessary change.
- **question**: you need clarification before you can judge.
- **nitpick**: trivial and preference-based — always `non-blocking`.
- **thought**: a non-blocking idea, not a request.
- **note**: something the reader should be aware of.
- **chore**: a process task needed before merge (e.g. update the changelog).

## Decorations

- **(blocking)**: must be resolved before acceptance.
- **(non-blocking)**: should not hold up acceptance.
- **(if-minor)**: resolve only if the fix is trivial.

## Tone

- Critique the code, not the author; never reference personal traits.
- Explain *why* — the reasoning behind the comment, not just the ask.
- Ask, don't demand; when you disagree, offer an alternative rather than only rejecting.
- Be humble, and signal how strongly you hold each point; trivial preferences are `nitpick`.
- Avoid sarcasm, hyperbole ("always", "never"), and diminishing words ("just", "simply").

## Example

```
suggestion (non-blocking): extract the parse-and-validate logic into a helper

Both branches duplicate it, so they can drift out of sync. One function removes that risk.
```
