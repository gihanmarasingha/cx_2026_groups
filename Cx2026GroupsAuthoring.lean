module

public meta import Lean.Elab.Command

public meta section

/--
Check the following command in the Teacher lesson and omit it from the exported
Student lesson. Put the marker before a complete worked example or diagnostic.
The exporter reads the parsed syntax before the macro expands.
-/
syntax (name := teacherOnly) "teacher_only" " in " command : command

macro_rules
  | `(teacher_only in $cmd:command) => pure cmd
