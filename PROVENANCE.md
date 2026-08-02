# Provenance

## Problem

Kourovka Notebook Problem 21.115 is attributed to Benjamin Sambale. Its first
official appearance located by the project was in:

E. I. Khukhro and V. D. Mazurov, editors, *Unsolved Problems in Group Theory:
The Kourovka Notebook*, No. 21, Novosibirsk, 2026, Problem 21.115, printed
page 178 in arXiv:1401.0300v39, dated 8 January 2026.

The latest official version checked during the project was
[arXiv:1401.0300v45](https://arxiv.org/abs/1401.0300), dated 3 July 2026,
where the problem appeared on printed page 181 without a solution annotation.
The official PDF was inspected in the private evidence archive but is not
redistributed in this public-facing tree.

## Discovery route

The project identified Problem 21.115 for investigation through
[UnsolvedMath v1.2.0](https://huggingface.co/datasets/ulamai/UnsolvedMath), a
dataset curated by UnsolvedMath Contributors and released under
[CC BY 4.0](https://creativecommons.org/licenses/by/4.0/). The dataset supplied
discovery and indexing, not the proof. Its problem record was not used as the
authority for the theorem statement or current status; those were checked
against the official Notebook source above.

## Proof and manuscript chain

The private evidence archive preserves the original proof return, hostile
mathematical audits, literature searches, manuscript packages, exact hashes,
and replay records. Those private materials are intentionally not duplicated
here. This repository exposes the canonical proof, formal source, public-safe
audit summaries, verifier, and release checks needed to inspect the result.

The post-literature Version 2 source archive is preserved privately with
SHA-256:

```text
c15e262c3d5051019daf736816cb96925eceef3ec6e1669a28f239d28d5fcc6c
```

It remains immutable evidence. The accepted Version 2.1 archive, which fixes
the reference and formalization defects, has SHA-256
`88429e9a89c7e56285ac9eae575e8ae5d036646322071632d8b9ef7518d5e109`.
It too remains immutable private evidence. The accepted provenance-only
Version 2.2 archive has SHA-256
`01489861a81b466ee614bd0a5c82a79247009d9e88e0a0a66c83435f691a2b05`.
Its canonical PDF has SHA-256
`6c82c218005037974992d9704324df8e17ea9df19e9b5cc79675be0be6cf96e9`.
Version 2.2 adds the repository's adopted authorship and AI-contribution
disclosure without mathematical change and is installed under `paper/`.

## Lean certificates

The earlier independently replayed Lean 4.30 archive has SHA-256:

```text
f0c778d5d99162c891c0901d70a1ba0f9de9da814a52e3ba4c02c4ac790f4156
```

It exports `Kourovka21115.kourovka_21_115`. A distinct Aristotle
reconstruction was delivered under Lean 4.28 and ported to the same Lean 4.30
environment by one compatibility-only proof line. The port exports
`Kourovka.kourovka_21_115`. Both build with Mathlib revision
`c5ea00351c28e24afc9f0f84379aa41082b1188f`. The public repository includes
both exact public-safe sources and reports rather than the raw external
wrapper or account-level receipt.

## Contribution statement

- **Benjamin Sambale:** proposer of Problem 21.115.
- **OpenAI GPT-5.6 Pro:** generated the ordinary-language proof and initial
  manuscript.
- **Aristotle:** produced one complete Lean reconstruction.
- **OpenAI Codex:** produced the independent Lean 4 formalization, audited and
  ported the Aristotle reconstruction, coordinated audits and provenance, and
  prepared repository infrastructure.
- **DannyExperiments:** initiated and directed the investigation, selected
  validation requirements, curated and validated the artifacts, and is the
  human curator, conventional manuscript author, repository owner, and
  intended publisher of the project.

AI audits are not human peer review. Human specialist review was not obtained.
Absolute historical priority is not certified or claimed.
