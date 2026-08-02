#!/usr/bin/env python3
"""Exact finite sanity checks for the Kourovka 21.115 rank manuscript.

This program is supplemental evidence only.  The manuscript proof is symbolic.
All matrix arithmetic here uses fractions.Fraction; all group operations use
explicit multiplication tables.
"""

from __future__ import annotations

from dataclasses import dataclass
from fractions import Fraction
from itertools import combinations, permutations, product
from typing import Iterable, Sequence


@dataclass(frozen=True)
class FiniteGroup:
    name: str
    table: tuple[tuple[int, ...], ...]
    identity: int = 0

    @property
    def order(self) -> int:
        return len(self.table)

    def mul(self, a: int, b: int) -> int:
        return self.table[a][b]

    def inv(self, a: int) -> int:
        for b in range(self.order):
            if self.mul(a, b) == self.identity and self.mul(b, a) == self.identity:
                return b
        raise AssertionError(f"no inverse for {a}")


def make_group(name: str, elements: Sequence[object], op) -> FiniteGroup:
    index = {x: i for i, x in enumerate(elements)}
    table = tuple(tuple(index[op(a, b)] for b in elements) for a in elements)
    g = FiniteGroup(name=name, table=table)
    verify_group_axioms(g)
    return g


def verify_group_axioms(g: FiniteGroup) -> None:
    n = g.order
    e = g.identity
    assert all(g.mul(e, a) == a and g.mul(a, e) == a for a in range(n))
    for a in range(n):
        assert any(g.mul(a, b) == e and g.mul(b, a) == e for b in range(n))
    for a in range(n):
        for b in range(n):
            for c in range(n):
                assert g.mul(g.mul(a, b), c) == g.mul(a, g.mul(b, c))


def cyclic(n: int) -> FiniteGroup:
    return make_group(f"C{n}", tuple(range(n)), lambda a, b: (a + b) % n)


def elementary_abelian_2(k: int) -> FiniteGroup:
    return make_group(f"C2^{k}", tuple(range(1 << k)), lambda a, b: a ^ b)


def dihedral_8() -> FiniteGroup:
    # (i,j) means r^i s^j, with s r s = r^{-1}.
    elems = tuple((i, j) for j in range(2) for i in range(4))
    def op(a, b):
        i, j = a
        k, ell = b
        return ((i + ((-1) ** j) * k) % 4, (j + ell) % 2)
    return make_group("D8", elems, op)


def quaternion_8() -> FiniteGroup:
    # Elements are sign*unit, units 1,i,j,k; encoded (sign,unit).
    elems = tuple((s, u) for s in (1, -1) for u in range(4))
    base = {
        (0, 0): (1, 0), (0, 1): (1, 1), (0, 2): (1, 2), (0, 3): (1, 3),
        (1, 0): (1, 1), (2, 0): (1, 2), (3, 0): (1, 3),
        (1, 1): (-1, 0), (2, 2): (-1, 0), (3, 3): (-1, 0),
        (1, 2): (1, 3), (2, 3): (1, 1), (3, 1): (1, 2),
        (2, 1): (-1, 3), (3, 2): (-1, 1), (1, 3): (-1, 2),
    }
    def op(a, b):
        s, u = a
        t, v = b
        q, w = base[(u, v)]
        return (s * t * q, w)
    # Put identity first.
    elems = ((1, 0), (-1, 0), (1, 1), (-1, 1), (1, 2), (-1, 2), (1, 3), (-1, 3))
    return make_group("Q8", elems, op)


def symmetric_3() -> FiniteGroup:
    elems = tuple(permutations(range(3)))
    identity = (0, 1, 2)
    elems = (identity,) + tuple(p for p in elems if p != identity)
    # Composition a o b: apply b, then a.
    return make_group("S3", elems, lambda a, b: tuple(a[b[i]] for i in range(3)))


def direct_product_cyclic(moduli: Sequence[int], name: str | None = None) -> FiniteGroup:
    elems = tuple(product(*(range(m) for m in moduli)))
    return make_group(name or "x".join(f"C{m}" for m in moduli), elems,
                      lambda a, b: tuple((x + y) % m for x, y, m in zip(a, b, moduli)))


def subgroups(g: FiniteGroup) -> list[frozenset[int]]:
    n = g.order
    out: list[frozenset[int]] = []
    for mask in range(1 << n):
        if not (mask & (1 << g.identity)):
            continue
        h = frozenset(i for i in range(n) if mask & (1 << i))
        ok = True
        for a in h:
            if g.inv(a) not in h:
                ok = False
                break
            for b in h:
                if g.mul(a, b) not in h:
                    ok = False
                    break
            if not ok:
                break
        if ok:
            out.append(h)
    return sorted(out, key=lambda h: (len(h), tuple(sorted(h))))


def left_coset(g: FiniteGroup, a: int, h: frozenset[int]) -> frozenset[int]:
    return frozenset(g.mul(a, x) for x in h)


def right_coset(g: FiniteGroup, h: frozenset[int], a: int) -> frozenset[int]:
    return frozenset(g.mul(x, a) for x in h)


def conjugate_subgroup(g: FiniteGroup, h: frozenset[int], a: int) -> frozenset[int]:
    ai = g.inv(a)
    return frozenset(g.mul(g.mul(ai, x), a) for x in h)


def all_coset_sets(g: FiniteGroup, hs: Sequence[frozenset[int]]) -> list[frozenset[int]]:
    sets = set()
    for h in hs:
        for a in range(g.order):
            sets.add(left_coset(g, a, h))
            sets.add(right_coset(g, h, a))
    return sorted(sets, key=lambda c: (len(c), tuple(sorted(c))))


def is_coset(g: FiniteGroup, a_set: frozenset[int], hs: Sequence[frozenset[int]]) -> bool:
    return any(a_set == left_coset(g, x, h) or a_set == right_coset(g, h, x)
               for h in hs for x in range(g.order))


def rank_fraction(matrix: Sequence[Sequence[int | Fraction]]) -> int:
    if not matrix:
        return 0
    a = [[Fraction(x) for x in row] for row in matrix]
    rows, cols = len(a), len(a[0])
    r = 0
    for c in range(cols):
        pivot = next((i for i in range(r, rows) if a[i][c] != 0), None)
        if pivot is None:
            continue
        a[r], a[pivot] = a[pivot], a[r]
        p = a[r][c]
        a[r] = [x / p for x in a[r]]
        for i in range(rows):
            if i != r and a[i][c] != 0:
                q = a[i][c]
                a[i] = [x - q * y for x, y in zip(a[i], a[r])]
        r += 1
        if r == rows:
            break
    return r


def independent_row_indices(matrix: Sequence[Sequence[int | Fraction]]) -> list[int]:
    chosen: list[int] = []
    current: list[Sequence[int | Fraction]] = []
    current_rank = 0
    for i, row in enumerate(matrix):
        trial = current + [row]
        rr = rank_fraction(trial)
        if rr > current_rank:
            chosen.append(i)
            current.append(row)
            current_rank = rr
    return chosen


def pivot_columns(matrix: Sequence[Sequence[int | Fraction]]) -> list[int]:
    if not matrix:
        return []
    a = [[Fraction(x) for x in row] for row in matrix]
    rows, cols = len(a), len(a[0])
    r = 0
    pivots: list[int] = []
    for c in range(cols):
        pivot = next((i for i in range(r, rows) if a[i][c] != 0), None)
        if pivot is None:
            continue
        a[r], a[pivot] = a[pivot], a[r]
        p = a[r][c]
        a[r] = [x / p for x in a[r]]
        for i in range(rows):
            if i != r and a[i][c] != 0:
                q = a[i][c]
                a[i] = [x - q * y for x, y in zip(a[i], a[r])]
        pivots.append(c)
        r += 1
        if r == rows:
            break
    return pivots


def determinant(matrix: Sequence[Sequence[int | Fraction]]) -> Fraction:
    n = len(matrix)
    assert all(len(row) == n for row in matrix)
    a = [[Fraction(x) for x in row] for row in matrix]
    det = Fraction(1)
    for c in range(n):
        pivot = next((i for i in range(c, n) if a[i][c] != 0), None)
        if pivot is None:
            return Fraction(0)
        if pivot != c:
            a[c], a[pivot] = a[pivot], a[c]
            det = -det
        p = a[c][c]
        det *= p
        for i in range(c + 1, n):
            if a[i][c] != 0:
                q = a[i][c] / p
                for j in range(c, n):
                    a[i][j] -= q * a[c][j]
    return det


def left_coset_labels(g: FiniteGroup, h: frozenset[int]) -> dict[int, int]:
    label: dict[int, int] = {}
    next_label = 0
    for a in range(g.order):
        if a in label:
            continue
        c = left_coset(g, a, h)
        for x in c:
            label[x] = next_label
        next_label += 1
    assert len(label) == g.order
    return label


def detector_factor(g: FiniteGroup, a: int, h: frozenset[int]) -> list[list[int]]:
    lab = left_coset_labels(g, h)
    return [[lab[y] - lab[g.mul(x, a)] for y in range(g.order)] for x in range(g.order)]


def hadamard(mats: Sequence[Sequence[Sequence[int]]]) -> list[list[int]]:
    n = len(mats[0])
    out = [[1 for _ in range(n)] for _ in range(n)]
    for mat in mats:
        for i in range(n):
            for j in range(n):
                out[i][j] *= mat[i][j]
    return out


def verify_detector_example() -> dict[str, object]:
    g = dihedral_8()
    hs = subgroups(g)
    proper = [h for h in hs if 1 < len(h) < g.order]
    # Search a genuinely mixed orientation description with nonempty complement.
    specs = []
    for h in proper:
        for a in range(g.order):
            specs.append(("L", a, h, left_coset(g, a, h)))
            specs.append(("R", a, h, right_coset(g, h, a)))
    chosen = None
    for s1 in specs:
        for s2 in specs:
            if s1[0] == s2[0] or s1[3] == s2[3]:
                continue
            u = s1[3] | s2[3]
            if 0 < len(u) < g.order:
                chosen = (s1, s2)
                break
        if chosen:
            break
    assert chosen is not None
    raw = list(chosen)
    union = raw[0][3] | raw[1][3]
    survivor = min(set(range(g.order)) - union)

    # Convert right descriptions to left cosets, then normalize by survivor^{-1}.
    normalized: list[tuple[int, frozenset[int]]] = []
    si = g.inv(survivor)
    for orient, a, h, cset in raw:
        if orient == "L":
            left_a, left_h = a, h
        else:
            left_a, left_h = a, conjugate_subgroup(g, h, a)
            assert cset == left_coset(g, left_a, left_h)
        normalized.append((g.mul(si, left_a), left_h))

    normalized_union = frozenset(g.mul(si, x) for x in union)
    A = frozenset(set(range(g.order)) - normalized_union)
    assert g.identity in A
    factors = [detector_factor(g, a, h) for a, h in normalized]
    factor_ranks = [rank_fraction(f) for f in factors]
    assert all(r <= 2 for r in factor_ranks)
    M = hadamard(factors)
    for x in range(g.order):
        for y in range(g.order):
            in_support = M[x][y] != 0
            expected = g.mul(g.inv(x), y) in A
            assert in_support == expected
        assert M[x][x] != 0
        assert sum(M[x][y] != 0 for y in range(g.order)) == len(A)
    r = rank_fraction(M)
    assert r <= 2 ** len(factors)
    assert g.order <= r * len(A)

    rows = independent_row_indices(M)
    assert len(rows) == r
    selected = [M[i] for i in rows]
    cols = pivot_columns(selected)
    assert len(cols) == r
    minor = [[M[i][j] for j in cols] for i in rows]
    det = determinant(minor)
    assert det != 0
    for i in rows:
        for j in cols:
            if M[i][j] != 0:
                assert g.mul(g.inv(i), j) in A

    row_cover = set().union(*(frozenset(g.mul(i, a) for a in A) for i in rows))
    assert row_cover == set(range(g.order))
    column_basis = independent_row_indices(list(map(list, zip(*M))))
    col_cover = set().union(*(frozenset(g.mul(y, g.inv(a)) for a in A) for y in column_basis))
    assert col_cover == set(range(g.order))

    return {
        "group": g.name,
        "raw_orientations": [s[0] for s in raw],
        "raw_coset_sizes": [len(s[3]) for s in raw],
        "survivor_before_normalization": survivor,
        "complement_size": len(A),
        "factor_ranks": factor_ranks,
        "product_rank": r,
        "rank_upper_bound": 2 ** len(factors),
        "rank_lower_fraction": f"{g.order}/{len(A)}",
        "minor_order": r,
        "minor_determinant": str(det),
        "row_translate_cover_size": len(rows),
        "right_translate_cover_size": len(column_basis),
    }


def verify_exhaustive_coset_families(g: FiniteGroup, max_n: int = 3) -> dict[str, object]:
    hs = subgroups(g)
    cosets = [c for c in all_coset_sets(g, hs) if len(c) < g.order]
    checked = 0
    proper = 0
    equality = 0
    min_scaled_slack: int | None = None
    for n in range(1, max_n + 1):
        for family in combinations(cosets, n):
            checked += 1
            u = frozenset().union(*family)
            if len(u) == g.order:
                continue
            proper += 1
            A = frozenset(set(range(g.order)) - u)
            scaled_slack = len(A) * (2 ** n) - g.order
            assert scaled_slack >= 0
            min_scaled_slack = scaled_slack if min_scaled_slack is None else min(min_scaled_slack, scaled_slack)
            if scaled_slack == 0:
                equality += 1
                assert is_coset(g, A, hs)
    return {
        "group": g.name,
        "order": g.order,
        "subgroups": len(hs),
        "distinct_proper_coset_sets": len(cosets),
        "families_examined": checked,
        "proper_unions_examined": proper,
        "equality_cases": equality,
        "minimum_scaled_slack": min_scaled_slack,
        "max_n": max_n,
    }


def block_matrix_left(g: FiniteGroup, h: frozenset[int], reps: Sequence[int]) -> list[list[int]]:
    lab = left_coset_labels(g, h)
    n = g.order
    return [[prod_int(lab[y] - lab[g.mul(x, a)] for a in reps) for y in range(n)] for x in range(n)]


def block_matrix_right(g: FiniteGroup, h: frozenset[int], reps: Sequence[int]) -> list[list[int]]:
    """Detector for a right block H a, using labels of the left-coset set G/H."""
    lab = left_coset_labels(g, h)
    n = g.order
    return [[
        prod_int(lab[x] - lab[g.mul(y, g.inv(a))] for a in reps)
        for y in range(n)
    ] for x in range(n)]


def prod_int(values: Iterable[int]) -> int:
    z = 1
    for v in values:
        z *= v
    return z


def verify_right_block_detector() -> dict[str, object]:
    """Check the dedicated right-block formula on a nonnormal subgroup of D8."""
    g = dihedral_8()
    hs = subgroups(g)
    h = next(
        h for h in hs
        if len(h) == 2 and any(conjugate_subgroup(g, h, a) != h for a in range(g.order))
    )

    distinct: list[tuple[int, frozenset[int]]] = []
    seen: set[frozenset[int]] = set()
    for a in range(g.order):
        c = right_coset(g, h, a)
        if c not in seen:
            seen.add(c)
            distinct.append((a, c))
    assert len(distinct) == g.order // len(h)

    reps = [distinct[0][0], distinct[1][0]]
    forbidden = distinct[0][1] | distinct[1][1]
    A = frozenset(set(range(g.order)) - forbidden)
    assert A

    B = block_matrix_right(g, h, reps)
    for x in range(g.order):
        for y in range(g.order):
            d = g.mul(g.inv(x), y)
            expected_zero = any(d in right_coset(g, h, a) for a in reps)
            assert (B[x][y] == 0) == expected_zero
        assert sum(B[x][y] != 0 for y in range(g.order)) == len(A)

    b = len(reps)
    r = rank_fraction(B)
    assert r <= b + 1
    z = min(A)
    for x in range(g.order):
        assert B[x][g.mul(x, z)] != 0
    assert g.order <= r * len(A)

    return {
        "group": g.name,
        "subgroup_order": len(h),
        "subgroup_nonnormal": True,
        "block_orientation": "R",
        "block_size": b,
        "forbidden_size": len(forbidden),
        "complement_size": len(A),
        "block_rank": r,
        "rank_upper_bound": b + 1,
        "survivor_transversal_element": z,
        "zero_pattern_verified": True,
    }


def verify_grouped_sharpness(profile: Sequence[int]) -> dict[str, object]:
    moduli = [b + 1 for b in profile]
    g = direct_product_cyclic(moduli, name=" x ".join(f"C{m}" for m in moduli))
    # Locate coordinates via the element tuples used by make_group.
    elems = list(product(*(range(m) for m in moduli)))
    idx = {x: i for i, x in enumerate(elems)}
    blocks = []
    union: set[int] = set()
    block_ranks = []
    for j, b in enumerate(profile):
        h = frozenset(idx[x] for x in elems if x[j] == 0)
        reps = []
        for value in range(1, b + 1):
            x = tuple(value if k == j else 0 for k in range(len(profile)))
            reps.append(idx[x])
            union.update(left_coset(g, idx[x], h))
        block = block_matrix_left(g, h, reps)
        br = rank_fraction(block)
        assert br <= b + 1
        blocks.append(block)
        block_ranks.append(br)
    A = set(range(g.order)) - union
    R = prod_int(b + 1 for b in profile)
    assert len(A) * R == g.order
    M = hadamard(blocks)
    r = rank_fraction(M)
    assert r <= R
    assert g.order <= r * len(A)
    return {
        "profile": list(profile),
        "group": g.name,
        "order": g.order,
        "complement_size": len(A),
        "denominator": R,
        "block_ranks": block_ranks,
        "product_rank": r,
        "equality_verified": True,
    }


def main() -> None:
    print("KOUROVKA 21.115 EXACT FINITE SANITY CHECK")
    print("Arithmetic: fractions.Fraction; group laws: explicit multiplication tables")
    print("Status: supplemental only; not used as a substitute for the proof\n")

    groups = [cyclic(6), symmetric_3(), dihedral_8(), quaternion_8(), elementary_abelian_2(3)]
    total_families = 0
    total_proper = 0
    total_equality = 0
    for g in groups:
        result = verify_exhaustive_coset_families(g, max_n=3)
        total_families += int(result["families_examined"])
        total_proper += int(result["proper_unions_examined"])
        total_equality += int(result["equality_cases"])
        print("EXHAUSTIVE", result)

    detector = verify_detector_example()
    print("\nMIXED-ORIENTATION DETECTOR", detector)

    right_block = verify_right_block_detector()
    print("RIGHT-BLOCK DETECTOR", right_block)

    grouped = [verify_grouped_sharpness((1, 1, 1)), verify_grouped_sharpness((2, 3))]
    for result in grouped:
        print("GROUPED-SHARPNESS", result)

    print("\nSUMMARY")
    print(f"families_examined={total_families}")
    print(f"proper_unions_examined={total_proper}")
    print(f"equality_cases_checked_as_cosets={total_equality}")
    print("all_assertions=PASS")


if __name__ == "__main__":
    main()
