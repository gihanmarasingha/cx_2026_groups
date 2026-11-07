/-
Copyright (c) 2026 Gihan Marasingha. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Gihan Marasingha
-/

module

import Mathlib.Algebra.Group.Int.Defs
import Mathlib.Tactic.NormNum.Core
import Mathlib.Tactic.Linter.MinImports

set_option doc.verso.module true
set_option doc.verso.suggestions false

/-!
# Abstract Groups
-/

--#import_bumps

set_option linter.unusedTactic false


/-!

## Group properties

In Lean's mathematical library, `Group` is a kind of mathematical structure. It satisfies
associativity of multiplication, the left and right identity properties, and the multiplicative
identity property.
-/

namespace cx_2026

variable (G : Type*) [Group G] (x y z : G)

#print Group -- remove this in student version

example : (x * y) * z = x * (y * z) := by
  rw [mul_assoc]

example : x * 1 = x := by
  rw [mul_one]

example : 1 * x = x := by
  rw [one_mul]

/-!
Type `⁻¹` as `\-1` followed by space.
-/

example : x⁻¹ * x = 1 := by
  rw [inv_mul_cancel]


/-!
Let's prove some basic results
-/

example : (y⁻¹ * x⁻¹) * (x * y) = 1 := by
  calc
    (y⁻¹ * x⁻¹) * (x * y) = y⁻¹ * (x⁻¹ * (x * y)) := by sorry
    _ = sorry := by sorry
    _ = sorry := by sorry
    _ = sorry := by sorry
    _ = 1 := by sorry


lemma inv_inv : x⁻¹⁻¹ = x := by 
  calc
    x⁻¹⁻¹ = x⁻¹⁻¹ * 1 := by rw [mul_one]
    _ = x := by sorry

end cx_2026 
