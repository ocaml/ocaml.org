---
slug: opam-list.html
title: Manpage opam-list
description: |
  man page on opam-list.
---
# OPAM-LIST

Section: Opam Manual (1)  
Updated:  
[Index](#index) [Return to Main Contents](index.html)

-----

<span id="lbAB"> </span>

## NAME

opam-list - Display the list of available packages.
<span id="lbAC"> </span>

## SYNOPSIS

**opam list** \[*OPTION*\]… \[*PATTERNS*\]… <span id="lbAD"> </span>

## DESCRIPTION

List selections of opam packages.

Without argument, the command displays the list of currently installed
packages. With pattern arguments, lists all available packages matching
one of the patterns.

Unless the **--short** switch is used, the output format displays one
package per line, and each line contains the name of the package, the
installed version or \`--' if the package is not installed, and a short
description. In color mode, manually installed packages (as opposed to
automatically installed ones because of dependencies) are underlined.

See section **PACKAGE SELECTION OPTIONS** for all the ways to select the
packages to be displayed, and section **OUTPUT FORMAT OPTIONS** to
customise the output format.

For a more detailed description of packages, see **opam show**. For
extended search capabilities within the packages' metadata, see **opam
search**. <span id="lbAE"> </span>

## ARGUMENTS

  - *PATTERNS*  
    Package patterns with globs. Unless **--search** is specified, they
    match againsta **NAME** or **NAME.VERSION**

<span id="lbAF"> </span>

## PACKAGE SELECTION OPTIONS

  - **-a**, **--available**  
    List only packages that are available on the current system
  - **-A**, **--all**  
    Include all, even uninstalled or unavailable packages
  - **--base**  
    List only the immutable base of the current switch (i.e. compiler
    packages)
  - **--coinstallable-with**=*PACKAGES*  
    Only list packages that are compatible with all of **PACKAGES**.
  - **--conflicts-with**=*PACKAGES*  
    List packages that have declared conflicts with at least one of the
    given list. This includes conflicts defined from the packages in the
    list, from the other package, or by a common **conflict-class:**
    field.
  - **--depends-on**=*PACKAGES*  
    List only packages that depend on one of (comma-separated)
    **PACKAGES**.
  - **--depopts**  
    Include optional dependencies in dependency requests.
  - **--dev**  
    Include development packages in dependencies.
  - **--field-match**=*FIELD:PATTERN*  
    Filter packages with a match for *PATTERN* on the given *FIELD*
  - **--has-flag**=*FLAG*  
    Only include packages which have the given flag set. Package flags
    are one of: **light-uninstall** **verbose** **plugin** **compiler**
    **conf**
  - **--has-tag**=*TAG*  
    Only includes packages which have the given tag set
  - **-i**, **--installed**  
    List installed packages only. This is the default when no further
    arguments are supplied
  - **--installable**  
    List only packages that can be installed on the current switch (this
    calls the solver and may be more costly; a package depending on an
    unavailable package may be available, but is never installable)
  - **--no-switch**  
    List what is available from the repositories, without consideration
    for the current (or any other) switch (installed or pinned packages,
    etc.)
  - **--nobuild**  
    Exclude build dependencies (they are included by default).
  - **--or**  
    Instead of selecting packages that match *all* the criteria, select
    packages that match *any* of them
  - **--owns-file**=*FILE*  
    Finds installed packages responsible for installing the given file
  - **--pinned**  
    List only the pinned packages
  - **--post**  
    Include dependencies tagged as *post*.
  - **--recursive**  
    With \`--depends-on' and \`--required-by', display all transitive
    dependencies rather than just direct dependencies.
  - **--repos**=*REPOS*  
    Include only packages that took their origin from one of the given
    repositories (unless *no-switch* is also specified, this excludes
    pinned packages).
  - **--required-by**=*PACKAGES*  
    List only the dependencies of (comma-separated) **PACKAGES**.
  - **--resolve**=*PACKAGES*  
    Restrict to a solution to install (comma-separated) *PACKAGES*,
    *i.e.* a consistent set of packages including those. This is subtly
    different from \`--required-by --recursive\`, which is more
    predictable and can't fail, but lists all dependencies independently
    without ensuring consistency. Without \`--installed\`, the answer is
    self-contained and independent of the current installation. With
    \`--installed', it's computed from the set of currently installed
    packages. \`--no-switch\` further makes the solution independent
    from the currently pinned packages, architecture, and compiler
    version. The combination with \`--depopts' is not supported.
  - **--roots**, **--installed-roots**  
    List only packages that were explicitly installed, excluding the
    ones installed as dependencies
  - **--search**  
    Match *PATTERNS* against the full descriptions of packages, and
    require all of them to match, instead of requiring at least one to
    match against package names (unless **--or** is also specified).
  - **-t**, **--with-test**, **--test**  
    Include test-only dependencies.
  - **--with-doc**, **--doc**  
    Include doc-only dependencies.

<span id="lbAG"> </span>

## OUTPUT FORMAT OPTIONS

  - **--columns**=*COLUMNS*  
    Select the columns to display among: **name**, **version**,
    **package**, **synopsis**, **synopsis-or-target**, **description**,
    **\<field\>:**, **installed-version**, **pin**, **source-hash**,
    **opam-file**, **all-installed-versions**, **available-versions**,
    **all-versions**, **repository**, **installed-files**, **vc-ref**,
    **depexts**. The default is **name** when *--short* is present and
    **name**, **installed-version**, **synopsis-or-target** otherwise.
  - **-e**, **--external**, **--depexts**  
    Instead of displaying the packages, display their external
    dependencies that are associated with the current system. This
    excludes other display options. Rather than using this directly, you
    should probably head for the \`depext' plugin, that will use your
    system package management system to handle the installation of the
    dependencies. Run \`opam depext'.
  - **--normalise**  
    Print the values of opam fields normalised
  - **-S**, **--sort**  
    Sort the packages in dependency order (i.e. an order in which they
    could be individually installed.)
  - **-s**, **--short**  
    Don't print a header, and sets the default columns to **name** only.
    If you need package versions included, use **--columns=package**
    instead
  - **--separator**=*STRING* (absent= **** )  
    Set the column-separator string
  - **-V**, **--all-versions**  
    Normally, when multiple versions of a package match, only one is
    shown in the output (the installed one, the pinned-to one, or,
    failing that, the highest one available or the highest one). This
    flag disables this behaviour and shows all matching versions. This
    also changes the default display format to include package versions
    instead of just package names (including when --short is set). This
    is automatically turned on when a single non-pattern package name is
    provided on the command-line.
  - **--vars**=*\[VAR=STR,...\]*  
    Define the given variable bindings. Typically useful with
    **--external** to override the values for *arch*, *os*,
    *os-distribution*, *os-version*, *os-family*.
  - **--wrap**  
    Wrap long lines, the default being to truncate when displaying on a
    terminal, or to keep as is otherwise

<span id="lbAH"> </span>

## OPTIONS

  - **--check**  
    Don't write anything in the output, exit with return code 0 if the
    list is not empty, 1 otherwise.
  - **--no**  
    Answer no to all opam yes/no questions without prompting. See also
    **--confirm-level**. This is equivalent to setting **$OPAMNO** to
    "true".
  - **--no-depexts**  
    Disable external dependencies handling for the query. This can be
    used to include packages that are marked as unavailable because of
    an unavailable system dependency.
  - **--silent**  
    Removed in **2.1**, use *--check* instead.
  - **-y**, **--yes**  
    Answer yes to all opam yes/no questions without prompting. See also
    **--confirm-level**. This is equivalent to setting **$OPAMYES** to
    "true".

<span id="lbAI"> </span>

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

<span id="lbAJ"> </span>

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
files. <span id="lbAK"> </span>

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
\`--cli' is not given. <span id="lbAL"> </span>

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

<span id="lbAM"> </span>

## FURTHER DOCUMENTATION

See <https://opam>.ocaml.org/doc. <span id="lbAN"> </span>

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
<span id="lbAO"> </span>

## BUGS

Check bug reports at <https://github>.com/ocaml/opam/issues.

-----

<span id="index"> </span>

## Index

  - [NAME](#lbAB)

  - [SYNOPSIS](#lbAC)

  - [DESCRIPTION](#lbAD)

  - [ARGUMENTS](#lbAE)

  - [PACKAGE SELECTION OPTIONS](#lbAF)

  - [OUTPUT FORMAT OPTIONS](#lbAG)

  - [OPTIONS](#lbAH)

  - [COMMON OPTIONS](#lbAI)

  - [ENVIRONMENT](#lbAJ)

  - [CLI VERSION](#lbAK)

  - [EXIT STATUS](#lbAL)

  - [FURTHER DOCUMENTATION](#lbAM)

  - [AUTHORS](#lbAN)

  - [BUGS](#lbAO)

-----

This document was created by [man2html](/cgi-bin/man/man2html), using
the manual pages.  
Time: 09:45:51 GMT, July 19, 2023
