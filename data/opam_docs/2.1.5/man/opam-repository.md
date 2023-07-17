---
slug: opam-repository.html
title: Manpage opam-repository
description: |
  man page on opam-repository.
---
# OPAM-REPOSITORY

Section: Opam Manual (1)  
Updated:  
[Index](#index) [Return to Main Contents](index.html)

-----

<span id="lbAB"> </span>

## NAME

opam-repository - Manage opam repositories. <span id="lbAC"> </span>

## SYNOPSIS

**opam repository** \[*OPTION*\]… \[*COMMAND*\] \[*ARG*\]…
<span id="lbAD"> </span>

## DESCRIPTION

This command is used to manage package repositories. Repositories can be
registered through subcommands **add**, **remove** and **set-url**, and
are updated from their URLs using **opam update**. Their names are
global for all switches, and each switch has its own selection of
repositories where it gets package definitions from.

Main commands **add**, **remove** and **set-repos** act only on the
current switch, unless differently specified using options explained in
**SCOPE SPECIFICATION OPTIONS**.

Without a subcommand, or with the subcommand **list**, lists selected
repositories, or all configured repositories with **--all**.
<span id="lbAE"> </span>

## COMMANDS

Without argument, defaults to **list**.

  - **add** *NAME* *\[ADDRESS\]* *\[QUORUM\]* *\[FINGERPRINTS\]*  
    Adds under *NAME* the repository at address *ADDRESS* to the list of
    configured repositories, if not already registered, and sets this
    repository for use in the current switch (or the specified scope).
    *ADDRESS* is required if the repository name is not already
    registered, and is otherwise an error if different from the
    registered address. The quorum is a positive integer that determines
    the validation threshold for signed repositories, with fingerprints
    the trust anchors for said validation.
  - ** **  
    **Note:** By default, the repository is only added to the current
    switch. To add a repository to other switches, you need to use the
    **--all** or **--set-default** options (see below). If you want to
    enable a repository only to install its switches, you may be looking
    for **opam switch create --repositories=REPOS**.
  - **remove** *NAME...*  
    Unselects the given repositories so that they will not be used to
    get package definitions anymore. With **--all**, makes opam forget
    about these repositories completely.
  - **set-repos** *NAME...*  
    Explicitly selects the list of repositories to look up package
    definitions from, in the specified priority order (overriding
    previous selection and ranks), according to the specified scope.
  - **set-url** *NAME* *ADDRESS* *\[QUORUM\]* *\[FINGERPRINTS\]*  
    Updates the URL and trust anchors associated with a given repository
    name. Note that if you don't specify *\[QUORUM\]* and
    *\[FINGERPRINTS\]*, any previous settings will be erased.
  - **list**  
    Lists the currently selected repositories in priority order from
    rank 1. With **--all**, lists all configured repositories and the
    switches where they are active.
  - **priority** *NAME* *RANK*  
    Synonym to **add NAME --rank RANK**

<span id="lbAF"> </span>

## SCOPE SPECIFICATION OPTIONS

These flags allow one to choose which selections are changed by **add**,
**remove**, **set-repos**. If no flag in this section is specified the
updated selections default to the current switch. Multiple scopes can be
selected, e.g. **--this-switch --set-default**.

  - **-a**, **--all-switches**  
    Act on the selections of all configured switches
  - **--dont-select**  
    Don't update any selections
  - **--on-switches**=*SWITCHES*  
    Act on the selections of the given list of switches
  - **--set-default**  
    Act on the default repository selection that is used for newly
    created switches
  - **--this-switch**  
    Act on the selections for the current switch (this is the default)

<span id="lbAG"> </span>

## OPTIONS

  - **-k** *KIND*, **--kind**=*KIND*  
    Specify the kind of the repository to be used (one of **http**,
    **local**, **git**, **darcs** or **hg**).
  - **--no**  
    Answer no to all opam yes/no questions without prompting. See also
    **--confirm-level**. This is equivalent to setting **$OPAMNO** to
    "true".
  - **--rank**=*RANK* (absent=**1**)  
    Set the rank of the repository in the list of configured
    repositories. Package definitions are looked in the repositories in
    increasing rank order, therefore 1 is the highest priority. Negative
    ints can be used to select from the lowest priority, -1 being last.
    **set-repos** can otherwise be used to explicitly set the repository
    list at once.
  - **-s**, **--short**  
    Output raw lists of names, one per line, skipping any details.
  - **-y**, **--yes**  
    Answer yes to all opam yes/no questions without prompting. See also
    **--confirm-level**. This is equivalent to setting **$OPAMYES** to
    "true".

<span id="lbAH"> </span>

## COMMON OPTIONS

These options are common to all commands.

  - **--best-effort**  
    Don't fail if all requested packages can't be installed: try to
    install as many as possible. Note that not all external solvers may
    support this option (recent versions of *aspcud* or *mccs* should).
    This is equivalent to setting **$OPAMBESTEFFORT** environment
    variable.
  - **--cli**=*MAJOR.MINOR* (absent=**2.1**)  
    Use the command-line interface syntax and semantics of
    *MAJOR.MINOR*. Intended for any persistent use of opam (scripts,
    blog posts, etc.), any version of opam in the same MAJOR series will
    behave as for the specified MINOR release. The flag was not
    available in opam 2.0, so to select the 2.0 CLI, set the **OPAMCLI**
    environment variable to *2.0* instead of using this parameter.
  - **--color**=*WHEN*  
    Colorize the output. *WHEN* must be one of **always**, **never** or
    **auto**.
  - **--confirm-level**=*LEVEL*  
    Confirmation level, *LEVEL* must be one of **ask**, **no**, **yes**
    or **unsafe-yes**. Can be specified more than once. If **--yes** or
    **--no** are also given, the value of the last **--confirm-level**
    is taken into account. This is equivalent to setting
    **$OPAMCONFIRMLEVEL**\`.
  - **--criteria**=*CRITERIA*  
    Specify user *preferences* for dependency solving for this run.
    Overrides both **$OPAMCRITERIA** and **$OPAMUPGRADECRITERIA**. For
    details on the supported language, and the external solvers
    available, see *<http://opam>.ocaml.org/doc/External\_solvers.html*.
    A general guide to using solver preferences can be found at
    *<http://www>.dicosmo.org/Articles/usercriteria.pdf*.
  - **--cudf**=*FILENAME*  
    Debug option: Save the CUDF requests sent to the solver to
    *FILENAME*-\<n\>.cudf.
  - **--debug**  
    Print debug message to stderr. This is equivalent to setting
    **$OPAMDEBUG** to "true".
  - **--debug-level**=*LEVEL*  
    Like **--debug**, but allows specifying the debug level (**--debug**
    sets it to 1). Equivalent to setting **$OPAMDEBUG** to a positive
    integer.
  - **--git-version**  
    Print the git version of opam, if set (i.e. you are using a
    development version), and exit.
  - **--help**\[=*FMT*\] (default=**auto**)  
    Show this help in format *FMT*. The value *FMT* must be one of
    **auto**, **pager**, **groff** or **plain**. With **auto**, the
    format is **pager** or **plain** whenever the **TERM** env var is
    **dumb** or undefined.
  - **--ignore-pin-depends**  
    Ignore extra pins required by packages that get pinned, either
    manually through *opam pin* or through *opam install DIR*. This is
    equivalent to setting **IGNOREPINDEPENDS=true**.
  - **--json**=*FILENAME*  
    Save the results of the opam run in a computer-readable file. If the
    filename contains the character \`%', it will be replaced by an
    index that doesn't overwrite an existing file. Similar to setting
    the **$OPAMJSON** variable.
  - **--no-aspcud**  
    Removed in **2.1**.
  - **--no-auto-upgrade**  
    When configuring or updating a repository that is written for an
    earlier opam version (1.2), opam internally converts it to the
    current format. This disables this behaviour. Note that repositories
    should define their format version in a 'repo' file at their root,
    or they will be assumed to be in the older format. It is, in any
    case, preferable to upgrade the repositories manually using *opam
    admin upgrade \[--mirror URL\]* when possible.
  - **--no-self-upgrade**  
    Opam will replace itself with a newer binary found at
    **OPAMROOT/opam** if present. This disables this behaviour.
  - **-q**, **--quiet**  
    Disables **--verbose**.
  - **--root**=*ROOT*  
    Use *ROOT* as the current root path. This is equivalent to setting
    **$OPAMROOT** to *ROOT*.
  - **--safe**, **--readonly**  
    Make sure nothing will be automatically updated or rewritten. Useful
    for calling from completion scripts, for example. Will fail whenever
    such an operation is needed ; also avoids waiting for locks, skips
    interactive questions and overrides the **$OPAMDEBUG** variable.
    This is equivalent to set environment variable **$OPAMSAFE**.
  - **--solver**=*CMD*  
    Specify the CUDF solver to use for resolving package installation
    problems. This is either a predefined solver (this version of opam
    supports builtin-mccs+lp(), builtin-mccs+glpk,
    builtin-dummy-z3-solver, builtin-0install, aspcud, mccs, aspcud-old,
    packup), or a custom command that should contain the variables
    %{input}%, %{output}%, %{criteria}%, and optionally %{timeout}%.
    This is equivalent to setting **$OPAMEXTERNALSOLVER**.
  - **--strict**  
    Fail whenever an error is found in a package definition or a
    configuration file. The default is to continue silently if possible.
  - **--switch**=*SWITCH*  
    Use *SWITCH* as the current compiler switch. This is equivalent to
    setting **$OPAMSWITCH** to *SWITCH*.
  - **--use-internal-solver**  
    Disable any external solver, and use the built-in one (this requires
    that opam has been compiled with a built-in solver). This is
    equivalent to setting **$OPAMNOASPCUD** or
    **$OPAMUSEINTERNALSOLVER**.
  - **-v**, **--verbose**  
    Be more verbose. One **-v** shows all package commands, repeat to
    also display commands called internally (e.g. *tar*, *curl*, *patch*
    etc.) Repeating *n* times is equivalent to setting **$OPAMVERBOSE**
    to "*n*".
  - **--version**  
    Show version information.
  - **-w**, **--working-dir**  
    Whenever updating packages that are bound to a local,
    version-controlled directory, update to the current working state of
    their source instead of the last committed state, or the ref they
    are pointing to. As source directory is copied as it is, if it isn't
    clean it may result on a opam build failure.This only affects
    packages explicitly listed on the command-line.It can also be set
    with **$OPAMWORKINGDIR**.

<span id="lbAI"> </span>

## ENVIRONMENT

Opam makes use of the environment variables listed here. Boolean
variables should be set to "0", "no", "false" or the empty string to
disable, "1", "yes" or "true" to enable.

*OPAMALLPARENS* surround all filters with parenthesis.

*OPAMASSUMEDEPEXTS* see option \`--assume-depexts'.

*OPAMAUTOREMOVE* see remove option \`--auto-remove'.

*OPAMBESTEFFORT* see option \`--best-effort'.

*OPAMBESTEFFORTPREFIXCRITERIA* sets the string that must be prepended to
the criteria when the \`--best-effort' option is set, and is expected to
maximise the \`opam-query' property in the solution.

*OPAMBUILDDOC* Removed in **2.1**.

*OPAMBUILDTEST* Removed in **2.1**.

*OPAMCLI* see option \`--cli'.

*OPAMCOLOR* when set to *always* or *never*, sets a default value for
the \`--color' option.

*OPAMCONFIRMLEVEL* see option \`--confirm-level\`. **OPAMCONFIRMLEVEL**
has priority over **OPAMYES** and **OPAMNO**.

*OPAMCRITERIA* specifies user *preferences* for dependency solving. The
default value depends on the solver version, use \`config report' to
know the current setting. See also option --criteria.

*OPAMCUDFFILE* save the cudf graph to *file*-actions-explicit.dot.

*OPAMCUDFTRIM* controls the filtering of unrelated packages during CUDF
preprocessing.

*OPAMCURL* can be used to select a given 'curl' program. See *OPAMFETCH*
for more options.

*OPAMDEBUG* see options \`--debug' and \`--debug-level'.

*OPAMDEBUGSECTIONS* if set, limits debug messages to the space-separated
list of sections. Sections can optionally have a specific debug level
(for example, **CLIENT:2** or **CLIENT CUDF:2**), but otherwise use
\`--debug-level'.

*OPAMDIGDEPTH* defines how aggressive the lookup for conflicts during
CUDF preprocessing is.

*OPAMDOWNLOADJOBS* sets the maximum number of simultaneous downloads.

*OPAMDROPWORKINGDIR* overrides packages previously updated with
**--working-dir** on update. Without this variable set, opam would keep
them unchanged unless explicitly named on the command-line.

*OPAMDRYRUN* see option \`--dry-run'.

*OPAMEDITOR* sets the editor to use for opam file editing, overrides
*$EDITOR* and *$VISUAL*.

*OPAMERRLOGLEN* sets the number of log lines printed when a sub-process
fails. 0 to print all.

*OPAMEXTERNALSOLVER* see option \`--solver'.

*OPAMFAKE* see option \`--fake'.

*OPAMFETCH* specifies how to download files: either \`wget', \`curl' or
a custom command where variables **%{url}%**, **%{out}%**,
**%{retry}%**, **%{compress}%** and **%{checksum}%** will be replaced.
Overrides the 'download-command' value from the main config file.

*OPAMFIXUPCRITERIA* same as *OPAMUPGRADECRITERIA*, but specific to
fixup.

*OPAMIGNORECONSTRAINTS* see install option \`--ignore-constraints-on'.

*OPAMIGNOREPINDEPENDS* see option \`--ignore-pin-depends'.

*OPAMINPLACEBUILD* see option \`--inplace-build'.

*OPAMJOBS* sets the maximum number of parallel workers to run.

*OPAMJSON* log json output to the given file (use character \`%' to
index the files).

*OPAMKEEPBUILDDIR* see install option \`--keep-build-dir'.

*OPAMKEEPLOGS* tells opam to not remove some temporary command logs and
some backups. This skips some finalisers and may also help to get more
reliable backtraces.

*OPAMLOCKED* combination of \`--locked' and \`--lock-suffix' options.

*OPAMLOGS* *logdir* sets log directory, default is a temporary directory
in /tmp

*OPAMMAKECMD* set the system make command to use.

*OPAMMERGEOUT* merge process outputs, stderr on stdout.

*OPAMNO* answer no to any question asked, see options \`--no\` and
\`--confirm-level\`. **OPAMNO** is ignored if either
**OPAMCONFIRMLEVEL** or **OPAMYES** is set.

*OPAMNOAGGREGATE* with \`opam admin check', don't aggregate packages.

*OPAMNOASPCUD* Deprecated.

*OPAMNOAUTOUPGRADE* disables automatic internal upgrade of repositories
in an earlier format to the current one, on 'update' or 'init'.

*OPAMNOCHECKSUMS* enables option --no-checksums when available.

*OPAMNODEPEXTS* disables system dependencies handling, see option
\`--no-depexts'.

*OPAMNOENVNOTICE* Internal.

*OPAMNOSELFUPGRADE* see option \`--no-self-upgrade'

*OPAMPINKINDAUTO* sets whether version control systems should be
detected when pinning to a local path. Enabled by default since 1.3.0.

*OPAMPRECISETRACKING* fine grain tracking of directories.

*OPAMPREPRO* set this to false to disable CUDF preprocessing. Less
efficient, but might help debugging solver issue.

*OPAMREQUIRECHECKSUMS* Enables option \`--require-checksums' when
available (e.g. for \`opam install').

*OPAMRETRIES* sets the number of tries before failing downloads.

*OPAMREUSEBUILDDIR* see option \`--reuse-build-dir'.

*OPAMROOT* see option \`--root'. This is automatically set by \`opam env
--root=DIR --set-root'.

*OPAMROOTISOK* don't complain when running as root.

*OPAMSAFE* see option \`--safe'.

*OPAMSHOW* see option \`--show'.

*OPAMSKIPUPDATE* see option \`--skip-updates'.

*OPAMSKIPVERSIONCHECKS* bypasses some version checks. Unsafe, for
compatibility testing only.

*OPAMSOLVERALLOWSUBOPTIMAL* (default \`true') allows some solvers to
still return a solution when they reach timeout; while the solution
remains assured to be consistent, there is no guarantee in this case
that it fits the expected optimisation criteria. If \`true', opam
willcontinue with a warning, if \`false' a timeout is an error.
Currently only the builtin-z3 backend handles this degraded case.

*OPAMSOLVERTIMEOUT* change the time allowance of the solver. Default is
60.0, set to 0 for unlimited. Note that all solvers may not support this
option.

*OPAMSTATS* display stats at the end of command.

*OPAMSTATUSLINE* display a dynamic status line showing what's currently
going on on the terminal. (one of one of **always**, **never** or
**auto**)

*OPAMSTRICT* fail on inconsistencies (file reading, switch import,
etc.).

*OPAMSWITCH* see option \`--switch'. Automatically set by \`opam env
--switch=SWITCH --set-switch'.

*OPAMUNLOCKBASE* see install option \`--unlock-base'.

*OPAMUPGRADECRITERIA* specifies user *preferences* for dependency
solving when performing an upgrade. Overrides *OPAMCRITERIA* in upgrades
if both are set. See also option --criteria.

*OPAMUSEINTERNALSOLVER* see option \`--use-internal-solver'.

*OPAMUSEOPENSSL* force openssl use for hash computing.

*OPAMUTF8* use UTF8 characters in output (one of one of **always**,
**never** or **auto**). By default \`auto', which is determined from the
locale).

*OPAMUTF8MSGS* use extended UTF8 characters (camels) in opam messages.
Implies *OPAMUTF8*. This is set by default on OSX only.

*OPAMVALIDATIONHOOK* if set, uses the \`%{hook%}' command to validate an
opam repository update.

*OPAMVERBOSE* see option \`--verbose'.

*OPAMVERSIONLAGPOWER* do not use.

*OPAMWITHDOC* see install option \`--with-doc'.

*OPAMWITHTEST* see install option \`--with-test.

*OPAMWORKINGDIR* see option \`--working-dir'.

*OPAMYES* see options \`--yes' and \`--confirm-level\`. **OPAMYES** has
has priority over **OPAMNO** and is ignored if **OPAMCONFIRMLEVEL** is
set.

*OPAMVAR\_var* overrides the contents of the variable *var* when
substituting \`%{var}%\` strings in \`opam\` files.

*OPAMVAR\_package\_var* overrides the contents of the variable
*package:var* when substituting \`%{package:var}%\` strings in \`opam\`
files. <span id="lbAJ"> </span>

## CLI VERSION

All scripts and programmatic invocations of opam should use \`--cli' in
order to ensure that they work seamlessly with future versions of the
opam client. Additionally, blog posts or other documentation can
benefit, as it prevents information from becoming stale.

Although opam only supports roots (*\~/.opam/*) for the current version,
it does provide backwards compatibility for its command-line interface.

Since CLI version support was only added in opam 2.1, use *OPAMCLI* to
select 2.0 support (as opam 2.0 will just ignore it), and \`--cli=2.1'
for 2.1 (or later) versions, since an environment variable controlling
the parsing of syntax is brittle. To this end, opam displays a warning
if *OPAMCLI* specifies a valid version other than 2.0, and also if
\`--cli=2.0' is specified.

The command-line version is selected by using the \`--cli' option or the
*OPAMCLI* environment variable. \`--cli' may be specified morethan once,
where the last instance takes precedence. *OPAMCLI* is only inspected if
\`--cli' is not given. <span id="lbAK"> </span>

## EXIT STATUS

As an exception to the following, the \`exec' command returns 127 if the
command was not found or couldn't be executed, and the command's exit
value otherwise.

  - 0  
    Success, or true for boolean queries.
  - 1  
    False. Returned when a boolean return value is expected, e.g. when
    running with **--check**, or for queries like **opam lint**.
  - 2  
    Bad command-line arguments, or command-line arguments pointing to an
    invalid context (e.g. file not following the expected format).
  - 5  
    Not found. You requested something (package, version, repository,
    etc.) that couldn't be found.
  - 10  
    Aborted. The operation required confirmation, which wasn't given.
  - 15  
    Could not acquire the locks required for the operation.
  - 20  
    There is no solution to the user request. This can be caused by
    asking to install two incompatible packages, for example.
  - 30  
    Error in package definition, or other metadata files. Using
    **--strict** raises this error more often.
  - 31  
    Package script error. Some package operations were unsuccessful.
    This may be an error in the packages or an incompatibility with your
    system. This can be a partial error.
  - 40  
    Sync error. Could not fetch some remotes from the network. This can
    be a partial error.
  - 50  
    Configuration error. Opam or system configuration doesn't allow
    operation, and needs fixing.
  - 60  
    Solver failure. The solver failed to return a sound answer. It can
    be due to a broken external solver, or an error in solver
    configuration.
  - 99  
    Internal error. Something went wrong, likely due to a bug in opam
    itself.
  - 130  
    User interrupt. SIGINT was received, generally due to the user
    pressing Ctrl-C.

<span id="lbAL"> </span>

## FURTHER DOCUMENTATION

See <https://opam>.ocaml.org/doc. <span id="lbAM"> </span>

## AUTHORS

Vincent Bernardoff \<<vb@luminar>.eu.org\>

Raja Boujbel \<raja.<boujbel@ocamlpro>.com\>

Roberto Di Cosmo \<<roberto@dicosmo>.org\>

Thomas Gazagnaire \<<thomas@gazagnaire>.org\>

Louis Gesbert \<louis.<gesbert@ocamlpro>.com\>

Fabrice Le Fessant \<Fabrice.<Le_fessant@inria>.fr\>

Anil Madhavapeddy \<<anil@recoil>.org\>

Guillem Rieu \<guillem.<rieu@ocamlpro>.com\>

Ralf Treinen \<ralf.treinen@pps.jussieu.fr\>

Frederic Tuong \<<tuong@users>.gforge.inria.fr\>
<span id="lbAN"> </span>

## BUGS

Check bug reports at <https://github>.com/ocaml/opam/issues.

-----

<span id="index"> </span>

## Index

  - [NAME](#lbAB)

  - [SYNOPSIS](#lbAC)

  - [DESCRIPTION](#lbAD)

  - [COMMANDS](#lbAE)

  - [SCOPE SPECIFICATION OPTIONS](#lbAF)

  - [OPTIONS](#lbAG)

  - [COMMON OPTIONS](#lbAH)

  - [ENVIRONMENT](#lbAI)

  - [CLI VERSION](#lbAJ)

  - [EXIT STATUS](#lbAK)

  - [FURTHER DOCUMENTATION](#lbAL)

  - [AUTHORS](#lbAM)

  - [BUGS](#lbAN)

-----

This document was created by [man2html](/cgi-bin/man/man2html), using
the manual pages.  
Time: 09:45:51 GMT, July 19, 2023
