# A rank method for complements of finite coset unions

[![Repository verification](https://github.com/DannyExperiments/finite-coset-union-complement/actions/workflows/verify.yml/badge.svg?branch=main)](https://github.com/DannyExperiments/finite-coset-union-complement/actions/workflows/verify.yml)
[![Lean verification](https://github.com/DannyExperiments/finite-coset-union-complement/actions/workflows/lean.yml/badge.svg?branch=main)](https://github.com/DannyExperiments/finite-coset-union-complement/actions/workflows/lean.yml)
[![PDF build](https://github.com/DannyExperiments/finite-coset-union-complement/actions/workflows/pdf.yml/badge.svg?branch=main)](https://github.com/DannyExperiments/finite-coset-union-complement/actions/workflows/pdf.yml)

[Paper (PDF)](paper/manuscript.pdf) ·
[Complete proof](proof/PROBLEM_AND_PROOF.md) ·
[Lean certificates](formalization/README.md) ·
[Mathematical audit](audits/MATHEMATICAL_AUDIT.md) ·
[Literature audit](audits/LITERATURE_PRIORITY_AUDIT.md) ·
[Release notes](release/RELEASE_NOTES_v1.0.0.md) ·
[Reproduce](REPRODUCIBILITY.md)

This repository presents an affirmative solution of
[Kourovka Notebook Problem 21.115](https://arxiv.org/abs/1401.0300), proposed
by Benjamin Sambale. The authoritative source checked by the project is the
official *Kourovka Notebook*, No. 21, through arXiv v45 (3 July 2026), where
the problem appears on printed page 181 without a solution annotation.

Let \(C_1,\ldots,C_n\) be arbitrary left or right cosets, possibly of
different nonnormal subgroups of a finite group \(G\). If their union is not
all of \(G\), then

\[
\left|G\setminus\bigcup_{i=1}^{n} C_i\right|
\ge \frac{|G|}{2^n}.
\]

The proof constructs rank-at-most-two matrices detecting individual cosets,
takes their Hadamard product, and combines the resulting rank upper bound with
a sparse nonzero-diagonal rank lemma. The constant is sharp.

## Verification and scope

| Item | Status |
|---|---|
| Headline finite-group inequality | Complete proof; targeted AI audits passed |
| Lean certificates | Two distinct audited implementations under Lean 4.30.0 |
| Exact Lean declarations | `Kourovka.kourovka_21_115` and `Kourovka21115.kourovka_21_115` |
| Sharpness and manuscript extensions | Ordinary proofs audited; not Lean-formalized |
| Canonical manuscript | Version 2.2 installed; independent final artifact/scope audit PASS |
| Finite regression verifier | Replayed; supplemental only |
| Human peer or specialist review | Not obtained |
| Literature status | No identical proof located in the documented search; apparently new with moderate confidence |
| Historical priority | Not certified or claimed |

The Lean theorem permits independently chosen left or right orientations,
different subgroups, nonnormal subgroups, repetitions, and \(n=0\). It proves
the division-free cardinal statement

```lean
Fintype.card G ≤ 2 ^ n * (survivors o H a).card
```

under exact nonemptiness of the survivor set.

## Repository map

- [`proof/PROBLEM_AND_PROOF.md`](proof/PROBLEM_AND_PROOF.md) — concise,
  self-contained proof of the headline theorem and sharpness.
- [`paper/`](paper/) — canonical Version 2.2 manuscript, bibliography, PDF,
  build/preflight records, and exact V2.1-to-V2.2 comparison.
- [`formalization/`](formalization/) — pinned Lean 4.30.0/Mathlib source and
  scope report.
- [`audits/`](audits/) — public-safe summaries of the mathematical,
  literature, extension, and Lean audits.
- [`verification/`](verification/) — exact finite sanity checker and recorded
  output. Computation is not used in the universal proof.
- [`REPRODUCIBILITY.md`](REPRODUCIBILITY.md) — local replay instructions.
- [`STATUS.md`](STATUS.md) — exact claim boundaries and remaining release
  tasks.
- [`LICENSE_STATUS.md`](LICENSE_STATUS.md) — current no-license release
  posture.

## Formalization boundary

The two Lean certificates prove the original mixed-coset inequality only. They do
not formalize sharpness, the two-sided translate-cover theorem, equality
rigidity, compatible-block refinements, exact-support minrank consequences,
action corollaries, or finite-index and profinite transfers. An Aristotle
reconstruction supplies the canonical certificate after an audited one-line
Lean 4.30 compatibility port; the earlier independently written Lean 4.30
certificate is preserved under a separate API. Extensions remain
unformalized.

## Literature boundary

The documented literature search, current through 2 August 2026, found no
identical proof or stronger theorem implying the exact arbitrary-finite-group
result. The construction is therefore described only as **apparently new,
with moderate confidence**. Subscription-complete database coverage,
unpublished work, and direct author/editor consultation were not exhausted;
absolute historical priority is not claimed.

The official Notebook PDF is not redistributed here. See
[`PROVENANCE.md`](PROVENANCE.md) for the authoritative source and exact
bibliographic metadata.

The problem was identified for investigation through
[UnsolvedMath v1.2.0](https://huggingface.co/datasets/ulamai/UnsolvedMath),
curated by UnsolvedMath Contributors and released under
[CC BY 4.0](https://creativecommons.org/licenses/by/4.0/). UnsolvedMath
provided discovery and indexing only; the official Notebook, not the dataset,
is the authority for the statement and status used here.

## Authorship and AI disclosure

DannyExperiments is the human curator and conventional manuscript author. The
ordinary-language proof was generated with OpenAI GPT-5.6 Pro. Aristotle
produced one complete Lean reconstruction; OpenAI Codex produced the other
Lean certificate, audited and ported the Aristotle reconstruction, coordinated
audit and provenance work, and prepared the repository infrastructure. No AI
system is listed as an author. See [`AI_DISCLOSURE.md`](AI_DISCLOSURE.md).

## Release boundary

The accepted Version 2.2 manuscript is installed and independently audited.
The repository records a solver-authored proposed solution, not journal
acceptance or human peer review. Human specialist review was not obtained,
and absolute historical priority is not claimed.
