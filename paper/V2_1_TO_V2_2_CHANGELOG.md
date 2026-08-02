# Version 2.1 to Version 2.2 changelog

## Authorized manuscript change

Version 2.2 makes exactly one manuscript-content change. Immediately before
`\printbibliography`, it inserts one unnumbered section titled
`Verification and provenance`. The section records the human and AI roles,
limits both audited Lean 4.30 certificates to the headline mixed-left/right
finite-group complement inequality, states that no strengthening is claimed
formally verified, distinguishes AI-generated audits from human peer review,
and preserves the qualified literature-status language.

No other manuscript text was changed. In particular, Version 2.2 changes no
title, abstract, theorem-like statement, hypothesis, conclusion, equation,
proof, example, citation, bibliography entry, formalization-status paragraph,
or cross-reference repair. It still contains no `\author{}` command.

## Exact source reconciliation

- Version 2.1 manuscript SHA-256:
  `19ef16e63b4ad85a387872909d93459fa006171fdaa55d0db7ceb17a01c13f1a`.
- Version 2.2 manuscript SHA-256:
  `192c233a864659aa8b639add41246d838298c1e79ad975bfcd340160265e5745`.
- Removing only the exact inserted section from Version 2.2 reconstructs the
  Version 2.1 source byte-for-byte: `PASS`.
- Theorem-like statement environments: unchanged, 18/18.
- Extracted mathematical spans: unchanged, 389/389.
- Labels: unchanged and unique, 18/18.
- Citation signatures under the Version 2.1 audit convention: unchanged,
  19/19.
- Bibliography: unchanged byte-for-byte, 21/21 entries.
- `verify_small_groups.py`: unchanged byte-for-byte.

The executable comparison, machine record, human-readable report, and unified
diff are included in this package.

## Build and validation

A clean deterministic pdfLaTeX/Biber build produced a nine-page A4 PDF.
The final pass has zero undefined citations or references, zero multiply
defined labels, zero LaTeX/package/Biber warnings, and zero overfull or
underfull boxes. A second clean build reproduced the packaged PDF byte-for-byte.
Ghostscript, Poppler, PyMuPDF preflight, dual-engine rendering, extracted-text
checks, and page-by-page visual inspection all passed. Pages 1--7 are
pixel-identical to Version 2.1 at 200 DPI; only pages 8--9 change, where the
new section is inserted and the bibliography consequently reflows.

The exact finite verifier was replayed and its output is byte-identical to the
inherited verifier log, ending with `all_assertions=PASS`.

## Preservation boundary

The supplied Version 2.1 archive remains untouched and retains outer SHA-256
`88429e9a89c7e56285ac9eae575e8ae5d036646322071632d8b9ef7518d5e109`.
No repository, visibility, submission, publication, DOI, tagging, or external
service operation was performed.
