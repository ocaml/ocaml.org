---
id: "platform-roadmap"
title: "OCaml Platform Roadmap"
description: The 2024-2026 roadmap for the OCaml Platform.
category: "OCaml Platform"
---

This document delineates a three-year roadmap (2024 through 2026) for the OCaml
Platform. It defines the developer experience we aspire to actualise in the
coming years.

The OCaml Platform is a collection of tools, each designed to facilitate diverse
development workflows. Each tool has its unique vision and roadmap. The aim of
this document is not to chart those roadmaps. Rather, it is to provide an
overarching guideline for them, ensuring that the individual tools' roadmaps
align cohesively with a larger vision for the OCaml development experience.

The core objective of this document is to articulate the kind of developer
experience we, the OCaml Platform team and the wider OCaml Community, aim to
deliver. In doing so, we strive to maintain a user-oriented perspective, delving
into technical details only when necessary.

The structure of this roadmap is underpinned by the development workflows that
the OCaml Platform aims to support. Each workflow is defined as a series of
statements that we want to become true within the span of the next three years.
This format is designed with dual purposes: first, to give the reader a clear
snapshot of the developer experience they can expect with OCaml down the road;
and second, to allow Platform maintainers and contributors to easily transform
the roadmap into actionable tasks or projects for the distinct Platform tools.

## Vision and Goals

Our overarching vision for the OCaml Platform is to create a seamless experience
for every development workflow.

We envision a development environment where each development task is supported
and maximally optimised and, whenever possible, does not require any human
interaction. We lay down this vision in concrete guidelines for the tools in the
[Guiding Principles](platform-principles).

In this section, we identify three main areas of focus for the next three years.

### (G1) Dune is The Frontend of The OCaml Platform

Following (P5) (Tools are independent, yet unified), Dune becomes the only tool
users need to use to develop in OCaml.

Dune already integrates with most Platform tools to create a cohesive
experience, but it lacks two notable integrations that force users to juggle
with multiple tools: package management and package publication. It should
integrate with opam and `opam-publish`/`dune-release` to provide these
workflows.

It should also integrate with any newly incubated Platform tool as experimental.

As a consequence of Dune being the frontend of the OCaml Platform, it becomes
the only tool users need to get started with OCaml. The recommended way to get
started with OCaml would be to install Dune through system package managers.
Installing OCaml becomes as simple as `apt install dune`.

Following (P2) (The experience is versatile, yet seamless), Dune should provide
a minimal and intuitive CLI for all supported Platform development workflows. In
particular, it should orchestrate them and install them automatically as needed.
Ultimately, users of Dune should not need to know that they are using a separate
tool under the hood.

### (G2) Support New Development Workflows

Following (P2) (The experience is versatile, yet seamless), the priority over
the next three years is to fill gaps in the current development experience.

The goal is to incubate new Platform tools to support the most important missing
development workflows. Based on the state of the OCaml ecosystem and community
feedback, we plan to incubate tools (or extend existing tools when appropriate)
for the following workflows:

- **Linting:** Lint OCaml projects using a set of predefined linting rules.
- **Benchmarking:** Execute benchmarks for OCaml projects to test for
  performance improvements/regressions.
- **Formal Verification:** Run formal specification verifications as part of the
  regular test workflow.
- **Generating Installers:** Generating platform-specific installers, such as
  `.msi` or `.deb`, to easily distribute OCaml projects.
- **Auditing Code:** Audit OCaml projects using a database of known security
  advisories.

### (G3) Mature Existing Workflows

Lastly, we will continue to mature supported development workflows. User
feedback shows that the current development experience can be improved. A sample
of frequent requests include the ability to run a single test from Dune CLI; the
ability to vendor dependencies that depend on other packages without having to
vendor those; Merlin queries to perform code refactoring such as renaming values
and functions; etc.

The Workflows section goes into more detail on the workflows we plan to improve
in the coming years, but we highlight three that stand out as significantly
important:

- **Installing OCaml:** The installation of a complete OCaml development
  environment is undoubtedly an important barrier to adoption. With Dune
  becoming the frontend for the Platform, installing OCaml should be as simple
  as `apt install dune` or `winget install dune`.
- **Debugging:** The OCaml compiler offers support for debugging
  with `ocamldebug`. To make debugging OCaml programs easier; however, users
  should be able to run the debugger from Dune, or their editor. The OCaml
  Platform should provide a
  [Debugger Adapter Protocol](https://microsoft.github.io/debug-adapter-protocol//)
  implementation to support editor integrations, and Dune should integrate with
  `ocamldebug` to provide an intuitive debugging workflow for Dune projects.
- **Generating Documentation:** The availability of high-quality documentation
  for OCaml packages remains one of the main pain points reported by OCaml
  developers and a major hurdle for the adoption of the language. Recent efforts
  to improve the situation include the new central package documentation on
  OCaml.org. However, the available documentation generation tooling isn't
  suited to created user manuals. To incentivise developers to write
  high-quality documentation for their package, one priority is to improve the
  tooling to support this use case.

## Workflows

For clarity, we categorise workflows into the following use cases:

- **Get Started:** install OCaml development environment
- **Develop:** create and develop software
- **Inspect:** inspect and understand the code
- **Edit:** develop with OCaml with a code editor
- **Maintain:** maintain projects and ensure the code quality
- **Share:** share software with the world

### Get Started

The OCaml Platform provides various ways to get started with OCaml, depending on
the use case and type of user.

#### (W1) From the Command Line

To drive your workflow from the command line, you can install `dune`:

```sh
# On Ubuntu
sudo apt install dune
# On macOS
brew install dune
# On Windows
winget install dune
```

The Dune binary is packaged on all Tiers-1 supported environments. It can also
be downloaded for other environments as a binary:

```sh
bash < <(curl -sL https://ocaml.org/setup.sh)
```

Once installed, you can download an OCaml project and run it with:

```sh
git clone git@github.com:ocaml/foo.git
cd foo
dune exec my-cli
```

Or run:

```sh
dune fmt # To format your code
dune doc # To generate your documentation
dune test # To run the project's tests
```

Under the hood, Dune uses the OCaml Platform tools as libraries or by driving
their binaries. This is hidden from the user, however. If Dune needs a tool to
perform a certain developer workflow, it installs it for the user.

#### (W2) From the Editors

The above setup is tailored for people who are comfortable with the command line
and want to stay in control. Other users, such as Language Hobbyist (U4), who
want to get started quickly can open and install the OCaml extension on their
favourite editor:

```
code --install-extension ocaml.vscode-ocaml # On VSCode
M-x package-install ocaml-mode # On Emacs
Plug 'ocaml/ocaml.vim' # On Vim
```

The editor's extension will install Dune on the user's system if it is not
already, which itself installs on demand every tool needed by the editor
extension to provide an out-of-the-box complete editing experience, following
the design principles (P1) and (P5).

All of the editor's extensions interact with the OCaml LSP server. In addition
to all of the features provided by the LSP protocol (including syntax
highlighting, error reporting, syntax completion, etc.), the extensions provide
features that are specific to the OCaml Platform, for instance, promotions
diffs, running Dune executables, etc.

#### (W3) Using Dev Containers

Dev Containers are Docker containers that integrate with Editors and, in
particular, can be used seamlessly with VSCode's Dev Containers extension and
GitHub Codespaces.

It is a workflow that's particularly suitable for Teachers (U5) who have to
support vastly different environments for their students.

To allow users to set up a project using Dev Containers, the projects themselves
must commit a `devcontainers` configuration file to the repository. Editors like
VSCode can then pick up the configuration and provide all the editor's features
through the Docker container.

The OCaml Platform provides official Dev Containers that contain a full
development environment.

### Develop

#### (W4) Build a Project

After checking out an existing project, being able to build it is the first
thing needed by developers.

**A Unique Command**

In OCaml, it is as simple as running the following unique command:

```
dune build
```

This automatically installs every dependency of the project, inferred by reading
the project's metadata (found in the `dune-project` or `dune-workspace` files).
It installs package dependencies and libraries, and it sets up the compiler
version needed. It also hints to the user as to how to install system
dependencies by outputting the relevant package manager command to install them,
depending on their system. Dune's cache is shared across multiple projects, so
the setup can be very fast.

A single command to set up and build a project, common to any OCaml projects
that use Dune, makes it much easier for new contributors to quickly onboard and
be productive, from small to large projects, following (P1) and (P3).

Dune also works with non-Dune packages as dependencies. It works out the missing
metadata and build instructions by reading the `.opam` file and embedding them
in its build graph.

During development, two workflows are supported for building the project: in the
command line and through the editor. Both workflows are compatible and can be
used in conjunction.

**Watch Mode**

Dune provides a watch mode where any file modification will trigger a rebuild.
Thanks to Dune's cache, only the parts that are affected by the change are
recompiled.

The watch mode makes clear which target it runs (@runtest or @install), and
developers can re-run tests or invoke other targets in parallel (typically, it
is possible to run a build in watch mode and run the tests in watch mode in
another terminal).

**Editor Integration**

Similar to installing Dune directly through the editor, it is possible to drive
Dune without leaving the editor.

The editor supports building and running the project, through a dedicated UI.
Any information reported by Dune can be viewed from the editor, such as listing
project-wide errors, jumping to a reported location, etc. The editor uses an
instance of Dune in watch mode, meaning that any modification in a file will
trigger a rebuild and an update of the reported errors.

All of this is transparent for the user, who only has to set up their editors.

**Working in Different Contexts**

Dune can build the project with different sets of configurations, called
contexts. A context includes information about the OCaml compiler used,
compilation flags, environment variables, etc. It is expressive enough to define
compiler versions by providing a URL to sources to be used, for instance, for
testing on a specific branch of the compiler.

A user can define several contexts for different purposes, such as testing,
releasing, and benchmarking.

Contexts are defined in the `dune-workspace` file. The choice of the context to
use is done by passing an argument to the build command, in order to avoid any
global state. This improves reproducibility and avoids keeping track of the
currently used context, resulting in a simpler mental model (P3).

#### (W5) Manage Dependencies

The source of truth for dependencies is the metadata files committed to the
repository (i.e., `dune-project` file). A project is built using the lockfile
generated from `dune-project`.

To update the project's dependencies, users can edit the file directly, run
`dune lock` and rebuild the project. This also works well with watch mode: Dune
detects when there is a change in the project's dependencies, regenerates a
lockfile, and executes a build graph that contains the diff between the previous
state and the new one.

Additionally, the opam repository contains a mapping of libraries in each
package. This allows Dune and other opam clients to provide hints to users when
a library isn't available in the current workspace. By looking at the list of
packages and their libraries, Dune is able to suggest installing specific
packages to use a library.

#### (W6) Vendor a Dependency

For library and application developers ((U1) and (U2)), during development, it
is often useful to work on a dependency of the project, either to fix a bug that
was found during development or when changes need to be applied to both the
project and its dependencies.

Dune provides a way to vendor a dependency:

```sh
dune vendor <dependency>
```

This copies the dependency's source code from the build directory to the
project's source tree.

Vendored dependencies act the same way they do when they are in the build
directory, except that their source code can be modified by the user (P3).
Typically, the vendored dependency does not conflict with being a transitive
dependency from other packages: the packages that have it as a dependency will
be linked to the vendored version.

#### (W7) Generate a Project

Looking at other communities, project generation is one of the most beneficial
things for newcomers to start projects.

For simple projects, it shows the user the basic boilerplate required for an
OCaml project.

For more complex projects, it allows users to start from a working application
with all the conventions and configurations already encoded. It is far easier
for a beginner to read a codebase and extend it, rather than having to learn all
the pieces necessary to create something from scratch.

Dune provides a `dune init` command to generate projects.

It can generate simple projects containing a library, an executable, and a test
(R1, R4).

It can also generate projects from remote templates, for instance, hosted on
GitHub repositories (P1).

Project templates are configurable and `dune init` provides a wizard to set the
configuration. For instance, `dune init` can ask users which licence they would
like to use.

After projects have been generated from templates, `dune init` allows users to
grow their projects by generating new components. Components can be generic,
such as libraries, tests, but can also be specific to the template, such as an
authentication module in a web application.

#### (W8) Format Code

Dune provides a `dune fmt` command that formats code in a project.

Under the hood, it integrates with different formatters to format the different
files in an OCaml project. Dune's internal formatter is used for Dune files,
OCamlFormat for OCaml files, Refmt for Reason files, etc.

Users don't need to configure the formatters to be able to format their code:
there are good defaults that format the code in an idiomatic way (P1).

However, the tools are fully configurable and users (U1 and U2) can customise
how they want their code to be formatted (P1). Dune provides a stanza for that
purpose, which is passed as a configuration when driving the various tools.

Additionally, code formatting is backward compatible (P4). Either the tools
themselves are backward compatible and they know how to format with a specific
version of the tool, or Dune itself installs the correct version of the tool to
conserve backward compatibility.

#### (W9) Lint Code

While the OCaml compiler provides certain assertions about the code, notably
thanks to the static type system, it doesn't prevent _all_ the bugs and issues.

Typically, the compiler won't notify the user that a file descriptor is never
closed.

It will also not give hints on conventions that projects adopt to ensure code
quality. For instance, the Dune codebase encourages developers to create a
module for every type, instead of having multiple types in a module. Or the
OCaml LSP code base encourages users to put the shortest clause of a pattern
match first.

For that purpose, Dune provides linting capabilities through the integration
with an OCaml code linter.

Dune can also execute the linting pipeline only through the `dune lint` command
(R1).

Similarly to the formatting configuration, the linting configuration and profile
can be specified in the `dune-project`.

Dune reports linting failures as warnings during the build, and these errors are
reported to the Editors, thanks to the integration of OCaml LSP and Dune RPC.

#### (W10) Open a REPL

One of the strengths of languages that include a REPL is that you are able to
program very interactively, instantaneously receiving feedback from the
interpreter on the values that are being computed. This is especially
interesting for Language Hobbyists (U4) who want to experiment with the language
without even bothering to create a file, and who value all the additional
information given by the interpreter.

Opening a REPL with a nice UX, history, auto-completion, and line editing can be
done with:

```sh
dune repl
```

While opening a REPL with all public modules available is the default, Dune
offers more options for library users (P1, P3). It can open a REPL with more
control over the included modules, for instance, only a specified module or all
modules, including the private ones. It can also include modules without the
restriction given by their signature file.

Finally, opening a REPL is well-integrated into editors. One can easily get one
with the environment corresponding to one of the currently open files and
execute a piece of code there for testing purposes.

#### (W11) Cross-Compilation

Dune takes advantage of the first-class cross-compilation support of the OCaml
compiler to support cross-compilation of binaries.

Targets can be added to the `dune-workspace` file:

```
(context
  (default
    (targets native windows android)))
```

This makes Dune generate targets for the current system, Windows, and Android.

Users can also use `dune build -x <target>` to generate the targets for a
specific target.

Thanks to native support of cross-compilation in the compiler, cross-compilation
in Dune works independently of the build system used by the dependencies: if the
user depends on packages that use a different build system, Dune is still able
to compile executables for foreign platforms.

Dune natively supports dynamic or static linking while compiling, including when
doing cross-compilation.

Dune supports cross-compiling to the following platforms: Windows, macOS, iOS,
Android.

#### (W12) Compile to MirageOS

[MirageOS](https://mirage.io/) is a library operating system that constructs
unikernels for secure, high-performance network applications across a variety of
cloud computing and mobile platforms.

In addition to allowing cross-compilation to native platforms like Windows,
macOS, iOS and Android, Dune supports MirageOS unikernels as a cross-compilation
target:

```
dune build -x mirage
```

This workflow does not require using any third party opam repository.

#### (W13) Compile to JavaScript

An important feature of the OCaml ecosystem is the ability to compile OCaml code
to Javascript. This is currently achieved either by compiling from the bytecode
(Js_of_ocaml) or by compiling directly from OCaml source (Melange).

This allows users to write JavaScript applications directly in OCaml. This
includes the dynamic part, as a replacement for Javascript, but also the
front-end, e.g., with Tyxml, which can also benefit from FRP. Finally, the code
for the frontend and the backend is in the same language, allowing shared code
and much easier communications of values.

Changing the target language from native code to Javascript in Dune simply
requires adding one line to a `dune` file:

```sexp
(executable
  ...
  (modes js melange))
```

#### (W14) Compile to WebAssembly

Compilation to WebAssembly is supported in a way akin to JavaScript compilation:
users can add a `wasm` mode to their `dune` file to generate WebAssembly
compiled target as part of their build:

```
(executable
  ...
  (modes wasm))
```

#### (W15) Plugin Extensibility

Following (P6) (The Platform is cohesive, yet extensible), Dune allows external
tools to extend its language to add new build rules through a plugin system.

These plugins do not violate Dune's composability tenets. In particular, there
should be no coupling, or at most a loose coupling, between plugins.

In addition, to respect (P5) (Tools are independent, yet unified), the plugins
are usable independently of Dune.

Underlying Dune's plugin system is the fact that it may take years for new
tooling to be integrated into Dune. To better adapt to tools lifecyle, Dune
plugin systems is used to allow a fast iteration with loose backward
compatibility constrained during pre-incubation and incubation stages, until the
tools move to the Active stage and are integrated into Dune as first-class
citizens.

#### (W16) Integrate With Other Build Systems

While Dune is the recommended choice for OCaml projects, there are various
reasons why developers might opt for or need to use different build systems.
Large organizations, like Meta or Google, often mandate specific systems (Buck2
and Bazel, respectively) for consistency and scale. Independent developers, too,
might have preferences based on their unique needs, such as the reproducibility
features of Nix.

In order to ensure that the OCaml ecosystem remains accessible and usable for
all these users, regardless of their chosen build system, Dune offers support to
eject the build plan to a machine-readable format. This enables third-party
tools to consume the exported build plan and convert it into other build
systems' specifications.

We note that prior discussions have been inconclusive on wether there exists an
adequate solution to eject Dune's build plan. Further discussions and
investigations with maintainers of conversion tools like obazel, and users of
other build systems are needed to determine how the integration with these
platforms can be improved.

### Explore

#### (W17) Debugging

Debugging with OCaml can be done both from the command line and the editor.

To debug using the command line, one simply needs to run:

```sh
dune debug
```

This compiles the project with debug support and starts a debugging session in
the terminal.

The other way to debug a program is through the editor. The communication
between the debugger and the editor is made using the
[Debug Adapter Protocol](https://microsoft.github.io/debug-adapter-protocol//).

#### (W18) Benchmarking

Similarly to how they create test suites, OCaml users can create benchmarks for
their projects. There is first-class support in Dune for benchmarks. Users can
use a benchmarking library that generates a file that follows a specific format
that can be interpreted by a tool, such as
[`current-bench`](https://github.com/ocurrent/current-bench). Benchmarks take on
the form of normal OCaml files that use this library and are added to Dune
through the `bench` stanza, which behaves like the `test` stanza:

```
(bench
 (name ...)
 (libraries ...))
```

After adding their benchmarks in Dune, users can run `dune bench`, which will
run all the benchmarks to generate the output file. Locally, it subsequently
launches a benchmarking dashboard, which contains the different benchmarking
results that have been generated by the user.

When pushing on their repository, users have the option to enable benchmarking
on their repository through a GitHub application. When enabled, the application
listens to pull requests (PRs) on the repository and runs the benchmarks.

The benchmarks will then be available via the GitHub pull request.

### Edit

#### (W19) Navigate Code

Code navigation regroups common interactive development workflows, including:

- Displaying type signatures and symbol documentation
- Jumping to the definition of a type, value, or module
- Finding all references of a type, value, or module
- Switching from declaration to definition
- Navigate the cursor inside a file, using semantic information

Navigating code happens at three places:

- Locally, in the Editor, where users typically navigate from file to file, can
  get the references of a value or module, jump to a definition, etc.
- Online, when using a browser-based editor
- Online, when using a VCS, for instance, when reviewing GitHub or Gitlab PRs or
  when browsing hosted code
- Online, when using the OCaml Playground

Local editor code navigation is supported by the implementation of all of the
appropriate LSP requests in the OCaml LSP server. Browser-based editors are
supported by a web version of the OCaml VSCode extension that relies on Merlin's
JavaScript version. The OCaml Playground similarly uses Merlin's JavaScript
version to support code navigation features.

#### (W20) Refactor Code

Two notable code refactoring tasks include:

- Renaming a value or module and all of its references
- Extracting a value or module

The OCaml Platform supports these through Merlin queries, as well as through the
support of the relevant LSP requests and Code Actions in the OCaml LSP server.

### Maintain

#### (W21) Run Tests

Dune provides a `dune test` command, which runs the tests defined in a project.
The tests are defined using the `(test)` stanza.

Dune has a user-friendly, intuitive user interface to run tests. The tests can
be run individually from the command line, and Dune provides shell completion to
explore the CLI syntax and discover the tests available in a given context or
directory.

The test runner also integrates well with the watch mode to support
Test-Driven-Development (TDD) workflows.

The editors also integrate with Dune to provide a UI to explore and execute
tests. Typically, the VSCode extension provides a test explorer similar to the
official [Python extension](https://code.visualstudio.com/docs/python/testing).

Additionally, Dune can generate test coverage reports: when the tests are run,
the code is instrumented to identify code paths that were visited, and this is
used to measure coverage.

#### (W22) Formal Verification

[Gospel](https://github.com/ocaml-gospel/gospel) is a behavioural specification
language for OCaml program. It provides developers with a noninvasive and
easy-to-use syntax to annotate their module interfaces with formal contracts
that describe type invariants, mutability, function pre-conditions and
post-conditions, effects, exceptions, and much more!

It was designed to provide a tool-agnostic frontend for bringing formal methods
into the OCaml ecosystem.

To provide users with a way to formally verify their OCaml programs, the OCaml
Platform provides a tool that verifies the implementation of OCaml functions
using Gospel specifications.

When formal specifications of functions are defined, `dune test` reports any
formal verification failures to the user, and by extension, these failures are
reported as errors to the Editors through the LSP server.

#### (W23) Security Advisories

OCaml is used in the industry to power critical infrastructure pieces. Security
is extremely important in these contexts.

The OCaml Platform provides a database of security advisories (similar to
[Rust's Advisory Database](https://github.com/RustSec/advisory-db)) filed
against OCaml packages published on the `opam-repository`.

The database is maintained by a group of security experts, and the community can
contribute when new security issues are discovered or addressed.

Similarly to the linting workflow, Dune uses the advisory database to warn
against security issues in users' projects when building a project.

The `dune audit` command can also generate a security audit report after
matching the project's lockfile against the advisory database.

The security warnings and errors are reported to the editor through the
integration of OCaml LSP and Dune RPC.

Lastly, there OCaml Platform provides CI pipelines that watch the security
advisory database and open PRs or issues to the project repositories when a new
security issue has been detected from the project's lockfile.

### Share

#### (W24) Literate Programming

Literate programming is a programming practice where the importance given to
code and comments is inverted. By default, any text is ignored in the
compilation, and code has to be put inside special delimiters. Literate
programming is great for teaching purposes, as it focuses on explanations, but
it can also be used as a way to encourage documenting a large codebase.

In OCaml, literate programming support is provided by the `odoc` tool. Odoc is
typically used to generate documentation, but it can also execute code blocks in
your documentation.

This behaviour is opt-in and can be configured using a Dune stanza, for
instance:

```
(documentation
  (execute_code_blocks true))
```

Additional options can be provided in the above stanza, such as selecting which
files to run odoc on or which library to include.

Code block execution is supported for every documentation files supported by
odoc, including `.md`, `.mli` and `.mld` files.

The syntax for embedded code blocks in `.mli` and `.mld` files supports
specifying the output generated by executing the embedded code. This allows us
to interpret the output as a richer format, such as tables, images, graphs,
etc., which can then be displayed as such by the editor or suitably embedded in
HTML by `odoc`.

Dune allows us to run the (literate) program and check that the output from
running the program is as expected in the file:

```sh
dune test
```

If there is a mismatch between the actual output and the expected one, Dune
raises an error and offers to promote the diff.

Odoc also supports generating the HTML documentation with interactive
codeblocks, powered by a JavaScript toplevel.

#### (W25) Generate Documentation

Documentation can be generated from special comments present in the source code,
as well as dedicated doc files (`.mld` and `.md` files), by running, for
instance:

```sh
dune doc
```

Dune drives `odoc` to generate documentation in HTML format and opens a browser
tab at the beginning of the documentation (P3). The generated documentation
includes the documentation of the project's dependencies.

The markup used by `odoc` is expressive enough to write rich documentation and
manuals. In particular, Odoc supports the following features:

- Source code rendering to be able to inspect the code of a function when
  reading the documentation
- Global navigation to navigate through the entire API, and the standalone
  documentation pages.
- Search bar to search through the documentation.
- Special syntax for the most common markup features (e.g. tables, images, etc.)
- Support Markdown for standalone documentation pages
- Code blocks can generate rich output (e.g. images, diagrams, etc.) and
  arbitrary Markup.

The documentation generation and browsing are well integrated into code editors.
Users can quickly jump from their editor to the rendered documentation of the
module of their choice. Editors help write documentation, with syntax
highlighting, reference checks and the usual checks on snippets of code.

#### (W26) Package Publication

OCaml packages are published on the
[`opam-repository`](https://github.com/ocaml/opam-repository/). To publish a
package, users can create an opam file that contains information about the
package, such as its dependencies and depexts, as well as build instructions
that allow Dune, or other build systems, to build the package.

The opam file also defines where the package's sources can be downloaded from.
It is common practice to use GitHub, GitLab, or other VSC platforms to host a
tarball that contains the package's sources.

Dune provides a `dune release` command to publish packages on the
`opam-repository`. It automates the process of creating the opam file, the
source tarball, uploading the tarball to a VCS, and opening a PR on the
`opam-repository`.

Dune knows how to synthesise opam files from a Dune project and can generate a
tarball containing the source code and metadata needed to release a package on
the `opam-repository`. The generated tarball only contains the files that opam
requires.

This workflow integrates with development best practices and reads the project's
changelog to create the release archive and the `opam-repository` PR.

#### (W27) Generating Installers

A common way to distribute applications to end users is to generate an installer
that will contain the application, all of its dependencies, and scripts to
install both.

The installation file differs depending on the user's system. Debian-based Linux
distributions have `.deb` files, Windows has `.msi` and `setup.exe` files, and
macOS has `.app` files.

The OCaml Platform provides a tool to generate installers from OCaml projects,
and Dune provides a user-friendly interface to generate them.

For instance, running:

```sh
dune build @installer-msi
```

generates a `.msi` installer that can be distributed to Windows users to install
the project's executables.
