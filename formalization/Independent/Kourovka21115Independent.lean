import Mathlib

/-!
# Kourovka Notebook Problem 21.115

This file formalizes the sharp complement bound for a non-full union of
subgroup cosets in a finite group.  The final theorem is stated in the
division-free cardinal form `|G| <= 2^n * |A|`.
-/

namespace Kourovka21115

open scoped BigOperators

noncomputable section

variable {K ι : Type*} [Field K] [Fintype ι] [DecidableEq ι]

/-- The finite support of one row of a matrix. -/
def rowSupport (M : Matrix ι ι K) (i : ι) : Finset ι :=
  by
    classical
    exact Finset.univ.filter fun j => M i j ≠ 0

/--
The sparse-diagonal rank lemma, in the division-free form used in the paper.
It works for a nonsymmetric matrix over an arbitrary field.
-/
theorem card_le_rank_mul_of_diag_support
    (M : Matrix ι ι K) (m : ℕ)
    (hdiag : ∀ i, M i i ≠ 0)
    (hrow : ∀ i, (rowSupport M i).card ≤ m) :
    Fintype.card ι ≤ M.rank * m := by
  classical
  let s : Set (ι → K) := Set.range M.row
  obtain ⟨t, ht_sub, ht_card, ht_span, -⟩ :=
    Submodule.exists_finset_span_eq_linearIndepOn K s
  let supp : (ι → K) → Finset ι := fun v =>
    Finset.univ.filter fun j => v j ≠ 0
  have ht_support : ∀ v ∈ t, (supp v).card ≤ m := by
    intro v hv
    obtain ⟨i, rfl⟩ := ht_sub (show v ∈ (t : Set (ι → K)) from hv)
    simpa [supp, rowSupport, Matrix.row] using hrow i
  have hcover : Finset.univ ⊆ t.biUnion supp := by
    intro j hj_univ
    by_contra hj
    have hz : ∀ v ∈ t, v j = 0 := by
      intro v hv
      have hjv : j ∉ supp v := by
        intro hjv
        exact hj (Finset.mem_biUnion.mpr ⟨v, hv, hjv⟩)
      simpa [supp] using hjv
    let eval : (ι → K) →ₗ[K] K := LinearMap.proj j
    have hspan_le : Submodule.span K (t : Set (ι → K)) ≤ eval.ker := by
      apply Submodule.span_le.2
      intro v hv
      change eval v = 0
      simpa using hz v hv
    have hrow_mem : M.row j ∈ Submodule.span K s :=
      Submodule.subset_span (Set.mem_range_self j)
    have hzero : M j j = 0 := by
      have : M.row j ∈ eval.ker := by
        apply hspan_le
        rw [ht_span]
        exact hrow_mem
      simpa [Matrix.row] using this
    exact hdiag j hzero
  calc
    Fintype.card ι = Finset.univ.card := by simp
    _ ≤ (t.biUnion supp).card := Finset.card_le_card hcover
    _ ≤ t.card * m := Finset.card_biUnion_le_card_mul t supp m ht_support
    _ = M.rank * m := by
      rw [ht_card, Matrix.rank_eq_finrank_span_row]

/-! ## Coset detectors -/

/-- Each listed coset may independently be a left or a right coset. -/
inductive Orientation
  | left
  | right
  deriving DecidableEq

/-- Literal membership in `aH` or `Ha`, according to the orientation. -/
def InCoset {G : Type*} [Group G] (o : Orientation)
    (H : Subgroup G) (a x : G) : Prop :=
  match o with
  | .left => a⁻¹ * x ∈ H
  | .right => x * a⁻¹ ∈ H

/-- The elements missed by all listed cosets. -/
def survivors {G : Type*} [Group G] [Fintype G] [DecidableEq G]
    {n : ℕ} (o : Fin n → Orientation) (H : Fin n → Subgroup G)
    (a : Fin n → G) : Finset G := by
  classical
  exact Finset.univ.filter fun x => ∀ i, ¬ InCoset (o i) (H i) (a i) x

/-- An injective rational label for the finite set of left cosets of `H`. -/
def cosetLabel {G : Type*} [Group G] [Fintype G]
    (H : Subgroup G) (x : G) : ℚ := by
  classical
  exact ((((Fintype.equivFin (G ⧸ H)) (Quotient.mk'' x)).val : ℕ) : ℚ)

theorem cosetLabel_eq_iff {G : Type*} [Group G] [Fintype G]
    (H : Subgroup G) (x y : G) :
    cosetLabel H x = cosetLabel H y ↔ x⁻¹ * y ∈ H := by
  classical
  change
    (((Fintype.equivFin (G ⧸ H)) (Quotient.mk'' x)).val : ℚ) =
      (((Fintype.equivFin (G ⧸ H)) (Quotient.mk'' y)).val : ℚ) ↔ _
  rw [Nat.cast_inj, Fin.val_inj,
    (Fintype.equivFin (G ⧸ H)).apply_eq_iff_eq, QuotientGroup.eq]

section Main

variable {G : Type*} [Group G] [Fintype G] [DecidableEq G]
variable {n : ℕ} (o : Fin n → Orientation) (H : Fin n → Subgroup G)
  (a : Fin n → G)

def rowPart (i : Fin n) (x : G) : ℚ :=
  match o i with
  | .left => cosetLabel (H i) (x * a i)
  | .right => cosetLabel (H i) x

def colPart (z : G) (i : Fin n) (y : G) : ℚ :=
  match o i with
  | .left => -cosetLabel (H i) (y * z)
  | .right => -cosetLabel (H i) (y * z * (a i)⁻¹)

def detector (z : G) (i : Fin n) (x y : G) : ℚ :=
  rowPart o H a i x + colPart o H a z i y

omit [DecidableEq G] in
theorem detector_ne_zero_iff (z : G) (i : Fin n) (x y : G) :
    detector o H a z i x y ≠ 0 ↔
      ¬ InCoset (o i) (H i) (a i) (x⁻¹ * y * z) := by
  cases hoi : o i
  · simp only [detector, rowPart, colPart, hoi, ne_eq]
    rw [add_neg_eq_zero, cosetLabel_eq_iff]
    simp [InCoset, mul_assoc]
  · simp only [detector, rowPart, colPart, hoi, ne_eq]
    rw [add_neg_eq_zero, cosetLabel_eq_iff]
    simp [InCoset, mul_assoc]

def witnessMatrix (z : G) : Matrix G G ℚ := fun x y =>
  ∏ i, detector o H a z i x y

def leftFactor : Matrix G (Finset (Fin n)) ℚ := fun x s =>
  ∏ i ∈ s, rowPart o H a i x

def rightFactor (z : G) : Matrix (Finset (Fin n)) G ℚ := fun s y =>
  ∏ i ∈ sᶜ, colPart o H a z i y

omit [DecidableEq G] in
theorem witnessMatrix_factor (z : G) :
    witnessMatrix o H a z = leftFactor o H a * rightFactor o H a z := by
  classical
  ext x y
  simp only [witnessMatrix, leftFactor, rightFactor, Matrix.mul_apply]
  simpa [detector] using
    (Fintype.prod_add (fun i => rowPart o H a i x)
      (fun i => colPart o H a z i y))

omit [DecidableEq G] in
theorem witnessMatrix_rank_le (z : G) :
    (witnessMatrix o H a z).rank ≤ 2 ^ n := by
  classical
  rw [witnessMatrix_factor]
  exact (Matrix.rank_mul_le_left _ _).trans
    ((Matrix.rank_le_card_width _).trans_eq (by simp))

theorem witnessMatrix_ne_zero_iff (z x y : G) :
    witnessMatrix o H a z x y ≠ 0 ↔
      x⁻¹ * y * z ∈ survivors o H a := by
  classical
  rw [show witnessMatrix o H a z x y = ∏ i, detector o H a z i x y by rfl,
    Finset.prod_ne_zero_iff]
  simp only [detector_ne_zero_iff]
  simp [survivors]

/-- The group bijection which identifies a row support with the survivor set. -/
def rowTranslate (z x : G) : G ≃ G where
  toFun y := x⁻¹ * y * z
  invFun w := x * w * z⁻¹
  left_inv y := by simp [mul_assoc]
  right_inv w := by simp [mul_assoc]

theorem witnessMatrix_rowSupport_card (z x : G) :
    (rowSupport (witnessMatrix o H a z) x).card = (survivors o H a).card := by
  classical
  let e := rowTranslate z x
  have hsupp : rowSupport (witnessMatrix o H a z) x =
      (survivors o H a).map e.symm.toEmbedding := by
    ext y
    simp [rowSupport, witnessMatrix_ne_zero_iff, e, rowTranslate, mul_assoc]
  rw [hsupp, Finset.card_map]

/--
**Kourovka Notebook Problem 21.115.**  If a family of `n` arbitrary left or
right subgroup cosets does not cover a finite group, its complement `A`
satisfies `|G| ≤ 2^n |A|`.
-/
theorem kourovka_21_115
    (hnonempty : (survivors o H a).Nonempty) :
    Fintype.card G ≤ 2 ^ n * (survivors o H a).card := by
  classical
  obtain ⟨z, hz⟩ := hnonempty
  let M := witnessMatrix o H a z
  have hdiag : ∀ x, M x x ≠ 0 := by
    intro x
    rw [show M x x = witnessMatrix o H a z x x by rfl,
      witnessMatrix_ne_zero_iff]
    simpa using hz
  have hrow : ∀ x, (rowSupport M x).card ≤ (survivors o H a).card := by
    intro x
    rw [show rowSupport M x = rowSupport (witnessMatrix o H a z) x by rfl,
      witnessMatrix_rowSupport_card]
  exact (card_le_rank_mul_of_diag_support M _ hdiag hrow).trans
    (Nat.mul_le_mul_right _ (witnessMatrix_rank_le o H a z))

end Main

end

#print axioms Kourovka21115.kourovka_21_115

end Kourovka21115
