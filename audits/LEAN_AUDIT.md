# Independent dual-certificate Lean audit summary

Date frozen: 2026-08-02

```text
VERDICT: PASS
FORMALLY_VERIFIED_CORE: YES
DISTINCT_CERTIFICATES: TWO
CUSTOM_AXIOMS: NONE
SORRY_OR_ADMIT: NONE
EXTENSIONS_FORMALIZED: NO
```

The canonical certificate is the audited one-line Lean 4.30 port of an
Aristotle reconstruction and exports `Kourovka.kourovka_21_115`. Its source
SHA-256 is
`41f727e4b837c548945e774090d449145fde90a6f07cf29a4e30d33909517584`.

The independent pre-Aristotle Lean 4.30 certificate exports
`Kourovka21115.kourovka_21_115`. Its source SHA-256 is
`61b7e67971d9a80ce579c6b4717076d07148a8f1d15711a653e59e7cc8a7a2b6`.

Both build under Lean 4.30.0 and Mathlib revision
`c5ea00351c28e24afc9f0f84379aa41082b1188f`. The dual project reports a
successful 8,478-job build and kernel dependencies only on `propext`,
`Classical.choice`, and `Quot.sound`.

The two implementations use different APIs and proof decompositions. Each
quantifies over arbitrary finite groups, independently chosen left/right
orientations, arbitrary different nonnormal subgroups and representatives,
repetitions, and `n = 0`.

Neither certificate formalizes sharpness or any manuscript extension.
The raw external wrapper and account-level submission receipt remain in the
private evidence warehouse and are not part of this public summary.
