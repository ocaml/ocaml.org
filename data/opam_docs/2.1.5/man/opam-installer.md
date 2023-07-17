---
slug: opam-installer.html
title: Manpage opam-installer
description: |
  man page on opam-installer.
---
# OPAM-INSTALLER

Section: Opam-installer Manual (1)  
Updated:  
[Index](#index) [Return to Main Contents](index.html)

-----

<span id="lbAB"> </span>

## NAME

opam-installer - Handles (un)installation of package files following
instructions from opam \*.install files. <span id="lbAC"> </span>

## SYNOPSIS

**opam-installer** \[*OPTION*\]… \[*PKG.install*\]
<span id="lbAD"> </span>

## ARGUMENTS

  - *PKG.install*  
    The opam .install file to read for installation instructions

<span id="lbAE"> </span>

## OPTIONS

  - **--docdir**=*PATH*  
    Documentation dir. Relative to **prefix** or absolute. By default
    *$prefix/doc*.
  - **--help**\[=*FMT*\] (default=**auto**)  
    Show this help in format *FMT*. The value *FMT* must be one of
    **auto**, **pager**, **groff** or **plain**. With **auto**, the
    format is **pager** or **plain** whenever the **TERM** env var is
    **dumb** or undefined.
  - **-i**, **--install**  
    Install the package (the default)
  - **--libdir**=*PATH*  
    OCaml lib dir. Relative to **prefix** or absolute. By default
    *$prefix/lib* ; sometimes setting this to *$(ocamlc -where*) is
    preferable.
  - **--mandir**=*PATH*  
    Manpages dir. Relative to **prefix** or absolute. By default
    *$prefix/man*.
  - **--name**=*NAME*  
    Specify the package name. Used to set install directory under
    \`share/', etc. By default, basename of the .install file
  - **--prefix**=*PREFIX* (absent=**/usr/local**)  
    The prefix to install to. You can use eg '$PREFIX' to output a
    relocatable script
  - **--script**  
    Don't execute the commands, but output a shell-script (experimental)
  - **--stubsdir**=*PATH*  
    Stubs installation dir. Relative to **prefix** or absolute. By
    default *$libdir/stublibs*.
  - **--topdir**=*PATH*  
    Toplevel install dir. Relative to **prefix** or absolute. By default
    *$libdir/toplevel*.
  - **-u**, **--uninstall**, **--remove**  
    Remove the package
  - **--version**  
    Show version information.

-----

<span id="index"> </span>

## Index

  - [NAME](#lbAB)

  - [SYNOPSIS](#lbAC)

  - [ARGUMENTS](#lbAD)

  - [OPTIONS](#lbAE)

-----

This document was created by [man2html](/cgi-bin/man/man2html), using
the manual pages.  
Time: 09:45:51 GMT, July 19, 2023
