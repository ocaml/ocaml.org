---
title: "opam releases: 2.0.10, 2.1.1, & opam depext 1.2!"
authors: [ "David Allsopp", "Raja Boujbel", "Louis Gesbert"]
date: "2021-11-15"
description: "???"
tags: [platform]
---

_Feedback on this post is welcomed on [Discuss](https://discuss.ocaml.org/t/ann-opam-2-1-1-opam-2-0-10-opam-depext-1-2/8872)!_

We are pleased to announce several minor releases: [opam 2.0.10](https://github.com/ocaml/opam/releases/tag/2.0.10), [opam 2.1.1](https://github.com/ocaml/opam/releases/tag/2.1.1), and [opam-depext 1.2](https://github.com/ocaml-opam/opam-depext/releases/tag/1.2).

The opam releases consist of backported fixes, while `opam-depext` has been adapted to be compatible with opam 2.1, to allow for workflows which need to maintain compatibility with opam 2.0. With opam 2.1.1, if you export `OPAMCLI=2.0` into your environment then workflows expecting opam 2.0 should now behave even more equivalently.

## opam-depext 1.2

Previous versions of opam-depext were made unavailable when using opam 2.1, since depext handling is done directly by opam 2.1 and later. This is still the recommended way, but this left workflows which wanted to maintain compatibility with opam 2.0 without a single command to install depexts. You can now run `OPAMCLI=2.0 opam depext -y package1 package2` and expect this to work correctly with any version of opam 2. If you don't specify `OPAMCLI=2.0` then the plugin will remind you that you should be using the integrated depext support! Calling `opam depext` this way with opam 2.1 and later still exposes the same double-solving problem that opam 2.0 has, but if for some reason the solver returns a different solution at `opam install` then the correct depexts would be installed.

For opam 2.0, some useful depext handling changes are back-ported from opam 2.1.x to the plugin:
With opam 2.0:
* yum-based distributions: force not to upgrade ([#137](https://github.com/ocaml-opam/opam-depext/pull/137))
* Archlinux: always upgrade all the installed packages when installing a new package ([#138](https://github.com/ocaml-opam/opam-depext/pull/138))

## [opam 2.1.1](https://github.com/ocaml/opam/blob/2.1.1/CHANGES)
opam 2.1.1 includes both the fixes in opam 2.0.10.

General fixes:

* Restore support for switch creation with "positional" package arguments and `--packages` option for CLI version 2.0, e.g. `OPAMCLI=2.0 opam switch create . 4.12.0+options --packages=ocaml-option-flambda`. In opam 2.1 and later, this syntax remains an error ([#4843](https://github.com/ocaml/opam/issues/4843))
* Fix `opam switch set-invariant`: default repositories were loaded instead of the switch's repositories selection ([#4869](https://github.com/ocaml/opam/pull/4869))
* Run the sandbox check in a temporary directory ([#4783](https://github.com/ocaml/opam/issues/4783))

Integrated depext support has a few updates:
* Homebrew now has support for casks and full-names ([#4800](https://github.com/ocaml/opam/issues/4800))
* Archlinux now handles virtual package detection ([#4833](https://github.com/ocaml/opam/pull/4833), partially addressing [#4759](https://github.com/ocaml/opam/issues/4759))
* Disable the detection of available packages on RHEL-based distributions.
  This fixes an issue on RHEL-based distributions where yum list used to detect
  available and installed packages would wait for user input without showing
  any output and/or fail in some cases ([#4791](https://github.com/ocaml/opam/pull/4791))
  
And finally two regressions have been dealt with:
* Regression: avoid calling `Unix.environment` on load (as a toplevel expression). This regression affected opam's libraries, rather than the binary itself ([#4789](https://github.com/ocaml/opam/pull/4789))
* Regression: handle empty environment variable updates ([#4840](https://github.com/ocaml/opam/pull/4840))

A few issues with the compilation of opam from sources have been fixed as well (e.g. mingw-w64 with g++ 11.2 now works)

## [opam 2.0.10](https://github.com/ocaml/opam/blob/2.0.10/CHANGES)
Two subtle fixes are included in opam 2.0.10. These actually affect the `ocaml` package. Both of these are Heisenbugs - investigating what's going wrong on your system may well have fixed them, they were both found on Windows!

`$(opam env --revert)` is the reverse of the more familiar `$(opam env)` but it's effectively called by opam whenever you change switch. It has been wrong since 2.0.0 for the case where several values are added to an environment variable in one `setenv` update. For example, if a package included a `setenv` field of the form `[PATH += "dir1:dir2"]`, then this would not be reverted, but `[[PATH += "dir1"] [PATH += "dir2"]]` would be reverted. As it happens, this bug affects the `ocaml` package, but it was masked by another `setenv` update in the same package.

The other fix is also to do with `setenv`. It can be seen immediately after creating a switch but before any additional packages are installed, as this `Dockerfile` shows:

```
FROM ocaml/opam@sha256:244b948376767fe91e2cd5caca3b422b2f8d332f105ef2c8e14fcc9a20b66e25
RUN sudo apt-get install -y ocaml-nox
RUN opam --version
RUN opam switch create show-issue ocaml-system
RUN eval $(opam env) ; echo $CAML_LD_LIBRARY_PATH
RUN opam install conf-which
RUN eval $(opam env) ; echo $CAML_LD_LIBRARY_PATH
```

Immediately after switch creation, `$CAML_LD_LIBRARY_PATH` was set to `/home/opam/.opam/show-issue/lib/stublibs:`, rather than `/home/opam/.opam/show-issue/lib/stublibs:/usr/local/lib/ocaml/4.08.1/stublibs:/usr/lib/ocaml/stublibs`

---

Opam installation instructions (unchanged):

1. From binaries: run

    ```
    bash -c "sh <(curl -fsSL https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh) --version 2.1.1"
    ```

    or download manually from [the Github "Releases" page](https://github.com/ocaml/opam/releases/tag/2.1.1) to your PATH. In this case, don't forget to run `opam init --reinit -ni` to enable sandboxing if you had version 2.0.0~rc manually installed or to update you sandbox script.

2. From source, using opam:

    ```
    opam update; opam install opam-devel
    ```

   (then copy the opam binary to your PATH as explained, and don't forget to run `opam init --reinit -ni` to enable sandboxing if you had version 2.0.0~rc manually installed or to update your sandbox script)

3. From source, manually: see the instructions in the [README](https://github.com/ocaml/opam/tree/2.1.1#compiling-this-repo).

We hope you enjoy this new minor version, and remain open to [bug reports](https://github.com/ocaml/opam/issues) and [suggestions](https://github.com/ocaml/opam/issues).
