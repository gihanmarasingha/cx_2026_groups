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
# Rewriting

In this file, you will learn how to use the {tactic}`rw` (rewrite) tactic to change the target of a
proof goal.
-/

#import_bumps

set_option linter.unusedTactic false

/-!
The `variable` command introduces variables that may be used in subsequent definitions,
examples and theorems. 
-/

variable (x y : ℤ)

/-!
## Rewriting the target

In this example, we prove that if $`x = 5y` and $`y = 2`, then $`3x - 4y = 22`.

The *target* at the start of the proof is to demonstrate that $`3x - 4y = 22`. We begin with the
named *hypotheses* `h1 : x = 5 * y` and `h2 : y =  2`.

At every stage in the proof, the *goal* consists of the target and the set of hypotheses.
-/

example (h1 : x = 5 * y) (h2 : y = 2) : 3 * x - 4 * y = 22 := by
  rw [h1]
  rw [h2]
  norm_num
  done

/-!
The first line of the tactic block is `rw [h1]`. It rewrites the target by replacing every
occurrence of the left-hand side of `h1` with the right-hand side of `h1`.

In this case, `h1 : x = 5 * y`. So `rw [h1]` replaces each occurrence of `x` in the target with `5 *
y`

That is `rw [h1]` has the effect of changing the target to `3 * (5 * y) - 4 * y = 22`.

Then `rw [h2]` changes the target to `3 * (5 * 2) - 4 * 2 = 22`

The tactic {tactic}`norm_num` is used to prove arithmetic goals. 
-/

/-!

## Exercise 1.1

What happens if you change the order of `rw [h1]` and `rw [h2]`? What is the target after `rw [h2]`?
What about after `rw [h1]`? Test your conjecture by editing the code above (in Visual Studio Code)
and reading the messages in the InfoView window.
-/

/-!

## Exercise 1.2

In the examples below, replace the {tactic}`sorry` with {tactic}`rw` tactics and a final `norm_num`.
Before you start, think about how each {tactic}`rw` line will change the target.
-/

variable (z : ℤ)

example (h1 : x = 3 * z) (h2 : y = 9) (h3 : z = 8 - y) : 8 * x + 4 *y + 2 * z = 10 := by
  rw [h1, h3, h2]
  norm_num
  done

example (h1 : x = 3) (h2 : y = 4 * x ^ 2) : y = 36 := by
  rw [h2, h1]
  norm_num
  done

/-!
## Rewriting backwards

Sometimes the right-hand side of an equality is the expression we want to replace. Writing
`rw [← h]` uses the equality `h` from right to left. Type `\l` followed by a space to enter `←`.

Here `h1` tells us that `x + y = z`. We replace `z` with `x + y`, then use `h2`.
-/

example (h1 : x + y = z) (h2 : x + y = 7) : z + 2 = 9 := by
  rw [← h1, h2]
  norm_num

/-!
## Exercise 1.3

Use a backwards rewrite, followed by a forwards rewrite and `norm_num`.
-/

example (h1 : x + y = 6) (h2 : x + y = z) : 2 * z = 12 := by
  rw [← h2, h1]
  norm_num
  done

/-!
## Associativity of addition

We can rewrite using named theorems as well as hypotheses. The theorem `add_assoc x y z` states
that `(x + y) + z = x + (y + z)`. This is the *associative law*: changing the grouping of a sum
does not change its value. It does not change the order of the terms.

Lean reads `x + y + z` as `(x + y) + z`. In contrast, parentheses in `x + (y + z)` specify a
different grouping. To use a hypothesis about `y + z`, we may first need to regroup the sum.
-/

example (h : y + z = 4) : (x + y) + z = x + 4 := by
  rw [add_assoc x y z]
  rw [h]

/-!
The first rewrite changes the target to `x + (y + z) = x + 4`. Now `rw [h]` can find `y + z`.
Why would `rw [h]` fail if we tried it before regrouping?

We can also use `add_assoc` backwards to group the first two terms.
-/

example (h : x + y = 6) : x + (y + z) = 6 + z := by
  rw [← add_assoc x y z, h]

/-!
## Exercise 1.4

Use `add_assoc` to expose the sum in the hypothesis, then rewrite using that hypothesis.
-/

example (h : y + z = 9) : (x + y) + z = x + 9 := by
  rw [add_assoc x y z]
  rw [h]
  done

example (h : x + y = 9) : x + (y + z) = 9 + z := by
  rw [←add_assoc x y z] 
  rw [h]
  done

/-!
## Exercise 1.5

Combine regrouping, rewriting with both hypotheses, and arithmetic. Predict the target after
each rewrite before checking it in the InfoView.
-/

example (h1 : x = 3) (h2 : y + z = 8) : (x + y) + z = 11 := by
  rw [add_assoc, h1, h2]
  norm_num
  done

/-!
## Exercise 1.6

Reassociate a sum of four terms. You will need two uses of `add_assoc`. Give its arguments
explicitly so that each rewrite changes the grouping you intend.
-/

example (w : ℤ) : ((w + x) + y) + z = w + (x + (y + z)) := by
  rw [add_assoc (w + x) y z]
  rw [add_assoc w x (y + z)]
  done
