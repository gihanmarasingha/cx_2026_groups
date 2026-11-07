/-
Copyright (c) 2026 Gihan Marasingha. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Gihan Marasingha
-/

module

import Mathlib.Algebra.Group.Int.Defs
import Mathlib.Tactic.NormNum.Core

set_option doc.verso.module true
set_option doc.verso.suggestions false

/-!
# Calculation-style proofs

Proofs can be laid out as a series of equations, each with a justification or reason. We'll see how
to do this in Lean.
-/

set_option linter.unusedTactic false

variable (x y z : ℤ)

/-!
Suppose we have the hypotheses `h1 : x = 5 * y` and `h2 : y = 2` and we wish to prove `3 * x - 4 * y
= 22`. In traditional mathematics, we might write this as:

$$`\begin{aligned}
3 x - 4y &= 3(5y) - 4y && \text{by h1}\\
& = 3(5 \cdot 2)  - 4 \cdot 2 && \text{by h2}  \\
&= 22 && \text{by arithmetic} 
\end{aligned}`

Though you might not typically give a justification of each line in a handwritten proof.

Here is the same proof written as a Lean {tactic}`calc` block.
-/

example (h1 : x = 5 * y) (h2 : y = 2) : 3 * x - 4 * y = 22 := by
  calc
    3 * x - 4 * y = 3 * (5 * y) - 4 * y := by rw [h1]
    _ = 3 * (5 * 2) - 4 * 2 := by rw [h2]
    _ = 22 := by norm_num

/-!
## Exercise 2.1 

Interact with the proof above by examining the goal immediately after each `by` command. How does
the goal relate to the code? Can you see how each tactic following the `by` command proves the goal?
-/

/-!
## Exercise 2.2

Complete the {tactic}`calc` proof below, replacing each {tactic}`sorry` with a tactic.
-/

example (h1 : x = 4) (h2 : y = 2 * x - 1) : 5 * x - 3 * y = -1 := by
  calc
    5 * x - 3 * y = 5 * x - 3 * (2 * x - 1) := by sorry
    _ = 5 * 4 - 3 * (2 * 4 - 1) := by sorry
    _ = -1 := by sorry

/-!
## Exercise 2.3

Complete the {tactic}`calc` proof below. This time, you'll need to supply the intermediate lines of
proof and the justification for each line.

Ensure you follow the syntax closely. Each `calc` line except the first begins with an `_`
(underscore) character and an equals sign. The justification for each line follows `:= by`.  

-/

example (h1 : x = 3) (h2 : x + y = 5) (h3 : y = 2 * z) : (x + 2 * z) + 2 * x = 11  := by
  calc
     x + 2 * z + 2 * x = sorry := by sorry
     _ = 11 := by sorry
  done

/-!
## Calculations with associativity

Each step in a {tactic}`calc` block has its own target. We can use `add_assoc` to justify a
regrouping step, then rewrite using a hypothesis in the next step.
-/

example (h1 : x = 3) (h2 : y + z = 8) : (x + y) + z = 11 := by
  calc
    (x + y) + z = x + (y + z) := by rw [add_assoc x y z]
    _ = x + 8 := by rw [h2]
    _ = 3 + 8 := by rw [h1]
    _ = 11 := by norm_num

/-!
The `_` at the start of a line stands for the right-hand side of the previous line. Before
writing a justification, read that line as a separate equality and decide which rewrite proves it.

## Exercise 2.4

Complete each justification. One step uses `add_assoc` backwards.
-/

example (h1 : x + y = 6) (h2 : z = 4) : x + (y + z) = 10 := by
  calc
    x + (y + z) = (x + y) + z := by sorry
    _ = 6 + z := by sorry
    _ = 6 + 4 := by sorry
    _ = 10 := by sorry

/-!
## Exercise 2.5

Supply the missing intermediate expressions as well as the justifications. First regroup to
expose `y + z`, then use `h2`, then `h1`, and finish with arithmetic.
-/

example (h1 : x = 5) (h2 : y + z = 7) : (x + y) + z = 12 := by
  calc
    (x + y) + z = x + (y + z) := by sorry
    _ = sorry := by sorry
    _ = sorry := by sorry
    _ = 12 := by sorry

/-!
## Exercise 2.6

Write your own `calc` proof.
-/

example (w : ℤ) (h1 : x + y = z) (h2 : y + w = 4) : z + w = x + 4 := by
  sorry
  done

/-!
## Exercise 2.7

Use a `calc` block to regroup four terms. Aim for one use of `add_assoc` per line. Which
intermediate expression lets you finish in two steps?
-/

example (w : ℤ) : ((w + x) + y) + z = w + (x + (y + z)) := by
  sorry
  done
