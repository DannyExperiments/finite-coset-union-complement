import Mathlib

open scoped BigOperators Pointwise
open Classical

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000
set_option relaxedAutoImplicit false
set_option autoImplicit false

namespace Kourovka

inductive Side
  | left
  | right
  deriving DecidableEq, Repr

structure MixedCoset (G : Type*) [Group G] where
  H : Subgroup G
  rep : G
  side : Side

variable {G : Type*} [Group G] [Fintype G] [DecidableEq G]

/-- The finite left coset `aH`, defined directly and without normality. -/
noncomputable def leftCosetFinset (H : Subgroup G) (a : G) : Finset G :=
  Finset.univ.filter fun x => a⁻¹ * x ∈ H

/-- The finite right coset `Ha`, defined directly and without normality. -/
noncomputable def rightCosetFinset (H : Subgroup G) (a : G) : Finset G :=
  Finset.univ.filter fun x => x * a⁻¹ ∈ H

/-- The carrier of a mixed left/right coset. -/
noncomputable def MixedCoset.carrier (C : MixedCoset G) : Finset G :=
  match C.side with
  | .left => leftCosetFinset C.H C.rep
  | .right => rightCosetFinset C.H C.rep

/-- Elements not covered by the given mixed family. -/
noncomputable def uncovered {n : Nat} (C : Fin n → MixedCoset G) : Finset G :=
  Finset.univ.filter fun x => ∀ i, x ∉ (C i).carrier

/-- Right translation by a survivor is the permutation supplying the transversal. -/
def survivorPermutation (z : G) : Equiv.Perm G := Equiv.mulRight z

/-- Obligation 1: literal mixed carriers and the survivor permutation. -/
theorem mixed_coset_carrier_and_survivor_permutation
    {n : Nat} (C : Fin n → MixedCoset G) (z : G) (hz : z ∈ uncovered C) :
    (∀ i, (C i).carrier = match (C i).side with
      | .left => leftCosetFinset (C i).H (C i).rep
      | .right => rightCosetFinset (C i).H (C i).rep) ∧
    Function.Bijective (fun x : G => x * z) ∧
    ∀ x, survivorPermutation z x = x * z := by
  refine ⟨?_, ?_, ?_⟩
  · -- For all i, carrier equals the match
    intro i
    rfl
  · -- Bijective
    exact Equiv.bijective (Equiv.mulRight z)
  · -- survivorPermutation definition
    intro x
    rfl

/-- An injective rational label for every finite subset, hence in particular for left cosets. -/
noncomputable def finiteLabel (s : Finset G) : ℚ :=
  ((Fintype.equivFin (Finset G)) s : Nat)

/-- The detector attached to one mixed coset. -/
noncomputable def detector (C : MixedCoset G) (x y : G) : ℚ :=
  match C.side with
  | .left =>
      finiteLabel (leftCosetFinset C.H y) -
        finiteLabel (leftCosetFinset C.H (x * C.rep))
  | .right =>
      finiteLabel (leftCosetFinset C.H x) -
        finiteLabel (leftCosetFinset C.H (y * C.rep⁻¹))

/-- Obligation 2: both nonnormal detector orientations have exactly the desired zero set. -/
theorem finite_quotient_label_detector (C : MixedCoset G) (x y : G) :
    detector C x y = 0 ↔ x⁻¹ * y ∈ C.carrier := by
  unfold detector
  cases hside : C.side with
  | left =>
    simp [hside]
    unfold MixedCoset.carrier
    simp [hside]
    rw [sub_eq_zero]
    -- finiteLabel is injective, so equality of labels means equality of finsets
    have hfinj : ∀ s t : Finset G, finiteLabel s = finiteLabel t ↔ s = t := by
      intro s t
      simp [finiteLabel]
      refine ⟨fun h => ?_, fun h => by simp [h]⟩
      have h1 : (Fintype.equivFin (Finset G) s).val = (Fintype.equivFin (Finset G) t).val := by
        exact Nat.cast_injective h
      have h2 : Fintype.equivFin (Finset G) s = Fintype.equivFin (Finset G) t := Fin.val_injective h1
      exact Fintype.equivFin (Finset G) |>.injective h2
    rw [hfinj]
    -- leftCosetFinset H a = leftCosetFinset H b ↔ a⁻¹ * b ∈ H
    have leftCoset_eq : ∀ (H : Subgroup G) (a b : G), leftCosetFinset H a = leftCosetFinset H b ↔ a⁻¹ * b ∈ H := by
      intro H a b
      simp [leftCosetFinset, Finset.ext_iff]
      constructor
      · intro h
        have := h a
        simp at this
        -- this : b⁻¹ * a ∈ H, need a⁻¹ * b ∈ H
        have h1 := Subgroup.inv_mem _ this
        convert h1 using 1
        group
      · intro h z
        constructor
        · intro hz
          have hb : b⁻¹ * a ∈ H := by simpa using Subgroup.inv_mem _ h
          have : b⁻¹ * z = (b⁻¹ * a) * (a⁻¹ * z) := by group
          rw [this]
          exact H.mul_mem hb hz
        · intro hz
          have : a⁻¹ * z = (a⁻¹ * b) * (b⁻¹ * z) := by group
          rw [this]
          exact H.mul_mem h hz
    rw [leftCoset_eq]
    simp [leftCosetFinset]
    constructor <;> intro h
    · have h1 := Subgroup.inv_mem _ h
      convert Subgroup.mul_mem _ h1 (by simp : y⁻¹ * y ∈ C.H) using 1
      group
    · have h1 := Subgroup.inv_mem _ h
      convert Subgroup.mul_mem _ h1 (by simp : x⁻¹ * x ∈ C.H) using 1
      group
  | right =>
    simp [hside]
    unfold MixedCoset.carrier
    simp [hside]
    rw [sub_eq_zero]
    have hfinj : ∀ s t : Finset G, finiteLabel s = finiteLabel t ↔ s = t := by
      intro s t
      simp [finiteLabel]
      refine ⟨fun h => ?_, fun h => by simp [h]⟩
      have h1 : (Fintype.equivFin (Finset G) s).val = (Fintype.equivFin (Finset G) t).val := by
        exact Nat.cast_injective h
      have h2 : Fintype.equivFin (Finset G) s = Fintype.equivFin (Finset G) t := Fin.val_injective h1
      exact Fintype.equivFin (Finset G) |>.injective h2
    rw [hfinj]
    -- leftCosetFinset H a = leftCosetFinset H b ↔ a⁻¹ * b ∈ H
    have leftCoset_eq : ∀ (H : Subgroup G) (a b : G), leftCosetFinset H a = leftCosetFinset H b ↔ a⁻¹ * b ∈ H := by
      intro H a b
      simp [leftCosetFinset, Finset.ext_iff]
      constructor
      · intro h
        have := h a
        simp at this
        -- this : b⁻¹ * a ∈ H, need a⁻¹ * b ∈ H
        have h1 := Subgroup.inv_mem _ this
        convert h1 using 1
        group
      · intro h z
        constructor
        · intro hz
          have hb : b⁻¹ * a ∈ H := by simpa using Subgroup.inv_mem _ h
          have : b⁻¹ * z = (b⁻¹ * a) * (a⁻¹ * z) := by group
          rw [this]
          exact H.mul_mem hb hz
        · intro hz
          have : a⁻¹ * z = (a⁻¹ * b) * (b⁻¹ * z) := by group
          rw [this]
          exact H.mul_mem h hz
    rw [leftCoset_eq]
    simp [rightCosetFinset, leftCosetFinset, mul_assoc]

/-- Row-space rank of a finite matrix, as a natural-number dimension. -/
noncomputable def matrixRank (M : G → G → ℚ) : Nat :=
  Module.finrank ℚ (Submodule.span ℚ (Set.range M))

/-- A concrete sum-of-outer-products certificate. -/
def HasSeparableExpansion (M : G → G → ℚ) (r : Nat) : Prop :=
  ∃ u v : Fin r → G → ℚ, ∀ x y, M x y = ∑ k, u k x * v k y

/-- Any `r`-term outer-product expansion bounds ordinary row-space rank by `r`. -/
theorem matrixRank_le_of_separable {M : G → G → ℚ} {r : Nat}
    (h : HasSeparableExpansion M r) : matrixRank M ≤ r := by
  obtain ⟨u, v, hM⟩ := h
  unfold matrixRank
  -- Each row M x is a linear combination of v k, so range M ⊆ span ℚ (range v)
  have h_sub : Submodule.span ℚ (Set.range M) ≤ Submodule.span ℚ (Set.range v) := by
    rw [Submodule.span_le]
    intro f ⟨x, hx⟩
    rw [← hx]
    -- M x = ∑ k, u k x • v k
    have h_eq : M x = ∑ k, u k x • v k := by
      ext y
      simp [hM x y]
    rw [h_eq]
    apply Submodule.sum_mem
    intro k _
    apply Submodule.smul_mem
    apply Submodule.subset_span
    exact Set.mem_range_self k
  haveI : Fintype (Set.range v) := Set.Finite.fintype (Set.finite_range v)
  have h_card : (Set.range v).toFinset.card ≤ r := by
    have : Fintype.card (Set.range v) ≤ r := by
      calc Fintype.card (Set.range v) ≤ Fintype.card (Fin r) := Fintype.card_le_of_surjective (fun k => ⟨v k, Set.mem_range_self k⟩) (fun ⟨y, hy⟩ => by obtain ⟨k, rfl⟩ := hy; exact ⟨k, rfl⟩)
        _ = r := Fintype.card_fin r
    rwa [Set.toFinset_card]
  exact le_trans (Submodule.finrank_mono h_sub) (finrank_span_le_card (Set.range v) |>.trans h_card)

/-- Every mixed detector is explicitly a sum of two outer products. -/
theorem detector_has_separable_two (C : MixedCoset G) :
    HasSeparableExpansion (detector C) 2 := by
  cases hside : C.side with
  | left =>
    let u : Fin 2 → G → ℚ := fun k x => if k = 0 then 1 else -finiteLabel (leftCosetFinset C.H (x * C.rep))
    let v : Fin 2 → G → ℚ := fun k y => if k = 0 then finiteLabel (leftCosetFinset C.H y) else 1
    use u, v
    intro x y
    simp [detector, hside, u, v]
    ring
  | right =>
    let u : Fin 2 → G → ℚ := fun k x => if k = 0 then finiteLabel (leftCosetFinset C.H x) else 1
    let v : Fin 2 → G → ℚ := fun k y => if k = 0 then 1 else -finiteLabel (leftCosetFinset C.H (y * C.rep⁻¹))
    use u, v
    intro x y
    simp [detector, hside, u, v]
    ring

/-- Obligation 3: every mixed detector has ordinary rank at most two. -/
theorem detector_rank_le_two (C : MixedCoset G) :
    matrixRank (detector C) ≤ 2 := by
  exact matrixRank_le_of_separable (detector_has_separable_two C)

/-- Entrywise product of all detectors. -/
noncomputable def detectorProduct {n : Nat} (C : Fin n → MixedCoset G) (x y : G) : ℚ :=
  ∏ i, detector (C i) x y

/-- Separable expansions multiply under entrywise products. -/
theorem separable_mul {M N : G → G → ℚ} {r s : Nat}
    (hM : HasSeparableExpansion M r) (hN : HasSeparableExpansion N s) :
    HasSeparableExpansion (fun x y => M x y * N x y) (r * s) := by
  obtain ⟨u, v, hM_eq⟩ := hM
  obtain ⟨u', v', hN_eq⟩ := hN
  -- We need an equivalence Fin (r * s) ≃ Fin r × Fin s
  -- Define functions that use this equivalence
  have hcard : Fintype.card (Fin (r * s)) = Fintype.card (Fin r × Fin s) := by simp [Fintype.card_prod]
  let e : Fin (r * s) ≃ Fin r × Fin s := Fintype.equivOfCardEq hcard
  exact ⟨fun p x => u (e p).1 x * u' (e p).2 x, fun p y => v (e p).1 y * v' (e p).2 y, fun x y => by
  simp only
  rw [hM_eq x y, hN_eq x y]
  rw [Finset.sum_mul_sum]
  have hsum : ∑ i : Fin r, ∑ j : Fin s, u i x * v i y * (u' j x * v' j y) =
        ∑ p : Fin r × Fin s, (u p.1 x * u' p.2 x) * (v p.1 y * v' p.2 y) := by
    trans ∑ p : Fin r × Fin s, (u p.1 x * v p.1 y) * (u' p.2 x * v' p.2 y)
    · rw [← Finset.sum_product (s := Finset.univ) (t := Finset.univ) (f := fun p => u p.1 x * v p.1 y * (u' p.2 x * v' p.2 y))]
      rfl
    · congr 1; ext p; ring
  rw [hsum]
  have h := e.sum_comp (g := fun p => (u p.1 x * u' p.2 x) * (v p.1 y * v' p.2 y))
  rw [← h]⟩

/-- The finite product of the mixed detectors has a `2^n`-term expansion. -/
theorem detectorProduct_has_separable {n : Nat} (C : Fin n → MixedCoset G) :
    HasSeparableExpansion (detectorProduct C) (2 ^ n) := by
  -- Each detector has a 2-term separable expansion
  have hdetector : ∀ i : Fin n, ∃ u v : Fin 2 → G → ℚ,
      ∀ x y, detector (C i) x y = ∑ k : Fin 2, u k x * v k y := by
    intro i
    exact detector_has_separable_two (C i)
  -- Choose witnesses for each detector
  choose u v hu using hdetector
  -- The product is a sum over all functions Fin n → Fin 2
  -- Use equivalence between Fin (2^n) and (Fin n → Fin 2)
  have hcard : Fintype.card (Fin n → Fin 2) = 2 ^ n := by simp
  let e : Fin (2 ^ n) ≃ (Fin n → Fin 2) := Fintype.equivOfCardEq (by simp [hcard])
  use fun f x => ∏ i, u i (e f i) x, fun f y => ∏ i, v i (e f i) y
  intro x y
  simp [detectorProduct]
  rw [Finset.prod_congr rfl fun i _ => hu i x y]
  rw [Finset.prod_sum]
  conv_lhs =>
    arg 2
    ext p
    rw [Finset.prod_mul_distrib]
  have hpi : (Finset.univ.pi fun i : Fin n => (Finset.univ : Finset (Fin 2))) =
      Finset.univ.image (fun f : Fin n → Fin 2 => fun i hi => f i) := by
    ext f
    simp [Finset.mem_image, Finset.mem_pi, Finset.mem_univ]
    exact ⟨fun i => f i (Finset.mem_univ i), funext fun i => by rfl⟩
  have hinj : Function.Injective (fun f : Fin n → Fin 2 => fun (i : Fin n) (_ : i ∈ Finset.univ) => f i) := by
    intro f₁ f₂ h
    exact funext fun i => congr_fun (congr_fun h i) (Finset.mem_univ i)
  rw [hpi, Finset.sum_image hinj.injOn]
  rw [← Equiv.sum_comp e.symm]
  simp

/-- The support of row `x`. -/
noncomputable def rowSupport (M : G → G → ℚ) (x : G) : Finset G :=
  Finset.univ.filter fun y => M x y ≠ 0

/-- Obligation 4: product rank, exact support, support cardinality, and survivor transversal. -/
theorem product_rank_and_support {n : Nat} (C : Fin n → MixedCoset G)
    (z : G) (hz : z ∈ uncovered C) :
    matrixRank (detectorProduct C) ≤ 2 ^ n ∧
    (∀ x y, detectorProduct C x y ≠ 0 ↔ x⁻¹ * y ∈ uncovered C) ∧
    (∀ x, rowSupport (detectorProduct C) x = (uncovered C).image (fun a => x * a)) ∧
    (∀ x, (rowSupport (detectorProduct C) x).card = (uncovered C).card) ∧
    (∀ x, detectorProduct C x (x * z) ≠ 0) := by
  -- First establish the key lemma: detectorProduct C x y ≠ 0 ↔ x⁻¹ * y ∈ uncovered C
  have key : ∀ x y : G, detectorProduct C x y ≠ 0 ↔ x⁻¹ * y ∈ uncovered C := by
    intro x y
    simp [detectorProduct, Finset.prod_ne_zero_iff, finite_quotient_label_detector, uncovered]
  refine ⟨?_, key, ?_, ?_, ?_⟩
  · -- matrixRank ≤ 2^n
    exact matrixRank_le_of_separable (detectorProduct_has_separable C)
  · -- rowSupport = image
    intro x
    ext y
    simp [rowSupport, key]
  · -- card = (uncovered C).card
    intro x
    rw [show rowSupport (detectorProduct C) x = (uncovered C).image (fun a => x * a) from by
      ext y
      simp [rowSupport, key]]
    exact Finset.card_image_of_injective _ (mul_right_injective x)
  · -- detectorProduct C x (x * z) ≠ 0
    intro x
    exact key x (x * z) |>.mpr (by simp [hz])

/-- Actual matrix rows can be selected as a basis of the row space. -/
theorem exists_row_basis_finset (M : G → G → ℚ) :
    ∃ S : Finset G,
      S.card = matrixRank M ∧
      Submodule.span ℚ (M '' (S : Set G)) = Submodule.span ℚ (Set.range M) := by
  obtain ⟨f, hf, hspan, hlin⟩ := Submodule.exists_fun_fin_finrank_span_eq ℚ (Set.range M)
  choose g hg using hf
  have hgf : ∀ i, M (g i) = f i := hg
  have hginj : Function.Injective g := by
    intro i j hij
    apply hlin.injective
    rw [← hgf i, ← hgf j, hij]
  let S : Finset G := Finset.univ.image g
  refine ⟨S, ?_, ?_⟩
  · rw [show S.card = (Finset.univ : Finset (Fin (matrixRank M))).card from
      Finset.card_image_of_injective _ hginj]
    exact Fintype.card_fin _
  · rw [← hspan]
    apply congrArg (Submodule.span ℚ)
    ext v
    constructor
    · rintro ⟨x, hx, rfl⟩
      simp [S] at hx
      obtain ⟨i, hi⟩ := hx
      exact ⟨i, by rw [← hi, hgf i]⟩
    · rintro ⟨i, rfl⟩
      exact ⟨g i, by simp [S], hgf i⟩

/-- Supports of selected basis rows cover all columns when a permutation transversal is nonzero. -/
theorem row_basis_supports_cover
    (M : G → G → ℚ) (pi : Equiv.Perm G) (S : Finset G)
    (hspan : Submodule.span ℚ (M '' (S : Set G)) = Submodule.span ℚ (Set.range M))
    (htrans : ∀ x, M x (pi x) ≠ 0) :
    Finset.univ ⊆ S.biUnion (rowSupport M) := by
  intro x _
  simp only [Finset.mem_biUnion]
  by_contra h
  push_neg at h
  -- h : ∀ s ∈ S, M s x = 0
  -- Let y = pi⁻¹ x, then pi y = x
  set y := Equiv.invFun pi x with hy
  have hpix : pi y = x := Equiv.apply_symm_apply pi x
  -- By htrans, M y x ≠ 0
  have hne : M y x ≠ 0 := by simp [← hpix, htrans]
  -- M y ∈ Set.range M, hence in Submodule.span ℚ (Set.range M) = Submodule.span ℚ (M '' ↑S)
  have hMy_in_span : M y ∈ Submodule.span ℚ (M '' (S : Set G)) := by
    rw [hspan]
    exact Submodule.subset_span ⟨y, rfl⟩
  -- Evaluate at x: the functional evaluation at x is zero on all s ∈ S
  -- So it's zero on the entire span
  -- Define the linear functional: evaluation at x
  let eval_x : (G → ℚ) →ₗ[ℚ] ℚ := LinearMap.proj x
  -- This functional is zero on all generators M '' S
  have hzero : ∀ m ∈ M '' (S : Set G), eval_x m = 0 := by
    intro m ⟨s, hs, hms⟩
    rw [← hms]
    have : x ∉ rowSupport M s := h s hs
    simp [rowSupport] at this
    exact this
  -- So eval_x (M y) = 0
  have hMy_zero : eval_x (M y) = 0 := by
    refine Submodule.span_induction ?_ ?_ ?_ ?_ hMy_in_span
    · intro m hm; exact hzero m hm
    · simp
    · intro a b _ _ ha hb; simp [ha, hb]
    · intro c a _ ha; simp [ha]
  exact hne (by simpa using hMy_zero)

/-- Obligation 5: sparse nonsymmetric matrices with a nonzero permutation
transversal have size at most row rank times the maximal row support. -/
theorem sparse_transversal_rank_bound
    (M : G → G → ℚ) (pi : Equiv.Perm G) (m : Nat)
    (htrans : ∀ x, M x (pi x) ≠ 0)
    (hsparse : ∀ x, (rowSupport M x).card ≤ m) :
    Fintype.card G ≤ matrixRank M * m := by
  obtain ⟨S, hS_card, hS_span⟩ := exists_row_basis_finset M
  have hcover := row_basis_supports_cover M pi S hS_span htrans
  have hcard_univ : (Finset.univ : Finset G).card = Fintype.card G := Finset.card_univ
  have h1 : Fintype.card G ≤ (S.biUnion (rowSupport M)).card := by
    rw [← hcard_univ]
    exact Finset.card_le_card hcover
  have h2 : (S.biUnion (rowSupport M)).card ≤ S.card * m := by
    calc (S.biUnion (rowSupport M)).card ≤ ∑ x ∈ S, (rowSupport M x).card := Finset.card_biUnion_le
      _ ≤ ∑ _x ∈ S, m := Finset.sum_le_sum fun x _ => hsparse x
      _ = S.card * m := by simp
  rw [hS_card] at h2
  linarith [h1, h2]

/-- Kourovka Notebook Problem 21.115, for independently left- or right-oriented cosets. -/
theorem kourovka_21_115
    {n : Nat} (C : Fin n → MixedCoset G)
    (hA : (uncovered C).Nonempty) :
    Fintype.card G ≤ 2 ^ n * (uncovered C).card := by
  obtain ⟨z, hz⟩ := hA
  have h := product_rank_and_support C z hz
  have h1 := sparse_transversal_rank_bound (detectorProduct C) (survivorPermutation z) (uncovered C).card (fun x => h.2.2.2.2 x) (fun x => (h.2.2.2.1 x).symm ▸ le_rfl)
  exact le_trans h1 (Nat.mul_le_mul_right _ h.1)

end Kourovka
