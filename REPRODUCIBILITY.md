# Reproducibility

The same checks are replayed on GitHub Actions. The root verification workflow
runs the public integrity and finite-regression gate; the Lean workflow builds
both pinned certificates and invokes Lean's bundled `leanchecker`; and the PDF
workflow rebuilds the manuscript from its TeX and bibliography. Workflow logs
are linked by the status badges at the top of the repository README.

## Public integrity check

From the repository root, run:

```sh
./scripts/verify.sh
```

The script verifies the public checksum ledger, rejects private paths and
credential-like strings, checks the exact status disclosures, scans the Lean
source for proof holes or unsafe/custom declarations, runs the finite
regression verifier, and compares its output with the recorded log.

This establishes artifact integrity and reproducibility only. It is not a
substitute for the mathematical proof or Lean kernel checking.

## Lean replay

The formalization pins Lean 4.30.0 and exact Mathlib dependencies. With those
dependencies available:

```sh
cd formalization
lake build
```

The expected declarations are `Kourovka.kourovka_21_115` and
`Kourovka21115.kourovka_21_115`. See
[`formalization/FORMALIZATION_REPORT.md`](formalization/FORMALIZATION_REPORT.md)
and [`audits/LEAN_AUDIT.md`](audits/LEAN_AUDIT.md).

The repository does not vendor Mathlib or compiled `.lake` products. A clean
machine therefore needs the pinned dependencies or a pre-provisioned matching
checkout.

## Manuscript replay

The final public paper is the provenance-only Version 2.2 reconciliation. Its
TeX, bibliography, PDF, build record, preflight, and exact source comparison
are installed under `paper/`. The accepted package records clean compilation,
reference/citation scans, PDF text checks, dual-engine rendering, page-by-page
visual inspection, and a byte-identical deterministic rebuild.

## Finite verifier

The dependency-free Python verifier uses exact arithmetic and explicit small
group tables:

```sh
python3 verification/verify_small_groups.py
```

Its finite output is corroborative; the universal theorem is proved
symbolically and formally rather than by enumeration.
