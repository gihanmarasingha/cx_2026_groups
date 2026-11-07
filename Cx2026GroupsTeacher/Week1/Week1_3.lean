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
# Introducing hypotheses with have

Another way to prove a theorem is by introducing and using auxiliary results.

Consider again a situation where we have the hypotheses `h1`:$`x = 5y`, `h2`:$`y = 2` and we wish to
prove $`3x - 4y = 22`. We can reason as follows:

We have `h3`:$`4y = 8`, from `h2`. We have `h4`:$`3x = 30` from `h1` and `h2`. Combining `h3` and
`h4` gives $`3x - 4y = 22`.
-/

#import_bumps

set_option linter.unusedTactic false

variable (x y z : ℤ)

/-!
The same proof can be written in Lean as follows. The {tactic}`have` tactic is explained below. 
-/

example (h1 : x = 5 * y) (h2 : y = 2) : 3 * x - 4 * y = 22 := by
  have h3 : 4 * y = 8 := by
    rw [h2]
    norm_num
  have h4 : 3 * x = 30 := by
    rw [h1, h2]
    norm_num
  rw [h3, h4]
  norm_num
  done

/-!
The {tactic}`have` tactic allows you to introduce a new hypothesis into the context. The line
```
have  h3 : 4 * y = 8 := by
```
introduces a proof of `4 * y = 8` into the context and calls that proof `h3`. The proof itself
follows the word `by`. In our case, we used `rw [h2]` to rewrite `4 * y = 8` as `4 * 2 = 8`. Then we
use {tactic}`norm_num` to perform the arithmetic.

Note I'm using the syntax `rw [h1, h2]` has the same result as doing `rw [h1]` followed by `rw
[h2]`.
-/

/-!

## Exercise 3.1

* In the proof above, what happens if you replace `rw [h3, h4]` with `rw [h4, h3]`? Will the proof
still work? Think about it before you try.
* What if you replace `rw [h1, h2]` with `rw [h2, h1]`?
-/

/-!

## Exercise 3.2

Complete the proof below.
-/

example (h1 : x = 50) (h2 : y = 2 * x - 70) : 5 * y - 3 * x = 0 := by
  have h3 : 3 * x = 150 := by
    rw [h1]  
    norm_num
  have h4 : 5 * y = 150 := by
    rw [h2, h1]
    norm_num
  rw [h3, h4]
  norm_num
  done

/-!
## Auxiliary facts and associativity

An auxiliary fact can record a useful grouped sum. We first prove it with {tactic}`have`, then
use its name in a later rewrite. The proof after `have` has its own target; once that proof is
complete, Lean returns to the main target with the new fact available.
-/

example (h1 : x + y = 7) (h2 : z = 3) : x + (y + z) = 10 := by
  have h3 : (x + y) + z = 10 := by
    rw [h1, h2]
    norm_num
  rw [← add_assoc x y z]
  rw [h3]

/-!
Here `h3` records a fact about `(x + y) + z`. We regroup the main target before using `h3`.

## Exercise 3.3

Complete the auxiliary fact, then use `add_assoc` and `h3` to finish the main proof.
-/

example (h1 : y = 4) (h2 : z = 5) : (x + y) + z = x + 9 := by
  have h3 : y + z = 9 := by
    rw [h1, h2]
    norm_num
  rw [add_assoc, h3]
  done

/-!
## Using calc inside have

The proof of an auxiliary fact can itself be a calculation. In this example we regroup the
expression inside `have`, and then use the resulting fact in the main calculation.
-/

example (h1 : y + z = 6) (h2 : x = 2) : ((x + y) + z) + x = 10 := by
  have h3 : (x + y) + z = 8 := by
    calc
      (x + y) + z = x + (y + z) := by rw [add_assoc x y z]
      _ = x + 6 := by rw [h1]
      _ = 8 := by rw [h2]; norm_num
  calc
    ((x + y) + z) + x = 8 + x := by rw [h3]
    _ = 10 := by rw [h2]; norm_num

/-!
## Exercise 3.4

Complete both calculations. The first proves a fact that the second can reuse.
-/

example (h1 : x + y = 5) (h2 : z = 2) : (x + (y + z)) + z = 9 := by
  have h3 : x + (y + z) = 7 := by
    calc
      x + (y + z) = (x + y) + z := by rw [add_assoc]
      _ = 5 + z := by rw [h1]
      _ = 7 := by rw [h2]; norm_num
  calc
    (x + (y + z)) + z = 7 + z := by rw [h3]
    _ = 9 := by rw [h2]; norm_num

/-!
## Exercise 3.5

Choose names and statements for two auxiliary facts: one giving the value of `x + y`, and one
giving the value of `z + w`. Use those facts in a `calc` proof, regrouping with `add_assoc` first.
-/

example (w : ℤ) (h1 : x = 2) (h2 : y = 3) (h3 : z = 4) (h4 : w = 5) :
    ((x + y) + z) + w = 14 := by
  rw [h1, h2, h3, h4]
  norm_num
  done

/-!
## Exercise 3.6

You may need a backward rewrite in the following.

-/

example (w : ℤ) (h1 : x + y = z) (h2 : y + w = 4) :
    (z + w) + (z + w) = (x + 4) + (x + 4) := by
  have h3 : z + w = x + 4 := by
    rw [←h1, add_assoc, h2]
  rw [h3]
  done

