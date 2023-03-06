import LowDegreeEquations.sqrt
import Mathlib

namespace Quadratic

/-Defining the two roots of quadratic equation-/
noncomputable def root₁ (a b c : ℝ) (h:(b^2 - 4*a*c) ≥ 0): ℝ := (-b + ℝ.sqrt (b^2 - 4*a*c) h) / (2*a)
noncomputable def root₂(a b c : ℝ) (h:(b^2 - 4*a*c) ≥ 0): ℝ := (-b - ℝ.sqrt (b^2 - 4*a*c) h) / (2*a) 

def two_mul_two (R : Type) [Ring R] : (4: R) = (2 : R) * (2: R) := by /-proof that 2*ℝ * 2*ℝ = 4*ℝ -/
    have : (2: R) = (1: R) + (1: R) := by norm_cast
    rw [this, mul_add, mul_one]
    norm_cast

private lemma l₁ (a b c : ℝ) (h:(b*b - 4*a*c) ≥ 0) (h': a≠0): (b * ((-b + ℝ.sqrt (b * b - 4*a*c) h) / (2 * a))) = ((-(2*a*b*b)/(4*a*a)) + ((2*a*b*(ℝ.sqrt (b * b - 4*a*c) h))/(4*a*a))) := by
/-Simplifying the term with power 1 of the root₁.
The simplification in RHS is done by hand (Expected).
In LHS theorems are used to simplify into the expected term.
For this lemma h' is required as there is a stage in simplification where 2*a is multiplied and divided, hence proved that given h', 2*a ≠ 0 -/
  have h' : 2*a ≠ 0 := by
    simp only [ne_eq, mul_eq_zero, OfNat.ofNat_ne_zero, h', or_self, not_false_iff] 
  conv=>
    lhs
    simp only [add_div,mul_div,mul_add, add_mul]
    rw [←mul_div_mul_right (c:=2*a) (hc:=h')] /-divide and multiply by 2*a -/
    rw [←mul_div_mul_right (c:=2*a) (a:=b * ℝ.sqrt (b * b - 4 * a * c) h) (b := 2*a) (hc:=h')] /-divide and multiply by 2*a -/
    simp [mul_left_comm (a:=b) (b:=2) (c:=a)]
    rw [mul_left_comm,mul_right_comm,mul_assoc]
    rw [←mul_left_comm (a:=a) (b:=b) (c:=b)]
    rw [mul_mul_mul_comm]
    rw [mul_rotate (a:=b) (b:=(ℝ.sqrt (b * b - 4 * a * c) h)) (c:=2*a)]
    rw [mul_rotate (a:=ℝ.sqrt (b * b - 4 * a * c) h) (b:=2*a) (c:=b)]
    simp only [←mul_assoc]
    simp [←two_mul_two]

private lemma l₂ (a b c : ℝ) (h:(b*b - 4*a*c) ≥ 0):
/-Simplifying the term with power 2 of root₁.
The simplification RHS is the expected simplification (done by hand). 
So, using theorems and ring tactic (on LHS) it is proved that the term actually reduces to hand simplified term-/
  a *((-b * -b + ℝ.sqrt (b * b - 4 * a * c) h * -b +
        (-b * ℝ.sqrt (b * b - 4 * a * c) h +
          ℝ.sqrt (b * b - 4 * a * c) h * ℝ.sqrt (b * b - 4 * a * c) h)) /
              (2 * (2 * a * a))) = 
                (2*a*b*b - 4*a*a*c - 2*a*b*ℝ.sqrt (b*b - 4*a*c) h)/(4*a*a) := by
                conv=>
                  lhs
                  rw [ℝ.sqrt_mul_self (b*b - 4*a*c) h]
                  simp only [mul_div,mul_add,mul_sub]
                  simp only [←mul_assoc]
                  simp [←two_mul_two]
                  rw [mul_right_comm (a:=a) (b:=ℝ.sqrt (b*b - 4*a*c) h) (c:=b)]
                  rw [←add_assoc]
                ring


theorem root₁_is_root (a b c : ℝ) (h:(b^2 - 4*a*c) ≥ 0) (h': a≠0): a*(root₁ a b c h)^2 + b*(root₁ a b c h) + c = 0 := by
/-Proof that root₁ is actually the root of quadratic.
Essentially it is simplification using various theorems, and split into major 3 terms out of which two are bigger terms
and are simplified in private lemmas l₁ (specifically pass h:= a ≠ 0 as it involves multiplication and addition of 2*a) and l₂.
Once the major 2 terms are simplified, its rewritten and then ring_nf tactic is applied along with some more simplification theorems-/
  simp only [root₁, div_pow]
  simp only [pow_two, mul_left_comm, mul_add, add_mul] at h ⊢
  rw [l₁ (h':=h')]
  rw [l₂]
  ring_nf
  simp only [pow_two]
  simp [←mul_rotate (a:=a⁻¹*a⁻¹) (b:=a*a) (c:=c)]
  rw [mul_mul_mul_comm]
  rw[←one_div]
  rw [one_div_mul_cancel (h:=h')]
  rw [mul_one,one_mul]
  rw [neg_add_self]

private lemma l'₁ (a b c : ℝ) (h:(b*b - 4*a*c) ≥ 0) (h': a≠0): (b * ((-b - ℝ.sqrt (b * b - 4*a*c) h) / (2 * a))) = ((-(2*a*b*b)/(4*a*a)) - ((2*a*b*(ℝ.sqrt (b * b - 4*a*c) h))/(4*a*a))) := by
/-Simplifying term with power 1 of root₂.
The RHS is expected simplification (Done by hand).
LHS indeed gets simplified to the expected term.
This lemma requires h' and also proof that 2*a ≠ 0, as it is being multiplied and divided by 2*a -/
  have h' : 2*a ≠ 0 := by
    simp only [ne_eq, mul_eq_zero, OfNat.ofNat_ne_zero, h', or_self, not_false_iff] 
  conv=>
    lhs
    simp only [sub_div,mul_div,mul_sub, add_mul]
    rw [←mul_div_mul_right (c:=2*a) (hc:=h')] /-divide and multiply by 2*a -/
    rw [←mul_div_mul_right (c:=2*a) (a:=b * ℝ.sqrt (b * b - 4 * a * c) h) (b := 2*a) (hc:=h')] /-divide and multiply by 2*a -/  
    simp [mul_left_comm (a:=b) (b:=2) (c:=a)]
    rw [mul_left_comm,mul_right_comm,mul_assoc]
    rw [←mul_left_comm (a:=a) (b:=b) (c:=b)]
    rw [mul_mul_mul_comm]
    rw [mul_rotate (a:=b) (b:=(ℝ.sqrt (b * b - 4 * a * c) h)) (c:=2*a)]
    rw [mul_rotate (a:=ℝ.sqrt (b * b - 4 * a * c) h) (b:=2*a) (c:=b)]
    simp only [←mul_assoc]
    simp [←two_mul_two]

private lemma l'₂ (a b c : ℝ) (h:(b*b - 4*a*c) ≥ 0): 
/-Simplifying term with power 2 of root₂.
The RHS is the expected hand simplified term.
The LHS gets simplified to expected term-/
  a *((-b * -b - ℝ.sqrt (b * b - 4 * a * c) h * -b -
          (-b * ℝ.sqrt (b * b - 4 * a * c) h -
            ℝ.sqrt (b * b - 4 * a * c) h * ℝ.sqrt (b * b - 4 * a * c) h)) /
                (2 * (2 * a * a))) = 
                  (2*a*b*b - 4*a*a*c + 2*a*b*ℝ.sqrt (b*b - 4*a*c) h)/(4*a*a) := by
                    conv=>  
                      lhs
                      rw [ℝ.sqrt_mul_self (b*b - 4*a*c) h]
                      simp only [mul_div,mul_add,mul_sub]
                      simp only [←mul_assoc]
                      simp [←two_mul_two]
                      rw [sub_eq_add_neg]
                      rw [neg_sub]
                      rw [sub_neg_eq_add]
                      rw [←add_assoc]
                      rw [add_rotate]
                      rw [add_rotate']
                      rw [add_rotate']
                      simp [←add_assoc]
                      rw [add_assoc]
                      rw[add_add_add_comm]
                      rw [← mul_rotate]
                      rw[mul_comm b a]
                      rw [←mul_two (n :=a * b * ℝ.sqrt (b * b - 4 * a * c) h)]
                      rw [sub_eq_add_neg (a * b * b)]
                      rw [← add_rotate]
                      rw [← mul_two]
                      rw [add_rotate']
                      rw[←add_assoc]
                      rw [←sub_eq_add_neg]
                      rw [mul_rotate (a:=a) (b:=4) (c:=a)]
                      rw [mul_rotate]
                      rw [mul_comm b 2,mul_mul_mul_comm]
                      rw [←mul_assoc]
                      rw [mul_comm (a * b * (ℝ.sqrt (b * b - 4 * a * c) h)) 2]
                      rw [←mul_assoc]
                      rw [←mul_assoc]

theorem root₂_is_root (a b c : ℝ) (h:(b^2 - 4*a*c) ≥ 0) (h': a≠0): a*(root₂ a b c h)^2 + b*(root₂ a b c h) + c = 0 := by
/-Proof that root₂ is actually the root of quadratic.
Essentially it is simplification using various theorems, and split into major 3 terms out of which two are bigger terms
and are simplified in private lemmas l'₁ (specifically pass h:= a ≠ 0 as it involves multiplication and addition of 2*a) and l'₂.
Once the major 2 terms are simplified, its rewritten and then ring_nf tactic is applied along with some more simplification theorems-/
  simp only [root₂, div_pow]
  simp only [pow_two, mul_left_comm, mul_sub, sub_mul] at h ⊢
  rw [l'₁ (h':=h')]
  rw [l'₂]
  ring_nf
  simp only [pow_two]
  simp [←mul_rotate (a:=a⁻¹*a⁻¹) (b:=a*a) (c:=c)]
  rw [mul_mul_mul_comm]
  rw[←one_div]
  rw [one_div_mul_cancel (h:=h')]
  rw [mul_one,one_mul]
  rw [neg_add_self]

end Quadratic
