/-
Copyright (c) 2026 Gihan Marasingha. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Gihan Marasingha
-/

import Mathlib.Tactic.Linarith

/-!
# An introduction to interactive theorem proving with Lean

In this file, you will learn how to use the `rw` (rewrite) tactic to change the target of a proof
goal.
-/

variable (x y : ℤ)

example (h1 : x = 5 - 2 * y) (h2 : y = 10 - 3 * x) : x = 3 := by
  rw [h1]
  rw [h2]
  linarith



#min_imports
