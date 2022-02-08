# Unreleased

- Use the logo with name for the navigation bar (#276, by @tmattio)

- Add popularity to package search results (#277, by @tmattio)

- Improve community page and merge with events (#275, by @tmattio)

- Add footer in the tutorials to contribute or ask questions (#274, by @tmattio)

- Redirect to search page when for package authors and tags (#272, by @tmattio)

- Add a governance page (#271, by @tmattio)

- Guidelines page (#244, by @mndrix)
  - Recommend ocamlformat, de-emphasize formatting
  - Fix typos

- Fill in content for the Curated Resources section (#221, by @Julow)

- Add releases for 4.12.1, 4.13.0 and 4.13.2 (#217, by @tmattio)

- Fix missing line breaks in releases highlights (#217, by @tmattio)

- Use v3.ocaml.org manual instead of serving our own(#217, by @tmattio)

- Add featured packages on the Packages page (#215, by @Julow)

  This is a static list of packages that are highlighted on the Packages page.

- Add listing stats on the Packages page (#213, #256, by @Julow)

  The stats are:
  Recently added packages and recently updated packages, which are computed
  from the Git history of opam-repository, and packages with the biggest number
  of revdeps.
  The stats are rendered with a data point and an icon (number of revdeps, date
  of addition and lastest version).

- Integrate blog and community pages (#196, by @tmattio)

- Add legal pages (#207, by @tmattio)
  - Privacy Policy
  - Terms and Conditions
  - Carbon Footprint Statement

- Update success stories (#206, by @tmattio)

- Refactor bootstrap docs (#193, by @cdaringe)

- Compress web assets by default (#197, by @cdaringe)

- Add number stats on the Packages page (#204, by @Julow)

  The stats are:
  Total number of packages, packages added this month, updates this week.

- Adding search by authors, tag and other package fields (#194, by @panglesd)

- Integrate new toplevel design with toplevel logic and basic syntax highlighting (#188, by @patricoferris)

- Support HTTPS and provision certificates with Let's Encrypt (#182, by @tmattio and @patricoferris)

- Update the frontend (#187, by @tmattio, @asaadmahmood and @patricoferris)

- Redirect versioned links from reverse dependencies (#183, by @JiaeK)

- Fix tutorials image paths (#181, by @desirekaleba)

- Fix robots.txt URL (#178, by @desirekaleba)

- Fix handling of trailing slashes (#170, by @desirekaleba)

- Demarcate include blocks (#175, by @JiaeK)

- Add semicolons `;;` to 99 Problems toplevel sentences. (#176, by @Lontchi12)

- Fix tags in overview page by calling `make gen-po`

  Rewrite `gen-po`'s Makefile rules in `dune`. Created a `@gen-po` alias.
  Add a Github action to check if the PO files match the
  status of the repository (#172, by @TheLortex)

- Add tags to overview (#169, by @JiaeK)

- Switch to using RPCs to talk to toplevel worker (#159, by @jonludlam)

- Add completion to toplevel (#155, by @jonludlam)

- Add French content for academic users (#150, by @maiste)

- Add 99 problems (#147, by @tmattio)

- Import all of the events data from v2 (#116, by @patricoferris)

- Add a job board in opportunities (#115, by @tmattio)

- Split js_of_ocaml toplevel execution into web-worker (#135, by @patricoferris)

  The execution of OCaml expressions in the toplevel now takes place in a web
  worker which prevents the main UI thread from blocking and makes it easier to
  terminate executions that have been running too long.

- Compute and display reverse dependencies (#134, by @patricoferris and @TheLortex)

  Extend package information structure to add reverse dependencies. Display that
  information in the package page.

  Marshal package state to avoid recomputing the reverse dependencies on each restart.

  Convert heavy computations to Lwt to improve server responsiveness.

- Remove vertical scrollbar for the documentation navigation bar (#132, by @TheLortex)

  Removed a negative margin in the documentation navigation bar that caused
  a vertical overflow.

- Smarter and sorted package search (#131, by @panglesd)

  Improve the search algorithm to sort packages by relevance.

  The algorithm now uses the synopsis, descriptions and tags of the package.

- Better formatting of odoc def tables, hiding comment-delim (#130, by @panglesd)

  Added css rules to hide comment delimiters and improve overall sizing

  Copy pasting still include comments delimiters to output valid code.

- Highlight code blocks in BKMs (#122, by @patricoferris)

  As with the tutorials, the code blocks in the BKMs are primarily dune files, opam
  files or OCaml code which can be preprocessed for highlighting.

- Use ocamlorg_data for opam users (#117, by @tmattio)

  This removes the hardcoded opam users in and uses the ones generated from the data in
  `data/opam-users.yml`.

  When users want to have their avatar and a redirection to their GitHub profile from the
  package overview, they can open a PR to add themselves in `data/opam-users.yml`.

- Compile with OCaml `4.13.0` (#120, by @tmattio)

  The dependencies have been updated in order to be compabile with the OCaml `4.13.0`.
  The tutorials and documentation have also been updated to use `4.13.0` instead of `4.12.0`.

- Add code-highlighting to tutorials (#108, by @patricoferris)

  Added some static code-highlighting (i.e. not done on the client-side with highlight.js or prism.js).

  The library (hilite) reuses the textmate grammars from vscode with some minor modifications because
  the textmate library wasn't happy parsing them.

- Add initial set of Best Known Methods (#107, by @tmattio)

  Added the Best Known Methods data and included them on the Best Practices page.

- Add initial toplevel to homepage (#106, by @tmattio)

  Add a toplevel in the homepage that provides function from the Standard Library.

- Add redirections from V2 URLs (#103, by @tmattio)

  This fixes some links from the tutorials (the long term fix will be to review the links from the tutorials, but in the meantime, it's a working patch).

- Simplify URLs (#103, by @tmattio)

  Removed the prefixes from the URLs, such as `community/` or `principles/`.

- Add rules to promote the ocamlorg_data module (#103, by @tmattio)

- Fix the overflow-y in the package navbar (#103, by @tmattio)

- Add binaries to extract translatable strings from OCaml sources and merge them with existing PO files (#103, by @tmattio)

- Fix not found page HTTP status (#103, by @tmattio)

  The not found page previously returned HTTP code 200, it now correctly returns 404.

- Improve start and watch make commands (#103, by @tmattio)

  The commands now use a dune rule so dune can manage the filesystem changes instead of a custom script

- Use 90rem for the max-width instead of 80 (#103, by @tmattio)

  This gives much more room to the actual content (tutorials and documentation).

- Serve HTML pages from server (#101, by @tmattio)

  Align the various HTML generation technologies used in the `v3.ocaml.org` site into a single server and monorepo.

  As we move towards a more feature-complete v3 site, all of the pieces used in `v3.ocaml.org` are now consolidated under the Dream-based web server, with a single set of OCaml source code that provides the templating logic for all portions of the site.

- Add turbo drive to accelerate SSR pages navigation (#100, by @tmattio)

  This PR integrates Turbo Drive to accelerate the navigation of server-side rendered pages.

  This greatly improves the time to interactivity when loading navigating to a new page, as the cost of rendering a whole page is heavy.

- Merge frontend (#92, by @tmattio)

  Merge `ocaml/v3.ocaml.org` in the repository.

- Merge ood (#91, by @tmattio)

  Merge `ocaml/ood` in the repository.

- Add initial i18n support (#84, by @tmattio)

  The site now handles `Accept-Language` HTTP headers and will serve the content in the preferred language
  if it is available.

  This PR provides translations for the layout strings and the packages pages.

- Improves the packages GraphQL API (#78, by @dinakajoy)

  Adds the following queries:

  - `allPackages => contains, offset, limit` to query all of the packages.
  - `package => name, version` to query a package my name and version.
  - `packageByVersions => name, from, upto` to query set of package by name and version boundaries.

- Global navigation bar (#86, by @TheLortex)

  Implement a global navigation bar for packages documentations using the `package.json` file generated by `voodoo`

- Serve site from filesystem (#70, by @tmattio)

  Updates the v3.ocaml.org static file serving to read the files from the filesystem instead of crunching them at compile time.

- Add API to use french industrial users data in ocamlorg-data. (ocaml/ood#88, by @tmattio)

  Follow up on ocaml/ood#86 that re-generated the `Ood` modules and adds the
  API to use the French translations.

- Fix some typos (ocaml/ood#87, by @maiste)

  Fixes typos found in the English version of the industrial users data.

- Add French content for industrials users (ocaml/ood#86, by @maiste)

  Adds a French translation for the industrial users.
  The Ood modules are not re-generated as part of this PR.

- Add french content for success stories (ocaml/ood#84, by @tmattio)

  Adds a French translation for the success stories and an API in to use them.

  Functions `val all_{fr,en} : t list` are added and the function `all` and `get_by_slug`
  now take an optionnal `lang` argument.

- Fetch all of watch.ocaml.org videos (ocaml/ood#83, by @patricoferris)

  Improve the scraping of videos from watch.ocaml.org and fetch all of the available videos.

- Add opam users (ocaml/ood#80, by @tmattio)

  This allows us to display the package authors and maintainers with an avatar and add links
  their GitHub profiles from the packages overviews.

- Remove french tutorials (ocaml/ood#79, by @tmattio)

  For the most part the French translations of the tutorials in ocaml.org are either incomplete or outdated.
  In their current state, we won't import the translations, and we will work on improving them instead.

- Import releases (ocaml/ood#78, by @tmattio)

  Import the releases data from the current ocaml.org website.
  The data is imported as-is, with lots of broken links and images.
  A follow up PR will be needed to fix the releases contents and add the
  pages in the frontend to display them.

# 27-08-2021

- Initial preview
