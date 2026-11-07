# Curriculum X 2026--27 Group Theory

This project is designed for students taking the Curriculum X course, _Leaning into Group Theory_.

Through this project, you will learn about the interactive theorem prover Lean and how to use it to
prove results in Group Theory. 

## Run in GitHub Codespaces

Open this repository (or your own fork), select **Code → Codespaces → Create
codespace**, and wait for setup to finish. The container installs Lean and the
Lean VS Code extension, downloads precompiled artifacts for the Mathlib modules
imported by the course, and runs
`lake build` using the project's pinned dependencies.

Start with [Week 1.0: Getting started with Codespaces](Cx2026Groups/Week1/Week1_0.lean)
for instructions on checking proofs, working on exercises, previewing the course
website, and saving your work.

## Intended Learning Outcomes

By the end of this project, you will be able to:

* Describe the purpose and function of an interactive theorem prover. Differentiate between a
  theorem prover and its language.
* Explain how Lean represents mathematical expressions, mathematical statements, and proofs of
  mathematical statements.
* Explain the meaning of the terms target, hypothesis and goal in traditional and Lean proofs.
* Identify the goals, target and hypotheses at every stage of a proof, whether traditional or Lean
  style.
* Prove results in group theory using chains of equations with each equation justified by the
  application of a rule. Represent such a proof in Lean using the `calc` tactic.
* Distinguish between forward and backward reasoning and to describe whether a given proof technique
  operates in a forwards or backwards direction.
* Use Lean tactics to modify proof goals. Explain the effect of Lean tactics on proof goals. These
  tactics include
    * The `rewrite` (or `rw` for short) tactic for rewriting a target or hypothesis using a
      theorem.
    * The `apply` tactic for applying a theorem or hypothesis in a situation where its conclusion
      matches the target.
    * The `simp` tactic for automatically applying rewrite rules.
    * The `show` tactic to re-express the target in a definitionally equivalent form.
    * The `change` tactic to re-express a hypothesis or the target in a definitionally equivalent
      form.
    * The `have` tactic to prove a statement and add it to the list of hypotheses.
    * The `intro` tactic to introduce a hypothesis or variable when the target is an implication or
      a universally-quantified statement.
    * The `rcases` tactic to (recursively) deconstruct a hypothesis or term.
    * The `use` tactic to specify the witness in the proof of an existentially-quantified statement. 

## Maintaining this project

Student files are in `Cx2026Groups/`; teacher copies are in
`Cx2026GroupsTeacher/`. The public website renders only the student library.
To build a local website containing both versions, run
`python3 scripts/build_teacher_site.py`, then preview it with
`python3 -m http.server 8001 --bind 127.0.0.1 --directory .lake/build/literate-html-teacher`.
Open <http://localhost:8001>.

See [Project maintenance](project_maintenance.md) for information for the project author on how to
work with Verso, how some hacks were used to fix issues with Verso, and how to maintain the code
when upgrading to a later version of Lean and Mathlib.
and instructions for upgrading Lean, Mathlib, and Verso.

