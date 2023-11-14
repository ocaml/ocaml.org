---
title: Dune-release 1.5.0
date: "2021-07-05"
tags: [dune-release, platform]
changelog: |
  ### Added

  - Add `--no-auto-open` to the default command. It was previously only available for
    `dune-release opam`. (#374, @NathanReb)
  - Add a `config create` subcommand to create a fresh configuration if you don't have one yet
    (#373, @NathanReb)
  - Add `--local-repo`, `--remote-repo` and `--opam-repo` options to the default command,
    they used to be only available for the `opam` subcommand (#363, @NathanReb)
  - Add a `--token` option to `dune-release publish` and `dune-release opam` commands
    to specify a github token. This allows dune-release to be called through a Github
    Actions workflow and use the github token through an environment variable.
    (#284 #368, @gpetiot @NathanReb)
  - Log curl calls on verbose/debug mode (#281, @gpetiot)
  - Try to publish the release asset again after it failed (#272, @gpetiot)
  - Improve error reporting of failing git comands (#257, @gpetiot)
  - Suggest a solution for users without ssh setup (#304, @pitag-ha)
  - Allow including git submodules to the distrib tarball by passing the
    `--include-submodules` flag to `dune-release`, `dune-release bistro` or
    `dune-release distrib` (#300, @NathanReb)
  - Support 'git://' scheme for dev-repo uri (#331, @gpetiot)
  - Support creation of draft releases and draft PRs. Define a new option
    `--draft` for `dune-release publish` and `dune-release opam submit` commands.
    (#248, @gpetiot)
  - Add a new command `check` to check the prerequisites of dune-release and
    avoid starting a release process that couldn't be finished (#318, #351, @pitag-ha)
  - When preparing the opam-repository PR and pushing the local branch to 
    the user's remote opam-repository fork, use `--set-upstream` to ease any further
    update of the PR (#350, @gpetiot)

  ### Changed

  - Entirely rely on the remote fork of opam-repository URL in `opam submit` instead of
    reading the user separately. The information was redundant and could only lead to bugs
    when unproperly set. (#372, @NathanReb)
  - Use pure token authentication for Github API requests rather than "token as passwords"
    authentication (#369, @NathanReb)
  - Require tokens earlier in the execution of commands that use the github API. If the token
    isn't saved to the user's configuration, the prompt for creating one will show up at the
    command startup rather than on sending the first request (#368, @NathanReb)
  - Attach the changelog to the annotated tag message (#283, @gpetiot)
  - Do not remove versioned files from the tarball anymore. We used to exclude
    `.gitignore`, `.gitattributes` and other such files from the archive.
    (#299, @NathanReb)
  - Don't try to push the tag if it is already present and point to the same ref on the remote.
    `dune-release` must guess which URI to pass to `git push` and may guess it wrong.
    This change allows users to push the tag manually to avoid using that code. (#219, @Julow)
  - Don't try to create the release if it is already present and points to the same tag (#277, @kit-ty-kate)
  - Recursively exclude all `.git`/`.hg` files and folders from the distrib
    tarball (#300, @NathanReb)
  - Make the automatic dune-release workflow to stop if a step exits with a non-zero code (#332, @gpetiot)
  - Make git-related mdx tests more robust in unusual environments (#334, @sternenseemann)
  - Set the default tag message to "Release <tag>" instead of "Distribution <tag>"
  - Opam file linter: check for `synopsis` instead of `description` (#291, @kit-ty-kate)
  - Upgrade the use of the opam libraries to opam 2.1 (#343, @kit-ty-kate)

  ### Deprecated

  - Deprecate the `--user` CLI options and configuration field, they were redundant with
    the remote-repo option and field and could be set unproperly, leading to bugs (#372, @NathanReb)
  - Deprecate the use of delegates in `dune-release publish` (#276, #302, @pitag-ha)
  - Deprecate the use of opam file format 1.x (#352, @NathanReb)

  ### Removed

  - Option --name is removed from all commands. When used with
    `dune-release distrib`, it was previously effectively ignored. Now
    it is required to add a `(name <name>)` stanza to
    `dune-project`. (#327, @lehy)

  ### Fixed

  - Fix a bug where `opam submit` would look up a config file, even though all the required
    information was provided on the command line. This would lead to starting the interactive
    config creation quizz if that file did not exist which made it impossible to use it in a CI
    for instance. (#373, @NathanReb)
  - Fix a bug where `opam submit` would fail on non-github repositories if the user had no
    configuration file (#372, @NathanReb)
  - Fix a bug where subcommands wouldn't properly read the token files, leading to authentication
    failures on API requests (#368, @NathanReb)
  - Fix a bug in `opam submit` preventing non-github users to create the opam-repo PR
    via dune-release. (#359, @NathanReb)
  - Fix a bug where `opam submit` would try to parse the custom URI provided through
    `--distrib-uri` as a github repo URI instead of using the dev-repo (#358, @NathanReb)
  - Fix the priority of the `--distrib-uri` option in `dune-release opam pkg`.
    It used to have lower precedence than the url file written by `dune-release publish`
    and therefore made it impossible to overwrite it if needed. (#255, @NathanReb)
  - Fix a bug with --distrib-file in `dune-release opam pkg` where you would need
    the regular dune-release generated archive to be around even though you specified
    a custom distrib archive file. (#255, @NathanReb)
  - Use int64 for timestamps. (#261, @gpetiot)
  - Define the order of packages (#263, @gpetiot)
  - Allow the dry-run mode to continue even after some API call's response were expected by using placeholder values (#262, @gpetiot)
  - Build and run tests for all selected packages when checking distribution tarball
    (#266, @NathanReb)
  - Improve trimming of the changelog to preserve the indentation of the list of changes. (#268, @gpetiot)
  - Trim the data of the `url` file before filling the `url.src` field. This fixes an issue that caused the `url.src` field to be a multi-line string instead of single line. (#270, @gpetiot)
  - Fix a bug causing dune-release to exclude all hidden files and folders (starting with `.`) at the
    repository from the distrib archive (#298, @NathanReb)
  - Better report GitHub API errors, all of the error messages reported by the GitHub API are now checked and reported to the user. (#290, @gpetiot)
  - Fix error message when `dune-release tag` cannot guess the project name (#319, @lehy)
  - Always warn about uncommitted changes at the start of `dune-release
    distrib` (#325, @lehy).  Otherwise uncommitted changes to
    dune-project would be silently ignored by `dune-release distrib`.
  - Fix rewriting of github references in changelog (#330, @gpetiot)
  - Fixes a bug under cygwin where dune-release was unable to find the commit hash corresponding to the release tag (#329, @gpetiot)
  - Fixes release names by explicitly setting it to match the released version (#338, @NathanReb)
  - Fix a bug that prevented release of a package whose version number contains invalid characters for a git branch. The git branch names are now sanitized. (#271, @gpetiot)
  - `publish`: Fix the process of inferring user name and repo from the dev repo uri (#348, @pitag-ha)
---

On behalf of the dune-release team I'm pleased to announce that we're releasing dune-release.1.5.0.

It has been quite a while since the last release so there are numerous changes and improvements in this one, along with a lot of bug fixes.

The two main new features in 1.5.0 are:
- A draft release mode that creates a draft Github release and a draft PR to opam-repository. It comes with an `undraft` command that will undraft both and update the opam file's `url.src` field accordingly. We believe this feature will prove helpful to maintainers of tools such as `dune` which releases are often watched by distribution maintainers. Draft releases allow you to wait until you have opam-repository's CI approval to actually create a GH release that will notify anyone watching the repository.
This feature is still a bit experimental, we have ideas on how to improve it but we wanted to get a first version out to collect feedback on how it is used and what you folks expect from it.
- A `check` command that you can run ahead of a release to know if dune-release has all the information it needs in the repository, along with running the lint, build and test checks it normally runs after building the tarball.
We're aware that it can be frustrating to see dune-release fail right in the middle of the release process. We're trying to improve this situation and this is a first step in that direction.

You can see the full changelog [here](https://github.com/ocamllabs/dune-release/releases/tag/1.5.0)

You'll note we also deprecated a few features such as delegates (as we announced in [this post](https://discuss.ocaml.org/t/replacing-dune-release-delegates/4767)), opam 1.x and the `--user` option and corresponding config file field.
This release is likely to be the last 1.x release of `dune-release` except for important bug fixes as we'll start working on 2.0 soon.

Our main goals for 2.0 are to make the experience for github users as seemless as possible. We want the tool to do the right thing for those users without them having to configure anything. Delegates got in the way there and that's why we're removing them.
We do care about our non github users and we've worked on making it as configurable as possible so that you can integrate it in your release workflow. The situation should already have improved quite a bit with this release as we fixed several bugs for non github hosted repositories. We want to make sure that these users will be happy with dune-release 2.0 as well.
Hopefully in the future dune-release will support other release workflows such as handling gitlab hosted repositories but we want to make sure our main user base is happy with the tool before adding this.

We'll communicate a bit more on our plans for 2.0 in the next few months. Our hope is that it will hit opam before the end of this year.

We hope that you'll like this new version and wish you all successful and happy releases!

