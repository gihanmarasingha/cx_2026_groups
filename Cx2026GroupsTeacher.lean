import Cx2026GroupsTeacher.Week1
import Cx2026GroupsTeacher.Week2

set_option doc.verso.module true

/-!
# Leaning into Group Theory

Welcome to the Curriculum X 2026–27 course. These notes introduce interactive
theorem proving with Lean through examples and exercises in group theory.

Start with **Week 1** in the navigation menu. Read the explanations alongside
the Lean code; hover over code for more information and select a tactic to
inspect the proof state. To work through the examples yourself, open the
corresponding file in VS Code with the Lean extension (or use NeoVim with the
Lean plugin).

## Intended learning outcomes

By the end of this project, you will be able to:

* Describe the purpose and function of an interactive theorem prover. Differentiate between a
  theorem prover and its language.
* Explain how Lean represents mathematical expressions, mathematical statements, and proofs of
  mathematical statements.
* Explain the meaning of the terms target, hypothesis and goal in traditional and Lean proofs.
* Identify the goals, target and hypotheses at every stage of a proof, whether traditional or Lean
  style.
* Prove results in group theory using chains of equations with each equation justified by the
  application of a rule. Represent such a proof in Lean using the {tactic}`calc` tactic.
* Distinguish between forward and backward reasoning and to describe whether a given proof technique
  operates in a forwards or backwards direction.
* Use Lean tactics to modify proof goals. Explain the effect of Lean tactics on proof goals. These
  tactics include
    * The {tactic}`rw` tactic for rewriting a target or hypothesis using a theorem.
    * The {tactic}`apply` tactic for applying a theorem or hypothesis in a situation where its
    conclusion matches the target.
    * The {tactic}`simp` tactic for automatically applying rewrite rules.
    * The {tactic}`show` tactic to re-express the target in a definitionally equivalent form.
    * The {tactic}`change` tactic to re-express a hypothesis or the target in a definitionally
    equivalent form.
    * The {tactic}`have` tactic to prove a statement and add it to the list of hypotheses.
    * The {tactic}`intro` tactic to introduce a hypothesis or variable when the target is an
    implication or a universally-quantified statement.
    * The {tactic}`rcases` tactic to (recursively) deconstruct a hypothesis or term.
    * The {tactic}`use` tactic to specify the witness in the proof of an existentially-quantified
    statement.
-/
