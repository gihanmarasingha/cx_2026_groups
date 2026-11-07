/-
Copyright (c) 2026 Gihan Marasingha. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Gihan Marasingha
-/

module

public import Mathlib.Algebra.Group.Defs
meta import Cx2026GroupsTools
import Mathlib.Tactic.NormNum.Core
import Mathlib.Tactic.Linter.MinImports

set_option doc.verso.module true
set_option doc.verso.suggestions false

/-!
# Abstract Groups
-/

#import_bumps

set_option linter.unusedTactic false


/-!

## Group properties

In Mathlib, Lean's mathematical library, `Group` is a kind of mathematical structure. It satisfies
associativity of multiplication, the left and right identity properties, and the multiplicative
identity property.
-/

namespace cx_2026

variable (G : Type*) [Group G] (x y z : G)

#print Group -- This shows the definition of `Group`. Remove it in the student version.

/-!

### Associativity

The axiom that {lit}`(a * b) * c = a * (b * c)` is called {name}`mul_assoc` in Mathlib.

Below, we prove `(x * y) * z = x * (y * z)` using a rewrite with `mul_assoc a b c`. Recall, the
{tactic}`rw` tactic will replace `(x * y) * z` in the target with `x * (y * z)`. The target becomes
`x * (y * z) = x * (y * z)`, which the {tactic}`rw` tactic immediately recognises as being true.
-/

NewTactic rw
NewTheorem mul_assoc

example : (x * y) * z = x * (y * z) := by
  rw [mul_assoc x y z]

/-!

### Identity element

For groups written multiplicatively, the identity element in Lean is denoted `1`. Mathlib presents
two axioms for multiplication by the identity: {name}`mul_one`, which states `a * 1 = a` and
{name}`one_mul`, which states `1 * a = a`.
-/

NewTheorem mul_one one_mul

example : x * 1 = x := by
  rw [mul_one]

example : 1 * x = x := by
  rw [one_mul]

/-!

### Multiplicative inverse

The multiplicative inverse axiom, called {name}`inv_mul_cancel` in Mathlib, states `x⁻¹ * x = 1`.

Type `⁻¹` as `\-1` followed by space.
-/

NewTheorem inv_mul_cancel

example : x⁻¹ * x = 1 := by
  rw [inv_mul_cancel]


/-!
## Exercise 0.1

Your task it to prove that `(y⁻¹ * x⁻¹) * (x * y) = 1`. I have set out a {tactic}`calc`-style proof.
You need to fill in each equation line and give a justification in the `by sorry` pat of each line.
Each justification can be accomplished using a `rw`.
-/

NewTactic calc

public section

NewTactic sorry done

lemma inv_mul_inv_mul_mul_cancel : (y⁻¹ * x⁻¹) * (x * y) = 1 := by
  course_proof =>
  calc
    (y⁻¹ * x⁻¹) * (x * y) = y⁻¹ * (x⁻¹ * (x * y)) := by sorry
    _ = sorry := by sorry
    _ = sorry := by sorry
    _ = sorry := by sorry
    _ = 1 := by sorry
  done

-- REMOVE
example : (y⁻¹ * x⁻¹) * (x * y) = 1 := by
  calc
    (y⁻¹ * x⁻¹) * (x * y) = y⁻¹ * (x⁻¹ * (x * y)) := by rw [mul_assoc]
    _ = y⁻¹ * ((x⁻¹ * x) * y) := by rw [mul_assoc]
    _ = y⁻¹ * (1 * y) := by rw [inv_mul_cancel]
    _ = y⁻¹ * y := by rw [one_mul]
    _ = 1 := by rw [inv_mul_cancel]
  done
-- REMOVE

/-!
## Exercise 0.2

As an alternative, write a proof of this result using a sequence of {tactic}`rw` tactics. You may
need to use a backward rewrite. Recall that you can apply an equation `h : a = b` backward using `rw
[←h]`, where `←` is typed as `\l`.

Do you prefer the `rw` version or the `calc` version? What are the advantages and disadvantages of
each approach?
-/

example : (y⁻¹ * x⁻¹) * (x * y) = 1 := by
  sorry

-- REMOVE
example : (y⁻¹ * x⁻¹) * (x * y) = 1 := by
  rw [mul_assoc]
  rw [←mul_assoc x⁻¹]
  rw [inv_mul_cancel]
  rw [one_mul]
  rw [inv_mul_cancel]
-- REMOVE


/-!
## Exercise 0.3



-/

section

local NewTactic sorry

lemma inv_inv : x⁻¹⁻¹ = x := by
  course_proof =>
    calc
      x⁻¹⁻¹ = x⁻¹⁻¹ * 1 := by rw [mul_one]
      _ = x := by sorry

end

end

end cx_2026 
