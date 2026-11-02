# Information for Maintainers

## How we maintain the staging branch

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
<https://github.com/ocaml/ocaml.org/pull/43>), and `origin` is
`ocaml/ocaml.org.git` at GitHub, here are the steps:

### Method 1: `git merge`

1. Squash a PR directly onto staging:
  ```sh
  git checkout staging
  git merge --squash <pr-branch>
  git commit -m "<title of PR on GitHub> #<pr-num>"
  ```

1. Set the commit message to:
  ```text
  <title of PR on GitHub> #<pr-num>

  <message of last commit> <last commit id>
  ```

### Method 2: `git reset`

An alternative method to get a squashed PR onto staging is this:
1. On the PR branch: create a new branch from the PR branch and squash with `git reset`:
  ```sh
  git checkout -b <new-branch-name>
  git reset <commit id before the first commit of the patch>
  git commit
  ```

1. Set the commit message to:
  ```text
  <title of PR on GitHub> #<pr-num>

  <message of last commit> <last commit id>
  ```

1. Cherry-pick the commit to staging
  ```sh
  git checkout staging
  git cherry-pick <commit id>
  ```

## Remove a PR from staging

To remove a commit from `staging`, a simple method is to `git rebase -i main`. This gives you a list of commits that you can edit to remove the commit.

## Push to a contributor's fork

Maintainers can push commits to a contributor's pull request branch. Over SSH,
`git-lfs` verifies locks through the fork's LFS locks API, which returns 403
because you hold no lock rights on a repository you don't own, and the push
aborts. This is expected, not a missing permission. Skip the `git-lfs` pre-push
step (this also skips uploading LFS objects, so only do it when your commits add
none):

```sh
GIT_LFS_SKIP_PUSH=1 git push <remote> HEAD:<branch>
```
