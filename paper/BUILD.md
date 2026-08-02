# Version 2.2 manuscript build

The accepted package records a deterministic build with pdfTeX 1.40.26 and
Biber 2.20. From this directory, a clean rebuild can be made without writing
generated files into the checkout:

```sh
set -eu
build_dir="$(mktemp -d)"
trap 'rm -rf "$build_dir"' EXIT HUP INT TERM
cp manuscript.tex references.bib "$build_dir"/
cd "$build_dir"
export SOURCE_DATE_EPOCH=1785628800
export FORCE_SOURCE_DATE=1
pdflatex -interaction=nonstopmode -halt-on-error -file-line-error manuscript.tex
biber manuscript
pdflatex -interaction=nonstopmode -halt-on-error -file-line-error manuscript.tex
pdflatex -interaction=nonstopmode -halt-on-error -file-line-error manuscript.tex
pdflatex -interaction=nonstopmode -halt-on-error -file-line-error manuscript.tex
```

The packaged build was repeated from a second clean directory and reproduced
`manuscript.pdf` byte-for-byte. `BUILD_LOG.txt`, `PDF_PREFLIGHT.txt`, and
`PACKAGE_VALIDATION.md` record the accepted producer-side checks. The public
repository verifier separately checks exact hashes, required disclosure text,
the finite regression log, and repository hygiene.

No dependency installation is performed by the repository scripts.
