---
title: "OCaml Infrastructure: Sunsetting opam-repository-mingw"
tags: [infrastructure]
---

As [previously announced](https://fdopen.github.io/opam-repository-mingw/2021/02/26/repo-discontinued), "opam-repository-mingw" is no longer receiving updates.

We're actively working on getting the Windows compiler packages into [ocaml/opam-repository](https://github.com/ocaml/opam-repository). There are two issues which are taking (me) a little while to finish solving, but more on that further below.

In the gap - of hopefully only a month or so - for this being ready, there's is an issue that new releases are of course not available when opam-repository-mingw is being used with [`ocaml/setup-ocaml@v2`](https://github.com/ocaml/setup-ocaml) GitHub actions workflows. I'm hoping here to set out what's happening, and what steps you may need to take to keep your GitHub Actions Windows workflows running smoothly over the next few months.

## What's happening right now?

We've updated setup-ocaml to use [ocaml-opam/opam-repository-mingw](https://github.com/ocaml-opam/opam-repository-mingw) instead of [fdopen/opam-repository-mingw](https://github.com/fdopen/opam-repository-mingw) (see [ocaml/setup-ocaml#651](https://github.com/ocaml/setup-ocaml/pull/651)). This clone has been augmented with:
- OCaml 4.14.1 packages, in the same style as the 4.14.0 forked packages (the "pre-compiled" package variants exist, but they're not pre-compiled)
- Changes to the constraints for _existing_ packages only

If you're using setup-ocaml in its default configuration, you should notice no change except that `4.14.x` builds should now use 4.14.1 and the initial build will be a little slower as it builds from sources (GitHub Actions caching will then take over for subsequent runs).

For new releases of packages, it's necessary to _add_ opam-repository to the repositories selections for the switches. It's important that opam-repository is at a _lower priority_ than opam-repository-mingw for existing packages, so it's better to use these lines in your `ocaml/setup-ocaml@v2` step than to issue `opam repo add --rank=1000` later:

```
uses: ocaml/setup-ocaml@v2
with:
  opam-repositories: |
    opam-repository-mingw: https://github.com/ocaml-opam/opam-repository-mingw.git#sunset
    default: https://github.com/ocaml/opam-repository.git
```

## What do I do when things are broken?

There's an issue tracker on [ocaml-opam/opam-repository-mingw](https://github.com/ocaml-opam/opam-repository-mingw/issues), and this is a very good place to start.

If a version of a package isn't building, there are three possible remedies:

- Previous versions of the package may have carried non-upstreamed patches in opam-repository-mingw. opam-repository's policy is not to carry such patches. In this case, the package actually doesn't work on Windows.
  - opam-repository should be updated to have `os != "win32"` added to the `available` field for the package
  - An issue on the package's upstream repo should be opened highlighting the need to upstream patches (or even a pull request with them!)
  - The patches in opam-repository-mingw make changes which may not necessarily be accepted/acceptable upstream in their current form, so the issue may be a better starting point than simply taking a patch and opening a pull request for it (for example, the `utop` package contains patches which may require further work and review)
- The package relies on environment changes in "OCaml for Windows". For example, the Zarith package works in "OCaml for Windows" because the compiler packages unconditionally set the `CC` environment variable. This change is both not particularly desirable change to upstream (it is _very_ confusing, for example, when working on the compiler itself) and also extremely difficult to upstream, so the fix here is instead to change the package's availability with `(os != "win32" | os-distribution = "cygwinports")` and constrain away OCaml 5 on Windows (`"ocaml" {< "5.0" | os != "win32"}`)
- Package constraints on _existing packages_ need updating in ocaml-opam/opam-repository-mingw. For example, the release of ppxlib 0.29 required some existing packages to have upperbounds added.

## What about OCaml 5.0.0?

OCaml 5.0.0 was released with support for the mingw-w64 port only, however, there's a quite major bug which wasn't caught by OCaml's testsuite, but is relatively easily triggered by opam packages. I've [previously announced](https://discuss.ocaml.org/t/pre-ann-installing-windows-ocaml-5-0-0-in-opam/11150) how to add OCaml 5 to a workflow. For the time being, the packages for OCaml 5 aren't automatically made available.

## What's next?

The ultimate goal is to be using an upstream build of `opam.exe` with ocaml/opam-repository, just as on Unix. Once opam 2.2 is generally available (we're aiming for an alpha release at the end of March) and the compiler packages in opam-repository support the Windows builds, we will recommend stopping use of opam-repository-mingw completely. The default in setup-ocaml won't change straight away, since that risks breaking existing workflows.

With upstream compiler support, we'll be able to extend some of the existing bulk build support already being done for Linux to Windows and start to close the gap of patches in opam-repository-mingw.

## Windows compiler packages

I mentioned earlier the problems with moving the compiler packages into opam-repository, and just for general interest this elaborates on them.

The first issue affects the use of the Visual Studio port ("MSVC") and is a consequence of the somewhat strange way that the C compiler is added to the environment when using the Visual Studio C compiler. "OCaml for Windows" (as well as Diskuv) use a wrapper command (it's `ocaml-env` in "OCaml for Windows" and `with-dkml` in Diskuv). Those commands are Windows-specific, which is an issue for upstream opam. There's an alternate way which sets the environment variables in a more opam-like way. Doing it that way, though, requires an improvement to opam's environment handling which is in opam 2.2, otherwise there's an easy risk of "blowing" the environment.

The second issue is selecting the C compiler. On Unix, this is easy
with `ocaml-base-compiler` because there is only one "system" C compiler. Windows has two ports of OCaml, and the configuration requires it to be explicitly selected. That requires input from the user on switch creation for a Windows switch.

"OCaml for Windows" solves this by packaging the Windows compilers with the variant name appended, just as opam-repository used to, so `ocaml-variants.4.14.1+mingw64` selects the the mingw-w64 port and `ocaml-variants.4.14.1+msvc64` selects the MSVC64 port. The problem, as we already had in opam-repository, is that this adds 4 packages for each release of OCaml in `ocaml-variants`, and leads to a combinatorial explosion when we start considering flambda and other relevant compiler options.

opam-repository switched to using the `ocaml-option-` packages to solve the combinatorial explosion which was already present in opam-repository. The demonstration repo for OCaml 5 on Windows is already using an adapted version of this so that `ocaml-option-mingw` selects the mingw-w64 port (by default 64-bit, with `ocaml-option-32bit` then selecting the 32-bit port).

This work is all in progress and being tested alongside changes in  opam 2.2 to support the _depext_ experience on Windows. The only reason that's not being upstreamed piecemeal is that changes to the compiler packages in opam-repository trigger switch rebuilds all over the world, so we don't want to that until we're sure that the packages are correct. The intention is to do this around the time of the alpha release of opam 2.2, once the work in opam itself has settled down.

Thanks for getting to the end, and happy Windows CI testing!

*[Discuss this post further](https://discuss.ocaml.org/t/sunsetting-opam-repository-mingw/11632) on the forums.*
