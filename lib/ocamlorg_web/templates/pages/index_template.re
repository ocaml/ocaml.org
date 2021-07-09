open Tyxml;

let render = () => {
  let docs = Ocamlorg.State.docs();
  let stats = Ocamlorg.Documentation.stats(docs);

  let item = st =>
    <div style="text-align: right">
      {Ocamlorg.Documentation.Stats.to_string(st) |> Html.txt}
    </div>;

  <div>
    <h1 style="margin: 0; padding-bottom: 1rem"> "Welcome to OCaml docs" </h1>
    <div style="display: flex; margin-bottom: 1rem;">
      <div
        style="flex: 1; padding-right: 1rem; border-right: solid #0002 1px; ">
        <h2> "Intro" </h2>
        <p>
          "The goal of OCaml docs is to provide automatically-generated documentation for all opam packages and versions. This is highly experimental but a good chunk of packages should be available."
        </p>
        <p>
          "This website is powered by "
          <a href="https://github.com/ocaml/odoc"> "odoc" </a>
          " for the documentation generation tool, "
          <a href="https://github.com/ocaml-doc/voodoo"> "voodoo" </a>
          " as the odoc driver, "
          <a href="https://github.com/ocurrent/ocaml-docs-ci">
            "ocaml-docs-ci"
          </a>
          " for the incremental build of the documentation and "
          <a href="https://github.com/TheLortex/docs2web"> "docs2web" </a>
          " as a dynamic website reporting the docs status and proxying the generated documentation. "
        </p>
      </div>
      <div style="flex: 1; padding-left: 1rem;">
        <h2> "Stats" </h2>
        <ul>
          <li
            style="border-bottom: solid #0001 1px; margin-bottom: 0.5rem; padding-bottom: 0.5rem">
            "Opam packages: "
            <br />
            {item(stats.opam)}
          </li>
          <li
            style="border-bottom: solid #0001 1px; margin-bottom: 0.5rem; padding-bottom: 0.5rem">
            "Package versions: "
            <br />
            {item(stats.versions)}
          </li>
          <li>
            "Individual dependency universes: "
            <br />
            {item(stats.universes)}
            <br />
          </li>
        </ul>
      </div>
    </div>
  </div>;
};

let render = () => Lwt.return(Fmt.to_to_string(Html.pp_elt(), render()));
