# OCaml.org

[![Actions Status](https://github.com/ocaml/v3.ocaml.org-server/workflows/CI/badge.svg)](https://github.com/ocaml/v3.ocaml.org-server/actions)

ocamlorg is a Dream-based server for the next version of the ocaml.org website. It is currently served at https://v3.ocaml.org/.

It serves the OCaml packages pages and their documentation by using the data available at https://docs-data.ocaml.org/ and serves pages that use the content generated from `data/`.

## Getting started

You can setup the project with:

```
make switch
```

And run it with:

```
make start
```

See our [`contributing guide`](./CONTRIBUTING.md) for more detailed instructions.

## Contributing

We'd love your help improving ocaml.org!

See our contributing guide in [`CONTRIBUTING.md`](./CONTRIBUTING.md)

## License

**TL;DR:** 

- The code is released under ISC
- The data is released under CC BY-SA 4.0
- The vendored files are listed with their licenses in [`LICENSE-3RD-PARTY`](./LICENSE-3RD-PARTY)

See our [`LICENSE`](./LICENSE) for the complete licenses.
