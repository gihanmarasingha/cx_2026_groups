module

public meta import Lean.Elab.BuiltinTerm
public meta import Lean.Elab.Tactic.Doc
public meta import Lean.Elab.Tactic.Basic
public meta import Lean.ScopedEnvExtension
public meta import Lean.Util.FoldConsts

public meta section

/-- Check ordinary `by` blocks against the current course whitelist. -/
register_option course.checkProofs : Bool := {
  defValue := false
  descr := "check ordinary `by` blocks against the current course whitelist"
}

namespace Cx2026Groups

open Lean Elab Command Tactic Meta

private inductive WhitelistEntry where
  | tactic (name : String)
  | theoremName (name : Name)
  deriving Inhabited

private structure Whitelist where
  tactics : Array String := #[]
  theorems : Array Name := #[]
  deriving Inhabited

private initialize courseWhitelist : SimpleScopedEnvExtension WhitelistEntry Whitelist ←
  registerSimpleScopedEnvExtension {
    initial := {}
    addEntry := fun rules entry => match entry with
      | .tactic name => { rules with tactics := rules.tactics.push name }
      | .theoremName name => { rules with theorems := rules.theorems.push name }
  }

private def tacticLabel (tokens : NameMap String) (kind : Name) : String :=
  if kind == ``Lean.cdot then "·" else tokens.getD kind kind.toString

/-- Allow these tactics in subsequent `course_proof` blocks. Use quotes for symbolic names.
`local NewTactic` limits the addition to the current section or namespace. -/
elab locality:("local ")? "NewTactic" names:(ppSpace colGt (rawIdent <|> str))+ : command => do
  let kind := if locality.isSome then AttributeKind.local else AttributeKind.global
  let tokens ← Lean.Elab.Tactic.Doc.firstTacticTokens
  let some category := Parser.getParserCategory? (← getEnv) `tactic
    | throwError "The tactic parser is unavailable."
  let tactics ← names.mapM fun stx => do
    let name := stx.isStrLit?.getD stx.getId.toString
    unless category.kinds.toList.any (fun (syntaxKind, _) =>
        name == tacticLabel tokens syntaxKind || name == syntaxKind.toString) do
      throwErrorAt stx "Unknown tactic '{name}'."
    pure name
  for name in tactics do
    courseWhitelist.add (.tactic name) kind

/-- Allow these results in subsequent `course_proof` blocks.
`local NewTheorem` limits the addition to the current section or namespace. -/
elab locality:("local ")? "NewTheorem" names:(ppSpace colGt ident)+ : command => do
  let kind := if locality.isSome then AttributeKind.local else AttributeKind.global
  let theorems ← names.mapM fun name => liftCoreM <| realizeGlobalConstNoOverloadWithInfo name
  for name in theorems do
    courseWhitelist.add (.theoremName name) kind

private partial def checkTactics (allowed : Array String) (tokens : NameMap String)
    (stx : Syntax) : TacticM Unit := do
  let kind := stx.getKind
  if Parser.Tactic.Doc.isTactic (← getEnv) kind then
    let name := tacticLabel tokens kind
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

private def evalCourseProof (rules : Whitelist) (body : Syntax) : TacticM Unit := withMainContext do
  let tokens ← Lean.Elab.Tactic.Doc.firstTacticTokens
  checkTactics rules.tactics tokens body
  let goals ← getUnsolvedGoals
  -- The syntax check already covers nested `by` blocks, and the proof check covers their results.
  withOptions (course.checkProofs.set · false) (evalTactic body)
  unless (← getUnsolvedGoals).isEmpty do
    throwError "The course proof did not close all goals."
  for goal in goals do
    let proof ← instantiateMVars (.mvar goal)
    if proof.hasExprMVar then
      throwError "The course proof still has unresolved metavariables."
    checkTheorems rules.theorems (rules.tactics.contains "sorry") proof

/-- Check the written tactics and resulting theorem references against the current whitelist.
Use `NewTactic` and `NewTheorem` to add entries. Basic equality bookkeeping is allowed implicitly. -/
elab "course_proof" " => " body:tacticSeq : tactic => do
  evalCourseProof (courseWhitelist.getState (← getEnv)) body.raw

/-- Check a single proof against explicit lists instead of the accumulated whitelist. -/
elab "course_proof" " tactics " "[" tactics:str,* "]" " theorems " "[" theorems:ident,* "]"
    " => " body:tacticSeq : tactic => withMainContext do
  let allowedTheorems ← theorems.getElems.mapM fun name =>
    realizeGlobalConstNoOverloadWithInfo name
  evalCourseProof { tactics := tactics.getElems.map (·.getString), theorems := allowedTheorems } body.raw

/-- Route a standard `by` block through `course_proof` when course checking is enabled. -/
@[term_elab Lean.Parser.Term.byTactic]
def elabCourseBy : Term.TermElab := fun stx expectedType? => do
  unless course.checkProofs.get (← getOptions) do
    throwUnsupportedSyntax
  let body : TSyntax ``Parser.Tactic.tacticSeq := ⟨stx[1]⟩
  let checkedBody ← `(tacticSeq| course_proof => $body)
  Term.elabByTactic (stx.setArg 1 checkedBody.raw) expectedType?

end Cx2026Groups
