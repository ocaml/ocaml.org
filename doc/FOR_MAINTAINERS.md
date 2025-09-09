# Information for maintainers

# Advancing the `opam-repository` pin

OCaml.org's dependencies are fixed through pinning `opam-repository` in the `dune-workspace` files, and in the `Dockerfile`. To update the repository pin,

1. change the commit hash in the main `dune-workspace` file, `dune-workspace` file of the playground, and in the `Dockerfile`
2. delete the `dune.lock/` directory
3. build the project
4. make it very obvious in the PR updating the opam-repository pin that contributors need to re-run `dune pkg lock` and be aware that contributors may need to be told to do this

# How we maintain the staging branch

To reduce the workload maintaining the `staging` branch in a good shape where
it is close to the main branch with only a few patches applied, some discipline is needed:

1. We squash every patch into a single commit, and
2. if the patch belongs to an open PR,
  - we mention the PR number and title in the commit message, and
  - we mention the commit id and message of the latest commit in that PR in the commit message body

This way, looking at the commits on `staging` via `git log` or the GitHub UI, it is obvious where each commit is coming from and what its purpose is. Additionally, this ensures that rebasing on an updated
`main` branch remains simple.

## Add a PR to staging

Example: Assuming a PR lies in branch `<pr-branch>`
(e.g. `fix-issue-42`) and has number `<pr-num>` in GitHub (e.g. 43 in
https://https://github.com/ocaml/ocaml.org/pull/43), and `origin` is
`ocaml/ocaml.org.git` at GitHub, here are the steps:

### Method 1: `git merge`

1. Squash a PR directly onto staging:
  ```sh
  $ git checkout staging
  $ git merge --squash <pr-branch>
  $ git commit -m "<title of PR on GitHub> #<pr-num>"
  ```

2. Set the commit message to:
  ```
  <title of PR on GitHub> #<pr-num>

  <message of last commit> <last commit id>
  ```

### Method 2: `git reset`

An alternative method to get a squashed PR onto staging is this:
1. On the PR branch: create a new branch from the PR branch and squash with `git reset`:
  ```sh
  $ git checkout -b <new-branch-name>
  $ git reset <commit id before the first commit of the patch>
  $ git commit
  ```

2. Set the commit message to:
  ```
  <title of PR on GitHub> #<pr-num>

  <message of last commit> <last commit id>
  ```

3. Cherry-pick the commit to staging
  ```sh
  $ git checkout staging
  $ git cherry-pick <commit id>
  ```

## Remove a PR from staging

To remove a commit from `staging`, a simple method is to `git rebase -i main`. This gives you a list of commits that you can edit to remove the commit.
