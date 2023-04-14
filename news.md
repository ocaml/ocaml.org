NathanReb | 2021-07-05 13:59:31 UTC | #1

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

-------------------------

avsm | 2021-07-05 15:30:20 UTC | #2

The draft PR mode will be so useful for opam-repository maintainers to distinguish between work-in-progress submissions and ones intended for merge. Thanks @NathanReb!

-------------------------

