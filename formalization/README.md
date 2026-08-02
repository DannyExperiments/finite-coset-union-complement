# Dual Lean 4 certificates for Kourovka Notebook Problem 21.115

This directory contains two distinct, audited Lean 4/Mathlib certificates of
the headline mixed-coset complement inequality.

## Canonical certificate

`Kourovka21115.lean` is an Aristotle reconstruction ported from Lean 4.28 to
the repository's pinned Lean 4.30 environment by one compatibility-only proof
line. It exports:

```lean
Kourovka.kourovka_21_115
```

## Independent certificate

`Independent/Kourovka21115Independent.lean` is the earlier independently
written Lean 4.30 proof, preserved verbatim under a separate API. It exports:

```lean
Kourovka21115.kourovka_21_115
```

Both theorems quantify over arbitrary finite groups, independently chosen
left/right orientations, different nonnormal subgroups, repetitions, and
`n = 0`. Both prove the division-free cardinal inequality equivalent to the
headline `2^{-n}` complement bound.

## Pins and replay

- Lean: `4.30.0`
- Mathlib: `c5ea00351c28e24afc9f0f84379aa41082b1188f`

With the pinned dependencies available:

```sh
lake build
```

The dual project contains no `sorry`, `admit`, `unsafe`, custom `axiom`, or
custom `opaque`. The reported kernel dependencies are `propext`,
`Classical.choice`, and `Quot.sound`.

## Scope boundary

The certificates prove the original inequality only. They do not formalize
sharpness, translate covers, equality rigidity, compatible-block refinements,
minrank consequences, action corollaries, finite-index extensions, or
profinite extensions. Those remain ordinary, separately audited results.
