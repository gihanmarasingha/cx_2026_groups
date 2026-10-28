# Curriculum X 2026--27 Group Theory

This project is designed for students taking the Curriculum X course, _Leaning into Group Theory_.

Through this project, you will learn about the interactive theorem prover Lean and how to use it to
prove results in Group Theory. 

## Course website

The course website uses [Verso](https://verso.lean-lang.org/)'s literate
programming renderer. It turns the explanations and proofs in the course's
Lean files into readable pages with interactive proof states and hover information.
Build and preview it from the repository root:

```sh
lake build :literateHtml
python3 -m http.server 8000 --directory .lake/build/literate-html
```

Open <http://localhost:8000>. The first build compiles Verso and can take a while.
For the ordinary course library build, use `lake build`.

Write course explanations in module comments (`/-! ... -/`) alongside the Lean
code in `Cx2026Groups/`. Import each new week in `Cx2026Groups.lean` so it is
included in the course library and website. The overview in `Cx2026Groups.lean`
is the home page. Edit `literate.toml` to set page titles and navigation order;
new course modules are included automatically. Only the course library is
published, so Mathlib and Lean dependency sources are not rendered as course pages.
See the [Verso literate programming guide](https://verso.lean-lang.org/doc/latest/)
for additional rendering options.

Verso is pinned to the same release as `lean-toolchain`. When upgrading Lean,
update the Verso revision in `lakefile.toml` to match, run `lake update`, and
rebuild both the library and website. Commit `lake-manifest.json` to keep
builds reproducible.

GitHub Actions builds the library and website on pushes and pull requests.
Pushes to the default branch also publish `.lake/build/literate-html` to
GitHub Pages. Set **Settings → Pages → Build and deployment → Source** to
**GitHub Actions** when enabling Pages for the repository.

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
