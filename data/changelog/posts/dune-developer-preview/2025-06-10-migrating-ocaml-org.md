---
title: "Setting up OCaml.org as a Testing Ground for Dune Developer Preview"
tags: [dune, developer-preview, ocaml-org]
authors: ["Sabine Schmaltz", "Leandro Ostera", "Sudha Parimala"]
---

The OCaml.org website is undergoing a significant build setup change as it migrates to use Dune Developer Preview. This migration serves a dual purpose: modernizing the website's build process to use Dune package management while providing a real-world testing environment for Dune's experimental features exposed through the [Dune Developer Preview](https://preview.dune.build?utm_source=ocaml.org&utm_medium=referral&utm_campaign=changelog).

## Why This Migration Matters

OCaml.org is one of the most visible projects in the OCaml ecosystem. By migrating it to Dune Developer Preview, the team is creating an environment that will help identify issues and refine new Dune workflows before the stable release.

The state of the migration is currently tracked in [pull request #3132](https://github.com/ocaml/ocaml.org/pull/3132). We're about to finish the work and merge the PR soon!

## Technical Challenges and Solutions

Migrating OCaml.org to use Dune Developer Preview has revealed several interesting technical aspects that other projects may encounter when adopting Dune package management:

### How to Configure Nested Dune Projects

One of the first hurdles encountered was dealing with nested Dune projects. The OCaml.org codebase contains a playground project nested within the main website project, which made workspace management not immediately obvious.

> **Note:** This is not a standard or recommended setup, but happens to be how OCaml.org as a project historically has grown. The playground is a part of the site that is not updated very often, and we only regenerate it (and commit the build artifacts) when the playground is updated to a new version or gets new features. Specifically, the OCaml version used in the playground does not have to be the same as the one used for the main site.

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
   
   # Lock playground dependencies (from playground directory)
   cd playground
   dune pkg lock --root .
   ```

### OCaml.org's Stable Dependency Management Setup

OCaml.org uses a fixed commit hash of opam-repository to ensure a stable environment between contributors, maintainers, and the continuous integration service. This avoids running into dependency upgrade issues during feature development or when working on bugfixes.

**Step-by-step workspace configuration for OCaml.org:**

1. **Pin opam-repository to the same specific commit** in the `dune-workspace` files:
   ```lisp
   ; Both dune-workspace and playground/dune-workspace use:
   (repository
    (name pinned_opam_repository)
    (url git+https://github.com/ocaml/opam-repository#584630e7a7e27e3cf56158696a3fe94623a0cf4f))

   (lock_dir
    (path dune.lock)
    (repositories 
     pinned_opam_repository 
      ))
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

```
...

(pin
(name merlin-js)
 (url "git+https://github.com/voodoos/merlin-js#3a8c83e03d629228b8a8394ecafc04523b0ab93f")
 (package
  (name merlin-js)))

...

(lock_dir
  (repositories pinned_opam_repository)
  (pins esbuild code-mirror merlin-js js-top-worker ocamlbuild ocamlfind)
   (version_preference newest))
```


### Using the Opam-repository Overlays for OCamlBuild and OCamlFind

When we pinned `opam-repository` to a fixed git commit in the `dune-workspace` files, we encountered errors relating to `ocamlbuild` and `ocamlfind`. This is to be expected, as the most recent released versions of `ocamlbuild` and `ocamlfind` are not compatible with Dune package management yet. This is why a repository [`opam-overlays`](https://github.com/ocaml-dune/opam-overlays) has been created, where packages are republished with fixes relating to Dune package management.

So, we added the overlay repository to the `dune-workspace` files and listed both repositories within the `lock_dir` Dune stanza:

```
...

(repository (name pinned_overlay_repository) (url git+https://github.com/ocaml-dune/opam-overlays#2a9543286ff0e0656058fee5c0da7abc16b8717d))

(lock_dir
  (repositories pinned_opam_repository pinned_overlay_repository))
```

This way, the patched dependencies `ocamlbuild` and `ocamlfind` are picked up by Dune's solver when creating the `dune.lock` directory.

### Dependency Compatibility

The migration uncovered compatibility issues with upstream dependencies. Specifically, the `merlin-js` dependency, which hasn't been upstreamed to the main Merlin project, appears to have compatibility issues with Dune package management. This highlights an important consideration for the broader ecosystem: a few packages may need updates to work seamlessly with the new package management features.

FIXME: write a bit about `merlin-js` compatibility fix, or promise some upcoming guide? Or just write what we know right now, about this being related to use of symlinks in the projects, and how this can easily be fixed?

## Current Status and Next Steps

The migration is progressing through three key phases:

1. **Playground Integration**: Making the OCaml.org playground build successfully with Dune package management, which requires investigating and potentially fixing upstream dependency issues
2. **Documentation Updates**: Updating contributor documentation to reflect the new build process
3. **Cross-Platform Testing**: Ensuring the new workflow functions correctly on Windows and macOS

Once these phases are complete, OCaml.org will officially adopt Dune package management as its standard build method.

## Further Reading

For more detailed information about the Dune features used in this migration, consult the official Dune documentation:

- **[Dune Workspaces](https://dune.readthedocs.io/en/latest/reference/dune-workspace/index.html)** - Complete reference for `dune-workspace` file syntax and configuration
- **[Lock Directories](https://dune.readthedocs.io/en/latest/reference/dune-workspace/lock_dir.html)** - How to configure and use lock directories for reproducible builds
- **[Package Management](https://dune.readthedocs.io/en/stable/tutorials/dune-package-management/setup.html)** - Overview of Dune's package management features and workflows
- **[Pinning Dependencies](https://dune.readthedocs.io/en/stable/tutorials/dune-package-management/pinning.html)** - Guide to pinning packages to specific versions or Git commits
- **[Repository Configuration](https://dune.readthedocs.io/en/stable/tutorials/dune-package-management/repos.html)** - How to configure opam repositories in Dune workspaces

## Conclusion

Despite OCaml.org having a non-standard project setup and having to deal with custom dependencies for the playground, we found the migration to Dune package management to be mostly straightforward: OCaml.org itself didn't need us to touch any upstream dependencies, they just worked out of the box with Dune package management.

The playground uses a few custom dependencies which needed to be updated to work with Dune package management. To get an understanding of how much of the OCaml ecosystem supports Dune package management, here's an interesting read: ["Opam Health Check: or How we Got to 90+% of Packages Building with Dune Package Management"](https://tarides.com/blog/2025-06-05-opam-health-check-or-how-we-got-to-90-of-packages-building-with-dune-package-management/). That post also contains a link to the health check service where you can get an up-to-date view of which packages build successfully.