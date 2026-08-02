# Formalization report

## Result

The headline theorem of Kourovka Notebook Problem 21.115 has two distinct
Lean 4/Mathlib certificates in this release candidate.

The canonical Aristotle-derived declaration is
`Kourovka.kourovka_21_115`. The independent pre-Aristotle declaration is
`Kourovka21115.kourovka_21_115`. They use different APIs and proof
decompositions but prove the same full mixed-left/right finite-group cardinal
bound.

## Verification

- Lean `4.30.0`;
- Mathlib `c5ea00351c28e24afc9f0f84379aa41082b1188f`;
- dual-project `lake build`: PASS, 8,478 jobs;
- post-integration direct elaboration of both public source files: PASS;
- no `sorry`, `admit`, `sorryAx`, `constant`, `unsafe`, or `opaque`;
- no custom axioms;
- expected kernel dependencies only: `propext`, `Classical.choice`, and
  `Quot.sound`.

The canonical source was ported from its delivered Lean 4.28 environment by
replacing one compatibility-sensitive simplifier step with the explicit
theorem `Fintype.card_fin`. No definition, theorem statement, hypothesis,
rank argument, support identity, or final inference changed. Public release
normalization also removed one trailing whitespace character. The independent
Lean 4.30 source is preserved separately and unchanged.

## Scope

Both certificates cover the original inequality only. Sharpness and every
extension theorem remain outside the formalized scope.

`FIRST_UNFORMALIZED_INFERENCE`: none in the original headline theorem. The
first deferred claim is the sharpness construction.
