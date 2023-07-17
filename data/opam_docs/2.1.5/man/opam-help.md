---
slug: opam-help.html
title: Manpage opam-help
description: |
  man page on opam-help.
---
# OPAM-HELP

Section: Opam Manual (1)  
Updated:  
[Index](#index) [Return to Main Contents](index.html)

-----

<span id="lbAB"> </span>

## NAME

opam-help - Display help about opam and opam commands.
<span id="lbAC"> </span>

## SYNOPSIS

**opam help** \[**--man-format**=*FMT*\] \[*OPTION*\]… \[*TOPIC*\]
<span id="lbAD"> </span>

## DESCRIPTION

Prints help about opam commands.

Use \`**opam** help topics' to get the full list of help topics.
<span id="lbAE"> </span>

## ARGUMENTS

  - *TOPIC*  
    The topic to get help on.

<span id="lbAF"> </span>

## OPTIONS

  - **--help**\[=*FMT*\] (default=**auto**)  
    Show this help in format *FMT*. The value *FMT* must be one of
    **auto**, **pager**, **groff** or **plain**. With **auto**, the
    format is **pager** or **plain** whenever the **TERM** env var is
    **dumb** or undefined.
  - **--man-format**=*FMT* (absent=**pager**)  
    Show output in format *FMT*. The value *FMT* must be one of
    **auto**, **pager**, **groff** or **plain**. With **auto**, the
    format is **pager** or **plain** whenever the **TERM** env var is
    **dumb** or undefined.
  - **--version**  
    Show version information.

-----

<span id="index"> </span>

## Index

  - [NAME](#lbAB)

  - [SYNOPSIS](#lbAC)

  - [DESCRIPTION](#lbAD)

  - [ARGUMENTS](#lbAE)

  - [OPTIONS](#lbAF)

-----

This document was created by [man2html](/cgi-bin/man/man2html), using
the manual pages.  
Time: 09:45:51 GMT, July 19, 2023
