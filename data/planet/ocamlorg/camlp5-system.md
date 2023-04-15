---
title: "Urgent problem with camlp5"
authors: [ "David Allsopp" ]
date: "2018-05-04"
description: "Instruction to fix an urgent problem with camlp5 7.03 and macOS OCaml 4.06.1"
---

# Packaging problem with opam-repository camlp5 7.03 when upgrading to OCaml 4.06.1

Between 26 Oct 2017 and 17 Feb 2018, the OPAM package for camlp5 7.03 in [opam-repository](https://github.com/ocaml/opam-repository) was under certain circumstances able to trigger `rm -rf /` on macOS and other systems which don't by default prevent recursive root deletion. This article contains advice on how to identify if your OPAM installation is affected and what you can do to fix it.

TL;DR If `rm --preserve-root` gives a message along the lines of `unrecognised option` rather than `missing operand` and you are running OPAM 1.2.2, ensure you run `opam update` **before** upgrading your system compiler to OCaml 4.06.1. If you have already upgraded *your system compiler* to OCaml 4.06.1 (e.g. with Homebrew) then please read on.

## Identifying whether you're affected

**You are at serious risk of erasing all your files if the following three things are true:**
 - Your system `rm` command does not support the `--preserve-root` default (you can identify this by running `rm --preserve-root` and noting whether the error message refers to an ‘unrecognised option’ rather than a ‘missing operand’)
 - Your system OCaml compiler is 4.06.1 and you are using OPAM 1.2.2
 - You have synchronised with opam-repository after 26 Oct 2017 but have not synchronised since 18 Feb 2018

If your system is affected, most OPAM commands cannot be run. In particular, if OPAM asks:

```
dra@bionic:~$ opam update
Your system compiler has been changed. Do you want to upgrade your OPAM installation ? [Y/n] n
```

**YOU MUST ANSWER NO TO THIS QUESTION**.

I have written a script which can safely identify if your system is affected, which can be reviewed on [GitHub](https://github.com/dra27/opam/blob/camlp5-detection/shell/opam-detect.sh) or run directly by executing:

```
$ curl -L https://raw.githubusercontent.com/dra27/opam/camlp5-detection/shell/opam-detect.sh | sh -
```

This script scans the directory identified by `$HOME` for anything which looks like an OPAM root. Virtually all users will have one OPAM root in `~/.opam` and if you don't know how to run OPAM with multiple roots, then you probably don't have any others to worry about!

The script may display a variety of messages. If your system contains at least one affected OPAM 1.2 root, you will see output like this:

```
dra@bionic:~/opam$ shell/opam-detect.sh 
opam 1.2.2 found
Scanning /home/dra for opam roots...
opam 1.2 root found in /home/dra/.opam
camlp5 is faulty AND installed AND the system compiler is OCaml 4.06.1

THIS ROOT CANNOT BE UPDATED OR UPGRADED. DO NOT ALLOW OPAM TO UPGRADE THE SYSTEM
COMPILER. DOING SO WILL ATTEMPT TO ERASE YOUR MACHINE
Please see https://github.com/ocaml/opam/issues/3322 for more information
```

## Fixing it

In all cases, one fix is to install the latest release candidate for opam 2, and upgrade your OPAM 1.2 root to opam 2 format. The upgrade prevents OPAM 1.2.2 from being able to read the root. If you received the message above and choose to upgrade to opam 2 (the easiest way to upgrade a root is to run `opam list` after installing opam 2) and then run the `opam-detect.sh` script again. As before, **DO NOT ANSWER YES TO THE Your system compiler has changed. QUESTION IF YOU ARE ASKED**.

If you do not wish to upgrade to opam 2, and there are many good reasons for not wanting to do this, there are two other possibilities. The easiest is to downgrade your system compiler back to 4.06.0 (or an earlier release). You can then run `opam-detect.sh` again and check the error message. As long as the message is no longer the one above, you can then run `opam update` to update the repository metadata on the switch. You can then upgrade your system compiler back to OCaml 4.06.1 again. To be absolutely sure, you can then run the `opam-detect.sh` script again and, assuming the message is still not the one above, you can then allow OPAM 1.2.2 to upgrade your system switch. *This is the recommended course of action.*

The final option is that you can edit the opam root by hand and trick opam into believing that the camlp5 package is no longer installed. This is done by editing the file `system/installed` within the root and removing **both** the `camlp5` line and any package which depends on camlp5 (for example, `coq`). You cannot use the `opam` to determine dependencies at this stage, so you will need to use the online index to check for dependent packages. If you fail to remove all the packages which depend on camlp5, OPAM will display an installation prompt like this:

```
dra@bionic:~$ opam update
Your system compiler has been changed. Do you want to upgrade your OPAM installation ? [Y/n] y

=-=- Upgrading system -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
The following actions will be performed:
  ∗  install camlp5        7.03               [required by coq]
  ∗  install conf-m4       1    
  ∗  install base-threads  base 
  ∗  install base-unix     base 
  ∗  install base-bigarray base 
  ∗  install ocamlfind     1.7.3
  ∗  install num           1.1  
  ∗  install coq           8.7.0
===== ∗  8 =====
Do you want to continue ? [Y/n] 
```

If this happens, answer no, but at this stage your system switch will have been emptied of all packages (you can now safely run `opam update` of course). Of course, you can back-up the OPAM root prior to trying this. Once upgraded, you can then run `opam update` and reinstall the missing packages. **This course of action is not recommended as the `opam-detect.sh` script will no longer help. You are strongly advised to back up your files before attempting this solution**.

## The problem

On 26 Oct 2017, [PR#10523](https://github.com/ocaml/opam-repository/pull/10523) was merged which packaged [camlp5](https://github.com/camlp5/camlp5) 7.03. This was the first version of camlp5 released to opam which supported OCaml 4.06.0.

Unfortunately, it was also the first version of the opam package to include a `remove` section which executed `make uninstall`. The package also contained an incorrect `available` constraint - it should have permitted only OCaml 4.06.0 from the 4.06 branch, but the constraint given permitted all versions.

camlp5's `configure` script is responsible for writing `config/Makefile` with all the usual configuration settings, including `PREFIX` and so forth. This script includes a version check for OCaml and fails if the version is not supported. Unfortunately, even when it fails, it writes a partial `config/Makefile` to enable some development targets. Sadly this left the command `rm -rf "$(DESTDIR)$(LIBDIR)/$(CAMLP5N)"` in the `uninstall` target with all three variables undefined, leaving the certainly unwanted `rm -rf /`.

Users of GNU coreutils have, since November 2003 (in release 5.1.0) had the `--preserve-root` option set by default, which causes `rm -rf /` to raise an error. Unfortunately, macOS does not use GNU coreutils by default.

Prior to OPAM 1.2, the `build` and `install` sections of an `opam` file were combined. For this reason, if the `build` failed, OPAM would silently execute the `remove` commands in order to clean-up any partial installation which may have taken place. Although OPAM 1.2 recommended separating the `build` and `install` commands, this was not mandatory and it therefore retains the “silent remove” behaviour. opam 2 mandates the separation (and, if sandboxing is available, now enforces it). opam 2 also expects `remove` commands to be run in a clean source tree which, for this camlp5 case, means **opam 2 users are UNAFFECTED by this issue**.

OCaml 4.06.1 was added to opam-repository on 16 Feb 2018 in [PR#11433](https://github.com/ocaml/opam-repository/pull/11433). During the following 48 hours, it was noticed that the camlp5 package was attempting to run `rm -rf /` (see [Issue #11440](https://github.com/ocaml/opam-repository/issues/11440)) and the package was patched on 18 Feb 2018 in [PR#11443](https://github.com/ocaml/opam-repository/pull/11443). Unfortunately, the signifance of the GNU coreutils protection was not realised at this point and it was also assumed that the problem would only be hit if one were unlucky enough to have updated OPAM between the release of OCaml 4.06.1 to opam-repository and the patching of camlp5 7.03 in opam-repository (so 16–18 February 2018) and it was on this basis that OPAM [PR#3231](https://github.com/ocaml/opam/issues/3231) was deemed to have been very unlucky.

However, the real problem is the upgrading of the system compiler to 4.06.1, which wasn't noticed in that Issue but was correctly identified in [Issue #3316](https://github.com/ocaml/opam/issues/3316). This unfortunately gives a much wider window for the problem - if you ran `opam update` between 26 Oct 2017 and 18 Feb 2018 and haven't run it since, then your system will be at risk if you update your system compiler to OCaml 4.06.1 without first running `opam update`.

If the system compiler alters, OPAM 1.2.2 on virtually all commands (including `opam update`) first asks to upgrade the `system` switch. This step is mandatory, preventing further safe use of OPAM 1.2.2.

## Future mitigation

Owing to the changes made to how opam 2 processes package installations, opam 2 has been unaffected by this situation but opam 2's lead developer [@AltGr](https://github.com/AltGr) freely admits that this is more by luck than judgement. However, the second release candidate for opam 2 includes mandatory support for sandboxing on Linux and macOS. Sandboxing package building and installation will protect opam 2 against future issues of this kind, as a malfunctioning build system will be unable to operate on files outside its build directory or, during installation, switch root.
