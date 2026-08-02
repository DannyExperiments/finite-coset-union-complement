# Status

Frozen through: 2026-08-02

```text
PUBLIC_RELEASE_CANDIDATE_AI_AUDITED_DUAL_LEAN_CORE_VERIFIED_V2_2_MANUSCRIPT_PASS
```

This repository presents a complete proof of Kourovka Notebook Problem
21.115. The proof and stated manuscript extensions passed targeted
AI-assisted mathematical audits, and two distinct implementations of the
headline theorem were audited under Lean 4.30.0. Human specialist review was not obtained. Extension
theorems are not formally verified. Historical priority is not certified.

## Evidence ledger

- **Core proof:** complete symbolic proof with no finite-search dependency.
- **Mathematical audit:** PASS; no invalid step or counterexample identified.
- **Lean:** PASS for `Kourovka.kourovka_21_115` and the independent
  `Kourovka21115.kourovka_21_115`; no `sorry`, `admit`, `unsafe`, custom
  `axiom`, or custom `opaque` declaration.
- **Sharpness:** proved in ordinary mathematics; not covered by the Lean
  certificate.
- **Extensions:** targeted mathematical audits passed; formalization deferred.
- **Literature:** no identical proof located in the recorded search; novelty
  classification remains apparently new, moderate confidence.
- **Human review:** not obtained and not represented as obtained.
- **Aristotle:** complete independent reconstruction, banked through a
  checksum-clean source and audited one-line Lean 4.30 compatibility port.

## Remaining release tasks

1. Freeze the exact release commit and release assets.
2. Publish only after an explicit visibility decision by the repository owner.

Human specialist review and absolute historical-priority certification are
explicit nonclaims, not prerequisites to public timestamping.

## Excluded from this repository surface

The private evidence archive retains raw model returns, task receipts, old
solver ZIPs, handoffs, duplicated package trees, live Aristotle artifacts,
render contact sheets, and the third-party Notebook PDF. Their exclusion is
intentional and does not change the preserved private provenance record.
