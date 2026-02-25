# OCaml.org

[![Actions Status](https://github.com/ocaml/ocaml.org/workflows/CI/badge.svg)](https://github.com/ocaml/ocaml.org/actions)

This repository contains the sources of the OCaml website. It is served at <https://ocaml.org/>.

## Features

- **Integrated documentation and package management:** The site combines the
  package management (currently opam.ocaml.org) with a new central
  documentation source (codenamed 'docs.ocaml.org') for all 14000+ opam packages
  directly within the OCaml.org site.

- **Responsive and accessible:** The site design also takes into account modern
  web-design principles, restructuring the old content in accordance with methods
  that will present it more compellingly. It is a total redesign that modernises
  the look and feel of the webpage, as well as make it easier to navigate and more
  accessible (particularly on mobile devices).

- **Separation of data editing from HTML/CSS generation:** The data used in the
  website is stored in Yaml or Markdown, so users can easily edit it and
  contribute to the website. Ocurrent is used to generate OCaml code from this
  data. The data turned in OCaml is the site served content. All the data used
  in the site can be found in [`./data`](./data).

## Getting Started

Before you begin, make sure you have opam (OCaml Package Manager) installed on your system. If you haven't installed it yet, you can follow the official installation instructions for your platform:

- [Official opam Installation Guide](https://opam.ocaml.org/doc/Install.html)

Once opam is installed, you can set up the project with the following command:

```sh
make switch
```

And run it with:

```sh
make start
```

## Maintainers

The OCaml.org maintainers team is composed of the following community members:

- Anil Madhavapeddy ([@avsm](https://github.com/avsm)), Owner (University of Cambridge)
- Thibaut Mattio ([@tmattio](https://github.com/tmattio)), Lead Maintainer (Tarides)
- Christine Rose ([@christinerose](https://github.com/christinerose)), Maintainer (Tarides)
- Cuihtlauac Alvarado ([@cuihtlauac](https://github.com/cuihtlauac)), Maintainer (Tarides)
- Sabine Schmaltz ([@sabine](https://github.com/sabine)), Maintainer (Tarides)

The roles and responsibilities are explained in the governance, don't hesitate to [have a look](https://ocaml.org/governance) for more details.

We're always looking for new maintainers! If you're interested in helping us make OCaml.org the best resource to learn OCaml and discover the ecosystem, [reach out to us](mailto:thibaut@tarides.com)!

## Acknowledgements

Thank you to everyone who contributed to the development of this new version of the website!

In particular:

For the groundwork on rethinking the sitemap, user flows, new content, design, and frontend, and package docs:

- Ashish Agarwal (Solvuu)
- Kanishka Azimi (Solvuu)
- Richard Davison (Solvuu)
- Patrick Ferris (OCaml Labs)
- Gemma Gordon (OCaml Labs)
- Isabella Leandersson (OCaml Labs)
- Thibaut Mattio (Tarides)
- Anil Madhavapeddy (University of Cambridge)

For the work on the package site infrastructure and UI:

- Jon Ludlam (OCaml Labs)
- Jules Aguillon (Tarides)
- Lucas Pluvinage (Tarides)

For meticulously going through the website to find issues:

- Paul-Elliot Anglès d’Auriac (Tarides)

For the work on the frontend designs and bringing them to life:

- Isabella Leandersson (OCaml Labs)
- Asaad Mahmood (Tarides)

For the work on the new content and reviewing the existing one:

- Christine Rose (Tarides)
- Isabella Leandersson (OCaml Labs)

We’d also like to thank the major funders who supported work on revamping the website. Grants from the Tezos Foundation and Jane Street facilitated the bulk of the work. Thank you! And if anyone else wishes to help support it on an ongoing basis, then donations to the OCaml Software Foundation and grants to the maintenance teams mentioned above are always welcomed.

## Contributing

We'd love your help improving OCaml.org!

See our contributing guide in [`CONTRIBUTING.md`](./CONTRIBUTING.md)

## License

- The source code is released under ISC.
- The data is released under CC BY-SA 4.0.
- Code examples within the content are released under UNLICENSE.
- The OCaml logo is released under UNLICENSE.
- The vendored files are listed with their licenses in [`LICENSE-3RD-PARTY`](./LICENSE-3RD-PARTY).

See our [`LICENSE`](./LICENSE) for the complete licenses.

## Code of Conduct

This project follows the [OCaml Code of Conduct](https://github.com/ocaml/ocaml.org/blob/main/CODE_OF_CONDUCT.md).
