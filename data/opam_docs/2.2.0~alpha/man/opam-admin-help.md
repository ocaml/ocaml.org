---
slug: opam-admin-help.html
title: Manpage opam-admin-help
description: |
  man page on opam-admin-help.
---
# OPAM ADMIN-HELP

Section: Opam admin Manual (1)  
Updated:  
[Index](#index) [Return to Main Contents](index.html)

-----

<span id="lbAB"> </span>

## NAME

opam admin-help - Display help about opam admin and opam admin
subcommands. <span id="lbAC"> </span>

## SYNOPSIS

**opam admin help** \[**--man-format**=*FMT*\] \[*OPTION*\]… \[*TOPIC*\]
<span id="lbAD"> </span>

## DESCRIPTION

Prints help about opam admin commands.

Use \`**opam admin** help topics' to get the full list of help topics.
<span id="lbAE"> </span>

## ARGUMENTS

  - *TOPIC*  
    The topic to get help on.

<span id="lbAF"> </span>

## OPTIONS

  - **--man-format**=*FMT* (absent=**pager**)  
    Show output in format *FMT*. The value *FMT* must be one of
    **auto**, **pager**, **groff** or **plain**. With **auto**, the
    format is **pager** or **plain** whenever the **TERM** env var is
    **dumb** or undefined.

<span id="lbAG"> </span>

## COMMON OPTIONS

  - **--help**\[=*FMT*\] (default=**auto**)  
    Show this help in format *FMT*. The value *FMT* must be one of
    **auto**, **pager**, **groff** or **plain**. With **auto**, the
    format is **pager** or **plain** whenever the **TERM** env var is
    **dumb** or undefined.
  - **--version**  
    Show version information.

<span id="lbAH"> </span>

## EXIT STATUS

**opam admin help** exits with:

  - 0  
    on success.
  - 123  
    on indiscriminate errors reported on standard error.
  - 124  
    on command line parsing errors.
  - 125  
    on unexpected internal errors (bugs).

<span id="lbAI"> </span>

## SEE ALSO

opam [admin](../man1/admin.1.html)(1)

-----

<span id="index"> </span>

## Index

  - [NAME](#lbAB)

  - [SYNOPSIS](#lbAC)

  - [DESCRIPTION](#lbAD)

  - [ARGUMENTS](#lbAE)

  - [OPTIONS](#lbAF)

  - [COMMON OPTIONS](#lbAG)

  - [EXIT STATUS](#lbAH)

  - [SEE ALSO](#lbAI)

-----

This document was created by [man2html](/cgi-bin/man/man2html), using
the manual pages.  
Time: 11:35:02 GMT, July 19, 2023
