# Exact Version 2.1-to-Version 2.2 source comparison

Version 2.2 differs from Version 2.1 by one exact insertion: the unnumbered
`Verification and provenance` section immediately before `\printbibliography`.
Removing that inserted byte block reconstructs the Version 2.1 manuscript
byte-for-byte.

```text
Baseline manuscript SHA-256: 19ef16e63b4ad85a387872909d93459fa006171fdaa55d0db7ceb17a01c13f1a
V2.2 manuscript SHA-256: 192c233a864659aa8b639add41246d838298c1e79ad975bfcd340160265e5745
Reconstructed baseline SHA-256 after removing the inserted section: 19ef16e63b4ad85a387872909d93459fa006171fdaa55d0db7ceb17a01c13f1a

Candidate becomes byte-identical to V2.1 after removing only the inserted section: PASS
Inserted Verification and provenance sections: 1
Section immediately before bibliography: PASS

Theorem-like statement environments unchanged: PASS (18/18)
Extracted mathematical spans unchanged: PASS (389/389)
Labels unchanged and unique: PASS (18/18)
Citation signatures unchanged: PASS (19/19)
Bibliography unchanged byte-for-byte: PASS (21/21 entries)
verify_small_groups.py unchanged byte-for-byte: PASS
Existing formalization-status paragraph unchanged and present: PASS
Author command count: 0

Citation-count convention: the V2.1 audit records 19 distinct citation-argument signatures in first-occurrence order; the full sequence is unchanged.

VERDICT: PASS
```

The unified source diff is recorded in `V2_1_TO_V2_2.diff`; the executable audit and machine record are under `BUILD_RECORDS_V2_2/`.
