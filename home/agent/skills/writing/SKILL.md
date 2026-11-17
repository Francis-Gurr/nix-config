---
name: writing
description: Tight prose in British English. Use when writing or editing prose a person reads later (notes, docs, READMEs, commit messages, PR bodies), or when deslopping a draft. For skills and AGENTS.md, use writing-for-agents as well.
---

Write **tight**: say each thing once, in full sentences with articles, then stop. The result reads as plain professional prose with the padding gone. Length is not the target: a note that needs ten lines gets ten lines, and cutting substance to save words is the failure this guards against.

## Keep

- The reason for a decision, especially a rejected alternative.
- Anything counter-intuitive, or that cost time to discover.
- Concrete specifics: names, paths, numbers, versions, dates, exact settings.
- Code, inline code, URLs, commands, error strings, proper nouns and frontmatter, verbatim. Tighten the prose around them.
- Any word whose removal makes the order or meaning ambiguous. Brevity that costs a re-read has lost.

## Cut

Each pattern pairs with what to write instead.

- **Filler** (just, really, basically, actually, simply, quite) → the bare verb or noun.
- **Hedging** ("it might be worth", "you could consider", "I think") → the recommendation, or "this is a judgement call" when it is one.
- **Pleasantries** ("of course", "happy to", "great question") → the answer.
- **Hinge words** (however, furthermore, additionally) → no hinge; most sentences need none.
- **Instruction padding** ("you should", "make sure to", "it is important to") → the imperative.
- **Long forms** ("in order to", "utilise", "the reason is because") → to, use, because.
- **Repetition and restatement** of what the structure, filename or links already say → delete it.

## Slop

The tells of generated text. On a match, decide what the sentence asserts and state that directly; rewording the pattern keeps the slop.

- **Negative parallelism**: "not X, but Y", "it's not just X, it's Y". → State Y. Keep a contrast only when someone actually believes X.
- **Puffery**: pivotal, crucial, seamless, robust, delve, tapestry, landscape, "plays a vital role". → The concrete effect, or nothing.
- **Padding triads**: a third item added for rhythm. → Keep the items that carry weight.
- **False ranges**: "from X to Y" with no real span between. → Name the things.
- **Em-dashes**: rewrite with a comma, colon, full stop, parentheses or conjunction, whichever the sentence wants. Never swap the character blindly.
- **Reflexive balance**: "that said", "it's worth noting", a counterpoint nobody raised. → Drop it unless the caveat changes a decision.
- **Vague attribution**: "studies show", "many teams", "experts agree". → The source, or own the claim.
- **Stock skeleton**: a throat-clearing opener, a summary that repeats the body, a sign-off inviting questions. → Start at the point; end when it is made.
- **Formatting tells**: scattered bold, emoji headers, headings over one paragraph, bullets that are really sentences. → Bold only the one term a reader scans for; prose where the thought runs on.
- **Uniform cadence**: runs of sentences or paragraphs of equal length and shape. → Vary them as the content demands.

## British English

Use British spelling: -ise and -isation, -our, -re, -ogue, travelled and modelling, licence (noun) and license (verb), practice (noun) and practise (verb). Leave code, identifiers, quotations, product names and command output as written.

## Editing a draft

1. Read the whole draft and name its point, audience and register.
2. Rewrite every sentence that matches **Cut** or **Slop**, by meaning.
3. Rescan the rewritten text; rewrites breed new patterns. Repeat up to four passes.
4. Check facts survived: every specific in the original is still present and still true. Flag an error you notice instead of silently fixing it.

Done when a full pass finds no match and nothing from **Keep** was lost.
