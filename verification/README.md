# Finite regression verifier

`verify_small_groups.py` is a dependency-free exact checker using explicit
multiplication tables and rational arithmetic. It tests representative small
groups, detector zero patterns, rank bounds, equality cases, two-sided
translate covers, and grouped constructions.

Run:

```sh
python3 verify_small_groups.py
```

The expected output is recorded in `VERIFIER_LOG.txt`.

This computation is supplemental regression evidence. It is neither the
universal proof nor the Lean certificate.

