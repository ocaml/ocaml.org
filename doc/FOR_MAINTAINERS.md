# Information for maintainers

# How we maintain the staging branch

To reduce the workload maintaining the `staging` branch in a good shape where
it is close to the main branch with only a few patches applied, some discipline is needed:

1. We squash every patch into a single commit, and
2. if the patch belongs to an open PR,
  - we mention the PR number and title in the commit message, and
  - we mention the commit id and message of the latest commit in that PR in the commit message body

This way, looking at the commits on `staging` via `git log` or the GitHub UI, it is obvious where each commit is coming from and what its purpose is. Additionally, this ensures that rebasing on an updated
`main` branch remains simple.

Example: Assuming a PR lies in branch `<pr-branch>`
(e.g. `fix-issue-42`) and has number `<pr-num>` in GitHub (e.g. 43 in
https://https://github.com/ocaml/ocaml.org/pull/43), and `origin` is
`ocaml/ocaml.org.git` at GitHub, here are the steps:

1. Squash a PR:
  ```sh
  $ git merge --squash <pr-branch>
  $ git merge -m "<title of PR on GitHub> #<pr-num>"
  ```
  Alternatively, you can do
  ```sh
  $ git checkout -b <new-branch-name>
  $ git reset main
  $ git commit
  ```

2. Set the commit message to:
  ```
  <title of PR on GitHub> #<pr-num>

  <message of last commit> <last commit id>
  ```

To add a commit to `staging`, we can cherry-pick the commit with `git cherry-pick <commit id>`.

To remove a commit from `staging`, a simple method is to `git rebase -i main`. This gives you a list of commits that you can edit to remove a specific commit.
