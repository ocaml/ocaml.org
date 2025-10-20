---
title: "OCaml.org Now Builds With Dune Package Management"
tags: [ocaml-org, dune]
authors: ["Sabine Schmaltz", "Leandro Ostera", "Sudha Parimala"]
---

TL/DR; The OCaml.org website has successfully migrated its build setup to use Dune Package Management for handling dependencies!

## Why This Migration Matters

As the official website of the OCaml programming language, OCaml.org is one of the most visible projects in the OCaml ecosystem. By migrating our build setup to use Dune Package Management, we've helped identify issues and refine new Dune workflows, and we've established OCaml.org as a real-world example for other projects considering to adopt Dune Package Management.

The migration has been completed and merged in [PR #3281](https://github.com/ocaml/ocaml.org/pull/3281), which was a continuation of the initial work from [PR #3132](https://github.com/ocaml/ocaml.org/pull/3132).

## Technical Challenges and Solutions

Updating the OCaml.org build to use Dune Package Management revealed several interesting technical aspects that other projects may encounter when they adopt Dune package management:

### How to Configure Nested Dune Projects

One of the first hurdles encountered was dealing with nested Dune projects. The OCaml.org codebase contains a the OCaml.org playground as a separate project nested within the main website project.

> **Note:** This is not a standard or recommended setup, but it happens to be how OCaml.org has historically grown as a project. The playground is a part of the site that is not updated very often, and we only regenerate it (and commit the build artifacts) when the playground is updated to a new version or gets new features. Specifically, the OCaml version used in the playground does not have to be the same as the one used for the main site.

The solution we went with was to use **two separate `dune-workspace` files** - one for the main OCaml.org site and one for the playground.

**Step-by-step solution for the OCaml.org structure:**

1. **Create the main [`dune-workspace`](https://github.com/ocaml/ocaml.org/blob/main/dune-workspace)** file in the repository root:
   ```lisp
   ; dune-workspace (at repository root)
   (lang dune 3.19)
   ```

2. **Create a separate [`dune-workspace`](https://github.com/ocaml/ocaml.org/blob/main/playground/dune-workspace)** file for the playground:
   ```lisp
   ; playground/dune-workspace
   (lang dune 3.19)
   ```

3. **Build each project independently** by forcing the correct root:
   ```bash
   # Build the main OCaml.org site
   dune build
   
   # Build the playground (must use --root to force workspace detection)
   cd playground
   dune build --root .
   
   # Or from anywhere in the repository
   dune build --workspace playground/dune-workspace --root playground
   ```

4. **Lock dependencies separately** for each workspace:
   ```bash
   # Lock main OCaml.org dependencies
   dune pkg lock
   
   # Lock playground dependencies (from the playground directory)
   cd playground
   dune pkg lock --root .
   ```

### Stable Dependency Management Setup with Pinned `opam-repository`

OCaml.org uses a fixed commit hash of `opam-repository` to ensure a stable environment between contributors, maintainers, and the continuous integration service. This avoids running into dependency upgrade issues during feature development or when working on bugfixes.

**Step-by-step workspace configuration for OCaml.org:**

1. **Pin opam-repository to the same specific commit** in the `dune-workspace` files:
   ```lisp
   ; Both dune-workspace and playground/dune-workspace use:
   (repository
    (name pinned_opam_repository)
    (url git+https://github.com/ocaml/opam-repository#584630e7a7e27e3cf56158696a3fe94623a0cf4f)
   )

   (lock_dir
    (path dune.lock)
    (repositories 
     pinned_opam_repository)
   )
   ```

2. **Update the pinned repository commit** in both files during coordinated upgrades:
   ```bash
   # Update both dune-workspace files with the new commit hash

   # Then regenerate both lock files
   dune pkg lock
   cd playground && dune pkg lock --root .
   ```

### Pinning Individual Dependencies

The playground has additional complexity because it requires specific versions of packages that aren't available in the standard `opam-repository` or need patches for compatibility with Dune package management. These dependencies are handled through individual pins in the playground's `dune-workspace`.

**Pin a dependency**:

```lisp
...

(pin
 (name merlin-js)
 (url "git+https://github.com/voodoos/merlin-js#3a8c83e03d629228b8a8394ecafc04523b0ab93f")
 (package (name merlin-js))
)

...

(lock_dir
  (repositories pinned_opam_repository)
  (pins esbuild code-mirror merlin-js js-top-worker ocamlbuild ocamlfind)
)
```

### Compatibility of Dependencies Using Symlinks

During the migration, we encountered compatibility issues with upstream dependencies relating to the use of symlinks. For example, `merlin-js` uses symlinks in its example programs.

Currently, Dune package management doesn't support symlinks, so we removed the offending examples to enable building `merlin-js` with Dune package management from [this `merlin-js` branch](https://github.com/Sudha247/merlin-js/tree/exp).

#### The Opam-repository Overlays for OCamlBuild and OCamlFind

A similar issue relating to symlinks exists with `ocamlbuild` and `ocamlfind`; however, both packages already have patched versions compatible with Dune package management and available at [ocaml-dune/opam-overlays](https://github.com/ocaml-dune/opam-overlays).

So, we added the overlays repository to the `dune-workspace` files and listed both repositories within the `lock_dir` Dune stanza:

```lisp
...

(repository
 (name pinned_overlay_repository)
 (url git+https://github.com/ocaml-dune/opam-overlays#2a9543286ff0e0656058fee5c0da7abc16b8717d)
)

(lock_dir
 (repositories pinned_opam_repository pinned_overlay_repository)
)
```

This way, the patched dependencies `ocamlbuild` and `ocamlfind` are picked up by Dune's solver when creating the `dune.lock` directory.

**Note**: the overlay is part of the standard repositories and only necessary to explicitly add here because we need to use a pinned revision in our workspace.

### Updating GitHub Actions to Use Dune Package Management

Using the GitHub Action available at [ocaml-dune/setup-dune](https://github.com/ocaml-dune/setup-dune), we updated the workflows [`ci.yml`](https://github.com/ocaml/ocaml.org/blob/main/.github/workflows/ci.yml) and [`scrape.yml`](https://github.com/ocaml/ocaml.org/blob/main/.github/workflows/scrape.yml) to use Dune Package Management. After [introducing the `version` parameter in the `ocaml-dune/setup-dune` GitHub Action](https://github.com/ocaml-dune/setup-dune/pull/10), the change turned out to be straightforward.

Besides migrating to Dune Package Management, we simplified the configuration in several ways: (1) instead of having explicit calls to the build tool, we invoke the existing Makefile, and (2) we do not need to specify the OCaml compiler version in the workflow anymore, since Dune manages the compiler version via `dune-project`.

### Playground: Copying .cmi Files from the OCaml Standard Library

For the playground to load the Standard Library in the browser via the generated .js bundle, we need the relevant `.cmi` files. Previously, we were using the `opam var ocaml:lib` command to discover the location from the compiler build artifacts, and we copied them to the `asset/` folder of the playground.

To replicate this behavior with Dune Package Management, we invoke the OCaml compiler itself to tell us the path where we can find these `.cmi` files, by invoking `ocamlopt -config-var standard_library` through Dune Package Management from inside the [playground's dune file](https://github.com/ocaml/ocaml.org/blob/main/playground/dune).

## Migration Complete: What Contributors Need to Know

The migration has been successfully completed! Contributors working with OCaml.org should be aware of the following changes:

### Getting Started with the New Build System

To work with the updated OCaml.org build system:

1. **Remove any existing opam switch** for OCaml.org to avoid version conflicts
2. **Ensure you have Dune >= 3.20** installed
3. **Run `make`** to build the project

### Dependency Management Updates

The project now uses pinned opam-repository commits for stability. If you encounter build issues after rebasing on main, it may be due to dependency updates. In such cases:

- Run `dune pkg lock` to regenerate dependencies
- Build again with `make`

## Future Considerations

While the migration to Dune Package Management is complete, the maintainers continue to evaluate:

- **Hybrid workflow support**: Determining the extent to which opam workflows will be supported alongside Dune package management
- **Contributor documentation**: Ongoing updates to help contributors navigate common scenarios like dependency updates
- **Performance monitoring**: Tracking build times and optimizing the development experience

## Further Reading

For more detailed information about the Dune features used in this migration, consult the official Dune documentation:

- **[Dune Workspaces](https://dune.readthedocs.io/en/latest/reference/dune-workspace/index.html)** - Complete reference for `dune-workspace` file syntax and configuration
- **[Lock Directories](https://dune.readthedocs.io/en/latest/reference/dune-workspace/lock_dir.html)** - How to configure and use lock directories for reproducible builds
- **[Package Management](https://dune.readthedocs.io/en/stable/tutorials/dune-package-management/setup.html)** - Overview of Dune's package management features and workflows
- **[Pinning Dependencies](https://dune.readthedocs.io/en/stable/tutorials/dune-package-management/pinning.html)** - Guide to pinning packages to specific versions or Git commits
- **[Repository Configuration](https://dune.readthedocs.io/en/stable/tutorials/dune-package-management/repos.html)** - How to configure opam repositories in Dune workspaces

## Conclusion

Despite OCaml.org having a non-standard project setup and dealing with custom dependencies for the playground, the migration to Dune package management proved to be largely straightforward. The main OCaml.org site worked out of the box with Dune package management, requiring no changes to upstream dependencies.

The playground's custom dependencies needed some updates to work with Dune package management, but these were manageable. For insight into the broader OCaml ecosystem's compatibility with Dune package management, see ["Opam Health Check: or How we Got to 90+% of Packages Building with Dune Package Management"](https://tarides.com/blog/2025-06-05-opam-health-check-or-how-we-got-to-90-of-packages-building-with-dune-package-management/), which also provides access to an up-to-date health check service showing which packages build successfully.

The successful migration of OCaml.org demonstrates that Dune Package Management is ready for production use in real projects, and we hope the writeup of our experience helps guide other projects considering similar migrations.