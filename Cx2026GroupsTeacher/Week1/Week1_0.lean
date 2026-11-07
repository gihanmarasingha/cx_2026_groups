module

set_option doc.verso.module true
set_option doc.verso.suggestions false

/-!
# Getting started with GitHub Codespaces

GitHub Codespaces gives you VS Code in a browser, with Lean running on a remote
computer. You need a GitHub account and an internet connection; the project
installs Lean and its dependencies for you.

## Create your codespace

1. Sign in to GitHub and open
   [the course repository](https://github.com/gihanmarasingha/cx_2026_groups).
   To keep your own exercise solutions, first use **Fork** to create a copy in
   your account, then open your fork.
2. Select the green **Code** button, then **Codespaces**, then **Create codespace
   on main** (or the branch you are using). The configuration requests a machine
   with at least four cores and 8 GB of memory.
3. Wait for setup to finish. The first start downloads the Lean version specified
   in `lean-toolchain`, fetches the precompiled Mathlib modules used by the course,
   and builds the course. This can take several minutes. Leave setup running
   until it completes.
4. The browser opens VS Code with the Lean extension installed. This file,
   `Cx2026Groups/Week1/Week1_0.lean`, opens automatically.

## Run Lean and inspect proofs

Lean checks a file as you edit it. There is no separate Run button for a proof.
Scroll to the examples at the end of this file. Click inside the proof after
`by` and move the cursor through its lines to see the goals in **Lean Infoview**.
If that panel is hidden, open the command palette with **F1**, search for
**Lean: Toggle Infoview**, and select it.

The `#eval` command evaluates an expression; its result appears in the Infoview
when you place the cursor on that line. A theorem or `example` instead asks Lean
to check a proof. Try changing the right-hand side of the example from `4` to
`5`: Lean reports an error because the proof no longer establishes the claim.
Undo the change before continuing.

Open `Cx2026Groups/Week1/Week1_1.lean` in the Explorer to begin the rewriting exercises,
then continue with `Week1_2.lean` and `Week1_3.lean`. Replace `sorry` with your
proofs. A warning that a declaration uses `sorry` marks an unfinished exercise.
-/

#eval (2 + 2 : Nat)

example : (2 : Nat) + 2 = 4 := by
  rfl

/-!

## Save your work and return later

Save files with **Ctrl+S** (or **Cmd+S** on macOS). Saving updates the
codespace's disk. To keep a copy on GitHub, open **Source Control**, stage your
changes, enter a commit message (a description of the changes you have made) ,
commit, and use **Sync Changes** or **Push**. Use your fork if you do not have
write access to the course repository.

When finished, open [your codespaces](https://github.com/codespaces), find this
codespace, and choose **Stop codespace** from its menu. Resume the same codespace
next time to retain your files and installed dependencies. Codespaces uses your
account's compute and storage allowance; check GitHub's usage settings. Commit
and push work you want to keep before deleting a codespace.

## Get new course files

Fetch the lecturer's updates into your Codespace, merge them with your work,
then use **Sync Changes** to send the result to your fork. These steps assume
you are working on the `main` branch.

### Merge and sync the updates

Save your files and commit any exercise changes in **Source Control** so your
working tree is clean. In the terminal, run these commands in order. Run the
merge only after the fetch succeeds.

```
git fetch upstream main
git merge --no-edit FETCH_HEAD
```

* `git fetch upstream main` downloads the latest commits from the course
  repository's `main` branch. It leaves your branch and working files as they
  are and records the commit it fetched in `FETCH_HEAD`.
* `git merge --no-edit FETCH_HEAD` brings that fetched commit into your current
  branch, combining the course updates with your exercise commits. If Git
  creates a merge commit, `--no-edit` accepts the default commit message.
  If Git reports a conflict, resolve it before syncing or ask your lecturer
  for help.

After the merge succeeds, check that your exercise solutions are still there.
Click **Sync Changes** in the Codespace's **Source Control** view. It first
pulls any changes from your fork, then pushes the merged commits back to it.
Run `lake build` to check the updated course.

New Lean files do not require a container rebuild. If the lecturer changes the
project's dependencies, run `bash .devcontainer/setup.sh` after updating. If the
files in `.devcontainer` change, run **Codespaces: Rebuild Container** from the
command palette and wait for setup to finish. In a local VS Code container,
use **Dev Containers: Rebuild Container** instead.

## If setup or Lean fails

For a local container in VS Code, install the **Dev Containers** extension, start
Docker, then run **Dev Containers: Reopen in Container** from the command palette.
After changing the container configuration, use **Dev Containers: Rebuild
Container**. The container keeps its Linux dependencies and build files in a
Docker volume, separate from the Mac or Windows build files in your checkout.

Setup prints its current step and retries failed downloads up to three times.
An SSL or connection error while installing Lean means the download failed;
check your internet connection and any VPN or proxy before trying again.

If the log says **No space left on device**, setup has run out of disk space.
Make sure you have pulled the latest course configuration: setup downloads only
the Mathlib modules imported by the course to limit disk use. Save, commit, and
push your exercise work, then run **Codespaces: Rebuild Container** and choose
**Full Rebuild** in the confirmation dialog to clear the old container's files
and rerun setup. A full rebuild clears Docker volumes,
including the course's compiled dependencies, which setup downloads again.

If the initial dependency download was interrupted, rerun
`bash .devcontainer/setup.sh` in the terminal. Read the first error if it fails
again. Once setup succeeds, open the command palette and run
**Developer: Reload Window** if the Infoview still shows missing imports.

If you created the codespace before the container configuration was added or
changed, run **Codespaces: Rebuild Container** from the command palette, then
wait for setup to finish.

For more about creating and resuming codespaces, see the
[GitHub Codespaces documentation](https://docs.github.com/en/codespaces).
-/
