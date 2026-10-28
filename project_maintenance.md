# Project maintenance

## Temporary Verso backport

The course uses Lean and Mathlib 4.35.0. Verso's official `v4.35.0` release
fails to render some files using `module`, reporting “missing data file for
module …”. Upstream [PR #1043](https://github.com/leanprover/verso/pull/1043)
fixes the import handling, but was merged after that release.

A **backport** applies a newer fix to an older software version. We use
[Taylor Dupuy's backport](https://github.com/tdupu/verso/commit/6c1b93307c6637ab5d0ae1cd9560a7e55fd6680f)
of that fix onto Verso 4.35.0. `lakefile.toml` pins the fork to this exact
commit so builds are reproducible. This is a temporary third-party dependency;
it does not automatically receive later fixes. The request for an official
4.35 backport is [issue #1052](https://github.com/leanprover/verso/issues/1052).

## Upgrading Lean and Mathlib

1. Work on a branch. Choose the desired Mathlib release and set `lean-toolchain`
   to the Lean version required by that release. Update Mathlib's `rev` in
   `lakefile.toml` accordingly.
2. Find an official Verso release or immutable revision compatible with that
   Lean version and containing PR #1043. Once available for the chosen version,
   change Verso's Git URL back to `https://github.com/leanprover/verso.git` and
   replace the backport revision. Check its `lean-toolchain`; avoid following
   `main` blindly. Remove the temporary-backport comment in `lakefile.toml`.
3. Run `lake update`, then `lake exe cache get` to fetch Mathlib's prebuilt
   artifacts. Fix any course proofs or configuration affected by upstream changes.
4. Run `lake build` and `lake build :literateHtml`. Preview
   `.lake/build/literate-html` and check the prose, navigation, and proof states.
5. Update this note and the README, commit `lean-toolchain`, `lakefile.toml`,
   `lake-manifest.json`, and any course changes, and confirm that GitHub Actions
   builds and deploys successfully.

Keep `module` in course files; the backport needs no special changes to their
content. Adapting proofs to newer Mathlib APIs is a separate part of the upgrade.
Do not edit generated files under `.lake/` or patch dependencies there: such
changes would not be reproduced in a fresh checkout or on GitHub Actions.
