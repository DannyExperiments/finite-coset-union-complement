# Formalization report

## Result

`Kourovka21115.kourovka_21_115` is a complete Lean 4/Mathlib certificate of
the headline statement of Kourovka Notebook Problem 21.115.

It quantifies over:

- an arbitrary finite group `G`;
- an arbitrary natural number `n`;
- `n` independently selected left or right orientations;
- `n` arbitrary subgroups, without normality or equality assumptions;
- `n` arbitrary coset representatives.

If the exact finite survivor set is nonempty, Lean proves

```lean
Fintype.card G ≤ 2 ^ n * (survivors o H a).card
```

No finite enumeration is used in this proof.

## Verification

- Lean: `4.30.0`
- Mathlib: `c5ea00351c28e24afc9f0f84379aa41082b1188f`
- `lake build`: PASS, 8,476 jobs
- source scan for `sorry`, `admit`, and custom `axiom`: no matches
- `#print axioms`: `propext`, `Classical.choice`, `Quot.sound`
- custom axioms: none

## Scope

This certificate proves the original inequality.  It deliberately does not
yet formalize sharpness, two-sided translate covers, equality rigidity, or
the grouped-coset refinement.  Those claims belong to the separately audited
extension lane.

## First unformalized inference

None in the original headline theorem.  The first deferred statement is the
sharpness construction, not a missing step in the proof of the bound.
