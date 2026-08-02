# Version 2.2 package validation

## Baseline integrity

- Supplied Version 2.1 outer SHA-256: `PASS`:
  `88429e9a89c7e56285ac9eae575e8ae5d036646322071632d8b9ef7518d5e109`.
- Supplied Version 2.1 ZIP integrity: `PASS`.
- Supplied Version 2.1 complete internal `SHA256SUMS.txt`: `PASS`.
- Extracted Version 2.1 tree was made read-only before the Version 2.2 copy was
  created.
- Version 2.1 archive mutation: `NONE`.

## Exact manuscript-source reconciliation

- The only manuscript-content change is one inserted unnumbered
  `Verification and provenance` section immediately before the bibliography.
- Removing that exact insertion reconstructs Version 2.1 byte-for-byte: `PASS`.
- Baseline manuscript SHA-256:
  `19ef16e63b4ad85a387872909d93459fa006171fdaa55d0db7ceb17a01c13f1a`.
- Version 2.2 manuscript SHA-256:
  `192c233a864659aa8b639add41246d838298c1e79ad975bfcd340160265e5745`.
- Theorem-like statement environments unchanged: `PASS`, 18/18.
- Extracted mathematical spans unchanged: `PASS`, 389/389.
- Labels unchanged, in the same order, and unique: `PASS`, 18/18.
- Citation signatures unchanged: `PASS`, 19/19.
- `references.bib` unchanged byte-for-byte: `PASS`, 21 entries.
- `verify_small_groups.py` unchanged byte-for-byte: `PASS`.
- Existing formalization-status paragraph unchanged: `PASS`.
- Version 2.1 cross-reference repairs retained: `PASS`.
- `\author{}` command count: zero before and after.

## Formalization and provenance wording

- Both audited Lean 4.30 certificates are expressly limited to the headline
  mixed-left/right finite-group complement inequality.
- No strengthening is claimed formally verified.
- No AI system is listed as an author.
- AI-generated mathematical and literature audits are expressly distinguished
  from human peer review.
- Human specialist review is expressly stated not to have been obtained.
- Literature priority remains qualified as “apparently new, moderate
  confidence,” with no absolute historical-priority claim.

## Manuscript build and PDF

- Fresh deterministic pdfLaTeX/Biber build: `PASS`.
- All five build commands exited 0.
- Undefined references/citations: 0.
- Multiply defined labels: 0.
- LaTeX/package/class/pdfTeX warnings: 0.
- Biber warnings/errors: 0.
- Overfull boxes: 0.
- Underfull boxes: 0.
- Ghostscript/PyMuPDF/Poppler structural checks: `PASS`.
- Dual-engine 200-DPI rendering: `PASS`, 9/9 pages under each engine.
- Visual inspection of every page: `PASS`.
- Second clean deterministic build reproduced the packaged PDF byte-for-byte:
  `PASS`.
- Final PDF SHA-256:
  `6c82c218005037974992d9704324df8e17ea9df19e9b5cc79675be0be6cf96e9`.

## Exact finite verifier

Fresh replay returned:

```text
families_examined=29505
proper_unions_examined=28773
equality_cases_checked_as_cosets=3070
all_assertions=PASS
```

The fresh output is byte-identical to `VERIFIER_LOG.txt`. The verifier remains
supplemental and does not replace the proof or either Lean certificate.

## Archive protocol

- `SHA256SUMS.txt` covers every regular package member except itself.
- The release ZIP is tested with `unzip -t`.
- A clean extraction is checked with `sha256sum -c`.
- The extracted package is rebuilt by the documented deterministic TeX/Biber
  sequence and compared byte-for-byte with the packaged PDF.
- The exact finite verifier is replayed from the clean extraction.

## Privacy and release boundary

No repository, public service, DOI system, submission system, publication
system, tagging system, or visibility setting was accessed or changed. The
deliverable is one private local Version 2.2 archive; the Version 2.1 archive
is preserved separately as immutable evidence.
