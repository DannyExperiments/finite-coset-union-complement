#!/bin/sh
set -eu

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
cd "$ROOT"

required_files='
README.md
STATUS.md
AI_DISCLOSURE.md
PROVENANCE.md
REPRODUCIBILITY.md
CONTRIBUTING.md
SECURITY.md
RELEASE_CHECKLIST.md
CHANGELOG.md
MANIFEST.md
LICENSE_STATUS.md
CITATION.cff
proof/PROBLEM_AND_PROOF.md
paper/README.md
paper/manuscript.tex
paper/manuscript.pdf
paper/references.bib
paper/BUILD.md
paper/BUILD_LOG.txt
paper/PDF_PREFLIGHT.txt
paper/PACKAGE_VALIDATION.md
paper/V2_1_TO_V2_2_CHANGELOG.md
paper/V2_1_TO_V2_2_SOURCE_COMPARISON.md
formalization/Kourovka21115.lean
formalization/AxiomAudit.lean
formalization/Independent/Kourovka21115Independent.lean
formalization/Independent/README.md
formalization/Independent/BUILD_AND_AXIOM_AUDIT_PRE_ARISTOTLE_2026-08-02.txt
formalization/Independent/FORMALIZATION_REPORT_PRE_ARISTOTLE.md
formalization/Independent/CHECKSUMS.sha256
formalization/lakefile.lean
formalization/lean-toolchain
formalization/lake-manifest.json
formalization/README.md
formalization/FORMALIZATION_REPORT.md
formalization/BUILD_AND_AXIOM_AUDIT.txt
formalization/CHECKSUMS.sha256
audits/README.md
audits/MATHEMATICAL_AUDIT.md
audits/LITERATURE_PRIORITY_AUDIT.md
audits/EXTENSION_AUDIT.md
audits/LEAN_AUDIT.md
audits/CLAIMS_EVIDENCE_MATRIX.md
audits/FINAL_MANUSCRIPT_AUDIT_STATUS.md
verification/README.md
verification/verify_small_groups.py
verification/VERIFIER_LOG.txt
scripts/regenerate_checksums.sh
release/RELEASE_NOTES_v1.0.0.md
SHA256SUMS.txt
'

for file in $required_files
do
  if [ ! -s "$file" ]
  then
    echo "Missing or empty public file: $file" >&2
    exit 1
  fi
done

if command -v shasum >/dev/null 2>&1
then
  shasum -a 256 -c SHA256SUMS.txt
elif command -v sha256sum >/dev/null 2>&1
then
  sha256sum -c SHA256SUMS.txt
else
  echo 'No SHA-256 checker found.' >&2
  exit 1
fi

grep -F 'PUBLIC_RELEASE_CANDIDATE_AI_AUDITED_DUAL_LEAN_CORE_VERIFIED_V2_2_MANUSCRIPT_PASS' STATUS.md >/dev/null
grep -Fi 'human specialist review was not obtained' README.md AI_DISCLOSURE.md STATUS.md >/dev/null
grep -F 'Kourovka.kourovka_21_115' README.md STATUS.md formalization/README.md audits/LEAN_AUDIT.md >/dev/null
grep -F 'Kourovka21115.kourovka_21_115' README.md STATUS.md formalization/README.md audits/LEAN_AUDIT.md >/dev/null
grep -F 'not formalize' README.md AI_DISCLOSURE.md formalization/README.md audits/LEAN_AUDIT.md >/dev/null
grep -F 'absolute historical priority' README.md AI_DISCLOSURE.md PROVENANCE.md >/dev/null
grep -F 'UnsolvedMath v1.2.0' README.md PROVENANCE.md >/dev/null
grep -F 'official Notebook, not the dataset' README.md >/dev/null

if grep -nE '(^|[^[:alpha:]])(sorry|admit|unsafe|axiom|opaque)([^[:alpha:]]|$)' \
  formalization/Kourovka21115.lean \
  formalization/AxiomAudit.lean \
  formalization/Independent/Kourovka21115Independent.lean
then
  echo 'Found a forbidden Lean proof hole, unsafe declaration, or custom axiom.' >&2
  exit 1
fi

if command -v shasum >/dev/null 2>&1
then
  (cd formalization && shasum -a 256 -c CHECKSUMS.sha256)
  (cd formalization/Independent && shasum -a 256 -c CHECKSUMS.sha256)
else
  (cd formalization && sha256sum -c CHECKSUMS.sha256)
  (cd formalization/Independent && sha256sum -c CHECKSUMS.sha256)
fi

for forbidden in sources handoffs notes candidates .lake
do
  if [ -e "$forbidden" ] || [ -e "paper/$forbidden" ] || [ -e "formalization/$forbidden" ]
  then
    echo "Private-only path present in public tree: $forbidden" >&2
    exit 1
  fi
done

if find . -name '.DS_Store' -print | grep . >/dev/null
then
  echo 'Found .DS_Store in public tree.' >&2
  exit 1
fi

if grep -R -nE \
  '(/Users/[^/]+/|/private/var/|/tmp/|/mnt/data/|sandbox:/|chatgpt\.com/g/|BEGIN (RSA |OPENSSH |EC )?PRIVATE KEY|ghp_[[:alnum:]]+|github_pat_[[:alnum:]_]+|sk-[[:alnum:]]{20,})' \
  --exclude='verify.sh' \
  --exclude='SHA256SUMS.txt' \
  --exclude='*.pdf' \
  --exclude-dir='.git' \
  .
then
  echo 'Found a private path, task URL, or credential-like pattern.' >&2
  exit 1
fi

if grep -R -nE \
  '(must remain private|authorship (is|remains) unresolved|no proof-assistant formalization|human peer reviewed|historical priority (is )?certified|extensions are formally verified)' \
  --exclude='verify.sh' \
  --exclude='SHA256SUMS.txt' \
  --exclude='*.pdf' \
  --exclude-dir='.git' \
  .
then
  echo 'Found stale or overstated public-status language.' >&2
  exit 1
fi

tmp_log=$(mktemp)
trap 'rm -f "$tmp_log"' EXIT HUP INT TERM
python3 verification/verify_small_groups.py > "$tmp_log"
cmp -s "$tmp_log" verification/VERIFIER_LOG.txt || {
  echo 'Finite verifier output differs from the recorded log.' >&2
  diff -u verification/VERIFIER_LOG.txt "$tmp_log" || true
  exit 1
}

if grep -F '\author{' paper/manuscript.tex >/dev/null
then
  echo 'Canonical manuscript unexpectedly contains a title-page author entry.' >&2
  exit 1
fi

grep -F 'Verification and provenance' paper/manuscript.tex >/dev/null
grep -F 'No AI system is listed as an author.' paper/manuscript.tex >/dev/null
grep -F 'none of the strengthenings is claimed to be formally' paper/manuscript.tex >/dev/null
grep -F 'INDEPENDENT_FINAL_MANUSCRIPT_AUDIT: PASS' audits/FINAL_MANUSCRIPT_AUDIT_STATUS.md >/dev/null

test "$(shasum -a 256 paper/manuscript.tex | awk '{print $1}')" = \
  '192c233a864659aa8b639add41246d838298c1e79ad975bfcd340160265e5745'
test "$(shasum -a 256 paper/manuscript.pdf | awk '{print $1}')" = \
  '6c82c218005037974992d9704324df8e17ea9df19e9b5cc79675be0be6cf96e9'
test "$(shasum -a 256 paper/references.bib | awk '{print $1}')" = \
  '11a8a133e32dad5d62f0bc3ea65bac7045d6cb53ab13a0d88987841086d8e792'

if git rev-parse --is-inside-work-tree >/dev/null 2>&1
then
  git diff --check
fi

echo 'Public-release artifact integrity and disclosure checks passed.'
