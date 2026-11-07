module

public meta import Lean.Elab.Tactic.Doc
public meta import Lean.Elab.Tactic.Basic
public meta import Lean.Util.FoldConsts

public meta section

namespace Cx2026Groups

open Lean Elab Tactic Meta

private partial def checkTactics (allowed : Array String) (tokens : NameMap String)
    (stx : Syntax) : TacticM Unit := do
  let kind := stx.getKind
  if Parser.Tactic.Doc.isTactic (← getEnv) kind then
    let name := if kind == ``Lean.cdot then "·" else tokens.getD kind kind.toString
    unless allowed.contains name || allowed.contains kind.toString do
      throwErrorAt stx "Tactic '{name}' is outside this exercise's whitelist."
  stx.getArgs.forM (checkTactics allowed tokens)

-- These equality lemmas can be inserted by `rw`, `calc`, and congruence.
private def proofInfrastructure : Array Name :=
  #[``congrArg, ``congrFun, ``Eq.symm, ``Eq.trans, ``Eq.mp, ``Eq.mpr]

private def checkTheorems (allowed : Array Name) (allowSorry : Bool) (proof : Expr) : TacticM Unit := do
  let env ← getEnv
  let mut rejected := #[]
  for name in proof.getUsedConstants do
    unless allowed.contains name || proofInfrastructure.contains name || (allowSorry && name == ``sorryAx) do
      let isTheorem ← match env.find? name with
        | some (.thmInfo _) | some (.axiomInfo _) => pure true
        | some (.defnInfo info) => isProp info.type
        | some (.opaqueInfo info) => isProp info.type
        | _ => pure false
      if isTheorem then
        rejected := rejected.push (MessageData.ofConstName name)
  unless rejected.isEmpty do
    throwError "The proof uses results outside this exercise's theorem whitelist: {MessageData.joinSep rejected.toList ", "}"

/--
`course_proof tactics ["rw", "calc"] theorems [mul_assoc, mul_one] => ...` checks the
tactics written in the block, including nested tactic blocks, and checks the theorem
constants in the resulting proof. Fully qualified tactic syntax kinds are also accepted.
The theorem list names trusted results. Basic equality bookkeeping is allowed implicitly.
Include `"sorry"` in the tactic list when distributing an unfinished proof scaffold.
-/
elab "course_proof" " tactics " "[" tactics:str,* "]" " theorems " "[" theorems:ident,* "]"
    " => " body:tacticSeq : tactic => withMainContext do
  let allowedTactics := tactics.getElems.map (·.getString)
  let tokens ← Lean.Elab.Tactic.Doc.firstTacticTokens
  checkTactics allowedTactics tokens body.raw
  let allowedTheorems ← theorems.getElems.mapM fun name =>
    realizeGlobalConstNoOverloadWithInfo name
  let goals ← getUnsolvedGoals
  evalTactic body
  unless (← getUnsolvedGoals).isEmpty do
    throwError "The course proof did not close all goals."
  for goal in goals do
    let proof ← instantiateMVars (.mvar goal)
    if proof.hasExprMVar then
      throwError "The course proof still has unresolved metavariables."
    checkTheorems allowedTheorems (allowedTactics.contains "sorry") proof

end Cx2026Groups
