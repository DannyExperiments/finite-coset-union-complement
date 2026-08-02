# Final Version 2.2 manuscript audit

Date frozen: 2026-08-02

```text
OUTER_ZIP_SHA256: 01489861a81b466ee614bd0a5c82a79247009d9e88e0a0a66c83435f691a2b05
MANUSCRIPT_TEX_SHA256: 192c233a864659aa8b639add41246d838298c1e79ad975bfcd340160265e5745
MANUSCRIPT_PDF_SHA256: 6c82c218005037974992d9704324df8e17ea9df19e9b5cc79675be0be6cf96e9
REFERENCES_BIB_SHA256: 11a8a133e32dad5d62f0bc3ea65bac7045d6cb53ab13a0d88987841086d8e792
INDEPENDENT_FINAL_MANUSCRIPT_AUDIT: PASS
PUBLIC_RELEASE_APPROVAL: OWNER_DECISION_PENDING
```

The complete archive contains 132 ZIP entries: 125 regular files and seven
directory entries. It passed its compressed-data test, and all 124 entries in
the internal checksum ledger passed; the ledger intentionally omits only
itself. Version 2.2 differs from the accepted Version 2.1 manuscript
by exactly one unnumbered `Verification and provenance` section immediately
before the bibliography. Removing that section reconstructs Version 2.1
byte-for-byte.

The audit found all 18 theorem-like statements, 389 extracted mathematical
spans, 18 unique labels, 19 citation signatures, the 21-entry bibliography,
and the finite verifier unchanged. The manuscript retains no `\author{}`
command. The new section names DannyExperiments as the conventional manuscript
author, credits the AI systems by contribution, limits both Lean certificates
to the headline theorem, and states the human-review and historical-priority
nonclaims.

The nine-page A4 PDF passed deterministic rebuild, warning/reference scans,
structural preflight, dual-engine rendering, and page-by-page visual
inspection. The finite verifier replay ended with `all_assertions=PASS` and is
supplemental rather than load-bearing.

This is an AI-assisted independent artifact and scope audit, not human peer
review. No commit, tag, push, publication, DOI, or visibility action is implied
by the PASS verdict.
