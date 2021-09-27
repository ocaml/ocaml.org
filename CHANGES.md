# Unreleased

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
- Add initial set of Best Known Methods (#107, by @tmattio)
- Add initial toplevel to homepage (#106, by @tmattio)
- Serve HTML pages from server (#101, by @tmattio)
- Add turbo drive to accelerate SSR pages navigation (#100, by @tmattio)
- Merge frontend (#92, by @tmattio)
- Merge ood (#91, by @tmattio)
- Add initial i18n support (#84, by @tmattio)
- Improves the packages graphql api (#78, by @dinakajoy)
- Global navigation bar (#86, by @TheLortex)
- Serve site from filesystem (#70, by @tmattio)
- Add API to use french industrial users data in ocamlorg-data. (ocaml/ood#88, by @tmattio)
- Fix some typos (ocaml/ood#87, by @maiste)
- Add French content for industrials users (ocaml/ood#86, by @maiste)
- Add french content for success stories (ocaml/ood#84, by @tmattio)
- Fetch all of watch.ocaml.org videos (ocaml/ood#83, by @patricoferris)
- Add opam users (ocaml/ood#80, by @tmattio)
- Remove french tutorials (ocaml/ood#79, by @tmattio)
- Import releases (ocaml/ood#78, by @tmattio)

# 27-08-2021

- Initial preview
