---
slug: opam-switch.html
title: Manpage opam-switch
description: |
  man page on opam-switch.
---
# OPAM-SWITCH

Section: Opam Manual (1)  
Updated:  
[Index](#index) [Return to Main Contents](index.html)

-----

<span id="lbAB"> </span>

## NAME

opam-switch - Manage multiple installation prefixes.
<span id="lbAC"> </span>

## SYNOPSIS

**opam switch** \[*OPTION*\]… \[*COMMAND*\] \[*ARG*\]…
<span id="lbAD"> </span>

## DESCRIPTION

This command is used to manage "switches", which are independent
installation prefixes with their own compiler and sets of installed and
pinned packages. This is typically useful to have different versions of
the compiler available at once.

Use **opam switch create** to create a new switch, and **opam switch
set** to set the currently active switch. Without argument, lists
installed switches, with one switch argument, defaults to **set**.

Switch handles *SWITCH* can be either a plain name, for switches that
will be held inside *\~/.opam*, or a directory name, which in that case
is the directory where the switch prefix will be installed, as \_opam.
Opam will automatically select a switch by that name found in the
current directory or its parents, unless *OPAMSWITCH* is set or
**--switch** is specified. When creating a directory switch, if package
definitions are found locally, the user is automatically prompted to
install them after the switch is created unless **--no-install** is
specified.

**opam switch set** sets the default switch globally, but it is also
possible to select a switch in a given shell session, using the
environment. For that, use *eval $(opam env --switch=SWITCH
--set-switch)*. <span id="lbAE"> </span>

## COMMANDS

Without argument, defaults to **list**.

  - *SWITCH*  
    With a *SWITCH* argument, defaults to **set** *SWITCH*.
  - **create** *SWITCH* *\[COMPILER\]*  
    Create a new switch, and install the given compiler there. *SWITCH*
    can be a plain name, or a directory, absolute or relative, in which
    case a local switch is created below the given directory.
    *COMPILER*, if omitted, defaults to *SWITCH* if it is a plain name,
    unless **--packages**, **--formula** or **--empty** is specified.
    When creating a local switch, and none of these options are present,
    the compiler is chosen according to the configuration default (see
    opam-[init](../man1/init.1.html)(1)). If the chosen directory
    contains package definitions, a compatible compiler is searched
    within the default selection, and the packages will automatically
    get installed.
  - **set** *SWITCH*  
    Set the currently active switch, among the installed switches.
  - **remove** *SWITCH*  
    Remove the given switch from disk.
  - **export** *FILE*  
    Save the current switch state to a file. If **--full** is specified,
    it includes the metadata of all installed packages, and if
    **--freeze** is specified, it freezes all vcs to their current
    commit.
  - **import** *FILE*  
    Import a saved switch state. If **--switch** is specified and
    doesn't point to an existing switch, the switch will be created for
    the import.
  - **reinstall** *\[SWITCH\]*  
    Reinstall the given compiler switch and all its packages.
  - **list**  
    Lists installed switches.
  - **list-available** *\[PATTERN\]*  
    Lists all the possible packages that are advised for installation
    when creating a new switch, i.e. packages with the *compiler* flag
    set. If no pattern is supplied, all versions are shown.
  - **show**  
    Prints the name of the current switch.
  - **invariant**  
    Prints the active switch invariant.
  - **set-invariant** *PACKAGES*  
    Updates the switch invariant, that is, the formula that the switch
    must keep verifying throughout all operations. The previous setting
    is overriden. See also options **--force** and **--no-action**.
    Without arguments, an invariant is chosen automatically.
  - **set-description** *STRING*  
    Sets the description for the selected switch.
  - **link** *SWITCH* *\[DIR\]*  
    Sets a local alias for a given switch, so that the switch gets
    automatically selected whenever in that directory or a descendant.
  - **install** *SWITCH*  
    Removed in **2.1**, use *create* instead.
  - **set-base** *PACKAGES*  
    Removed in **2.1**, use *set-invariant* instead.

<span id="lbAF"> </span>

## EXAMPLES

``` 
    opam switch create 4.08.0
```

Create a new switch called "4.08.0" and select it, with a compiler
automatically selected at version 4.08.0 (note that this can fail in
case there is more than one compiler matching that version).

``` 
    opam switch create ./ --deps-only
```

Prepare a local switch for building the packages defined in *./*. This
scans the current directory for package definitions, chooses a
compatible compiler, creates a local switch and installs the local
package dependencies.

``` 
    opam switch create trunk --repos default,beta=git+https://github.com/ocaml/ocaml-beta-repository.git ocaml-variants.4.10.0+trunk
```

Create a new switch called "trunk", with **ocaml-variants.4.10.0+trunk**
as compiler, with a new *beta* repository bound to the given URL
selected besides the default one. <span id="lbAG"> </span>

## OPTIONS

  - **-A** *COMP*, **--alias-of**=*COMP*  
    Removed in **2.1**.
  - **--deps-only**  
    When creating a local switch in a project directory (i.e. a
    directory containing opam package definitions), install the
    dependencies of the project but not the project itself.
  - **--description**=*STRING*  
    Attach the given description to a switch when creating it. Use the
    *set-description* subcommand to modify the description of an
    existing switch.
  - **--empty**  
    Allow creating an empty switch, with no invariant.
  - **--force**  
    Only for *set-invariant*: force setting the invariant, bypassing
    consistency checks.
  - **--formula**=*FORMULA*  
    Allows specifying a complete "dependency formula", possibly
    including disjunction cases, as the switch invariant.
  - **--freeze**  
    When exporting, locks all VCS urls to their current commit, failing
    if it can not be retrieved. This ensures that an import will restore
    the exact state. Implies **--full**.
  - **--full**  
    When exporting, include the metadata of all installed packages,
    allowing to re-import even if they don't exist in the repositories
    (the default is to include only the metadata of pinned packages).
  - **-j** *JOBS*, **--jobs**=*JOBS*  
    Set the maximal number of concurrent jobs to use. The default value
    is calculated from the number of cores. You can also set it using
    the **$OPAMJOBS** environment variable.
  - **-n**, **--no-action**  
    Only for *set-invariant*: set the invariant, but don't enforce it
    right away: wait for the next *install*, *upgrade* or similar
    command.
  - **--no**  
    Answer no to all opam yes/no questions without prompting. See also
    **--confirm-level**. This is equivalent to setting **$OPAMNO** to
    "true".
  - **--no-autoinstall**  
    Removed in **2.1**.
  - **--no-install**  
    When creating a local switch, don't look for any local package
    definitions to install.
  - **--no-switch**  
    Don't automatically select newly installed switches.
  - **--packages**=*PACKAGES*  
    When installing a switch, explicitly define the set of packages to
    enforce as the switch invariant.
  - **--repositories**=*REPOS*  
    When creating a new switch, use the given selection of repositories
    instead of the default. *REPOS* should be a comma-separated list of
    either already registered repository names (configured through e.g.
    *opam repository add --dont-select*), or **NAME**=**URL** bindings,
    in which case **NAME** should not be registered already to a
    different URL, and the new repository will be registered. See *opam
    repository* for more details. This option also affects
    *list-available*.
  - **-s**, **--short**  
    Output raw lists of names, one per line, skipping any details.
  - **-y**, **--yes**  
    Answer yes to all opam yes/no questions without prompting. See also
    **--confirm-level**. This is equivalent to setting **$OPAMYES** to
    "true".

<span id="lbAH"> </span>

## PACKAGE BUILD OPTIONS

  - **--assume-depexts**  
    Skip the installation step for any missing system packages, and
    attempt to proceed with compilation of the opam packages anyway. If
    the installation is successful, opam won't prompt again about these
    system packages. Only meaningful if external dependency handling is
    enabled.
  - **-b**, **--keep-build-dir**  
    Keep the build directories after compiling packages. This is
    equivalent to setting **$OPAMKEEPBUILDDIR** to "true".
  - **--build-doc**  
    Removed in **2.1**, use *--with-doc* instead.
  - **--build-test**  
    Removed in **2.1**, use *--with-test* instead.
  - **-d**, **--with-doc**  
    Build the package documentation. This only affects packages listed
    on the command-line. This is equivalent to setting **$OPAMWITHDOC**
    (or the deprecated **$OPAMBUILDDOC**) to "true".
  - **--dry-run**  
    Simulate the command, but don't actually perform any changes. This
    also can be set with environment variable **$OPAMDEBUG**.
  - **--fake**  
    This option registers the actions into the opam database, without
    actually performing them. WARNING: This option is dangerous and
    likely to break your opam environment. You probably want
    **--dry-run**. You've been *warned*.
  - **--ignore-constraints-on**\[=*PACKAGES*\] (default=****)  
    Forces opam to ignore version constraints on all dependencies to the
    listed packages. This can be used to test compatibility, but expect
    builds to break when using this. Note that version constraints on
    optional dependencies and conflicts are unaffected. This is
    equivalent to setting **$OPAMIGNORECONSTRAINTS**.
  - **--inplace-build**  
    When compiling a package which has its source bound to a local
    directory, process the build and install actions directly in that
    directory, rather than in a clean copy handled by opam. This only
    affects packages that are explicitly listed on the command-line.
    This is equivalent to setting **$OPAMINPLACEBUILD** to "true".
  - **--lock-suffix**=*SUFFIX* (absent=**locked**)  
    Set locked files suffix to *SUFFIX*.
  - **--locked**  
    In commands that use opam files found from pinned sources, if a
    variant of the file with an added .*locked* extension is found (e.g.
    **foo.opam.locked** besides **foo.opam**), that will be used
    instead. This is typically useful to offer a more specific set of
    dependencies and reproduce similar build contexts, hence the name.
    The *lock*option can be used to generate such files, based on the
    versions of the dependencies currently installed on the host. This
    is equivalent to setting the **$OPAMLOCKED** environment variable.
    Note that this option doesn't generally affect already pinned
    packages.
  - **-m** *MAKE*, **--make**=*MAKE*  
    Removed in **2.1**, use *opam config set\[-global\] make MAKE*
    instead.
  - **--no-checksums**  
    Do not verify the checksum of downloaded archives.This is equivalent
    to setting **$OPAMNOCHECKSUMS** to "true".
  - **--no-depexts**  
    Temporarily disables handling of external dependencies. This can be
    used if a package is not available on your system package manager,
    but you installed the required dependency by hand. Implies
    **--assume-depexts**, and stores the exceptions upon success as
    well.
  - **--require-checksums**  
    Reject the installation of packages that don't provide a checksum
    for the upstream archives. This is equivalent to setting
    **$OPAMREQUIRECHECKSUMS** to "true".
  - **--reuse-build-dir**  
    Reuse existing build directories (kept by using
    **--keep-build-dir**), instead of compiling from a fresh clone of
    the source. This can be faster, but also lead to failures if the
    build systems of the packages don't handle upgrades of dependencies
    well. This is equivalent to setting **$OPAMREUSEBUILDDIR** to
    "true".
  - **--show-actions**  
    Call the solver and display the actions. Don't perform any changes.
    This is equivalent to setting **$OPAMSHOW**.
  - **--skip-updates**  
    When running an install, upgrade or reinstall on source-pinned
    packages, they are normally updated from their origin first. This
    flag disables that behaviour and will keep them to their version in
    cache. This is equivalent to setting **$OPAMSKIPUPDATE**.
  - **-t**, **--with-test**  
    Build and **run** the package unit-tests. This only affects packages
    listed on the command-line. This is equivalent to setting
    **$OPAMWITHTEST** (or the deprecated **$OPAMBUILDTEST**) to "true".
  - **--unlock-base**  
    Removed in **2.1**, use *--update-invariant* instead.
  - **--update-invariant**  
    Allow changes to the packages set as switch base (typically, the
    main compiler). Use with caution. This is equivalent to setting the
    **$OPAMUNLOCKBASE** environment variable

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

  - [COMMANDS](#lbAE)

  - [EXAMPLES](#lbAF)

  - [OPTIONS](#lbAG)

  - [PACKAGE BUILD OPTIONS](#lbAH)

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
