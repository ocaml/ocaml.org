open Tyxml;
open Lwt.Syntax;

type kind =
  | Blessed
  | Universe(string);

let version_link = (prefix, name, version) => {
  let version = OpamPackage.Version.to_string(version);
  let link = prefix ++ "packages/" ++ name ++ "/" ++ version;
  <span> <a href=link> {version |> Html.txt} </a> "/" </span>;
};

let wrap = v =>
  "<span style='color: #333; font-size: 0.75em'>{ " ++ v ++ " }</span>";

module Conflicts = {
  let createElement = (~conflicts, ()) => {
    switch (conflicts) {
    | [] => <div />
    | _lst =>
      <div>
        <h3> "Conflicts" </h3>
        <div style="padding-left: 1rem">
          {conflicts
           |> List.map(((name, constr)) => {
                OpamPackage.Name.to_string(name)
                ++ " "
                ++ (Option.map(wrap, constr) |> Option.value(~default=""))
              })
           |> String.concat("<br/>")
           |> Html.Unsafe.data}
        </div>
      </div>
    };
  };
};
module Depopts = {
  let createElement = (~depopts, ()) => {
    switch (depopts) {
    | [] => <div />
    | _lst =>
      <div>
        <h3> "Optional dependencies" </h3>
        <div style="padding-left: 1rem">
          {depopts
           |> List.map(((name, constr)) => {
                OpamPackage.Name.to_string(name)
                ++ " "
                ++ (Option.map(wrap, constr) |> Option.value(~default=""))
              })
           |> String.concat("<br/>")
           |> Html.Unsafe.data}
        </div>
      </div>
    };
  };
};

module Depends = {
  let createElement = (~depends, ()) => {
    switch (depends) {
    | [] => <div />
    | _lst =>
      <div>
        <h3> "Dependencies" </h3>
        <div style="padding-left: 1rem">
          {depends
           |> List.map(((name, constr)) => {
                OpamPackage.Name.to_string(name)
                ++ " "
                ++ (Option.map(wrap, constr) |> Option.value(~default=""))
              })
           |> String.concat("<br/>")
           |> Html.Unsafe.data}
        </div>
      </div>
    };
  };
};

module Tags = {
  let createElement = (~tags, ()) => {
    switch (tags) {
    | [] => <div />
    | _lst =>
      <div>
        <h3> "Tags" </h3>
        <div style="padding-left: 1rem">
          {tags |> String.concat("; ") |> Html.txt}
        </div>
      </div>
    };
  };
};

module Header = {
  type mode =
    | Info
    | Docs;

  let createElement =
      (~name, ~version, ~all_versions, ~path, ~docs_status, ~mode, ()) => {
    let all_package_versions_select =
      OpamPackage.Version.Map.keys(all_versions)
      |> List.rev_map(version' => {
           let package = OpamPackage.create(name, version');
           let version_str = OpamPackage.Version.to_string(version');
           let package_name = OpamPackage.Name.to_string(name);
           let target = {
             "/packages/" ++ package_name ++ "/" ++ version_str;
           };

           let value =
             version_str
             ++ " "
             ++ Package_docs_template.badge(package)
             |> Html.txt;

           if (version == version') {
             <option value=target selected=()> value </option>;
           } else {
             <option value=target> value </option>;
           };
         });

    let name = OpamPackage.Name.to_string(name);
    let version = OpamPackage.Version.to_string(version);

    let info_url = "/packages/" ++ name ++ "/" ++ version;
    let docs_url = info_url ++ "/docs";

    let docs_status_message =
      switch (docs_status) {
      | Ocamlorg.Documentation.Package.Built(_) => ""
      | Pending => "Docs CI is building the documentation for this package."
      | Failed => "Docs CI failed to build the documentation for this package."
      | Unknown => "Docs CI doesn't know about this package yet."
      };

    let tabs =
      switch (mode, docs_status) {
      | (Info, Ocamlorg.Documentation.Package.Built(_)) => [
          <div style="margin-right: 2rem; text-decoration: underline;">
            "Info"
          </div>,
          <a href=docs_url> "Docs" </a>,
        ]
      | (Info, _status) => [
          <div style="margin-right: 2rem; text-decoration: underline;">
            "Info"
          </div>,
          <div style="color: gray">
            "Docs"
            <span className="caption">
              {"⚠️ " ++ docs_status_message |> Html.txt}
            </span>
          </div>,
        ]
      | (Docs, _) => [
          <a href=info_url style="margin-right: 2rem;"> "Info" </a>,
          <a href=docs_url style="text-decoration: underline"> "Docs" </a>,
        ]
      };

    let path_items =
      String.split_on_char('/', path)
      |> List.filter(item =>
           switch (item) {
           | ""
           | "index.html" => false
           | _ => true
           }
         );

    let l = List.length(path_items);

    let (_, path_indicator) =
      List.fold_left_map(
        ((i, prefix), item) => {
          let link = prefix ++ "/" ++ item;
          let next = (i + 1, link);

          if (i == l - 1) {
            (next, <span> {" » " ++ item |> Html.txt} </span>);
          } else {
            (
              next,
              <span>
                " » "
                <a href={link ++ "/"}> {item |> Html.txt} </a>
              </span>,
            );
          };
        },
        (0, info_url),
        path_items,
      );

    <div
      style="border-bottom: solid #0002 1px; margin-bottom: 1rem; display: flex; align-items: baseline;">
      <h1
        style="display: inline; border-bottom: solid 0.5rem orange; margin-bottom: -0.5rem;">
        {name |> Html.txt}
      </h1>
      <span style="padding: 0.5rem"> " version " </span>
      <select id="package-select" style="margin-right: 0.5rem;">
        ...all_package_versions_select
      </select>
      <script>
        {{|
const select = document.getElementById('package-select');
select.addEventListener('change', (e) => {
  window.location.href = e.target.value;
})
      |}
         |> Html.Unsafe.data}
      </script>
      <div> ...path_indicator </div>
      <div style="flex: 1" />
      <div style="display: flex;"> ...tabs </div>
    </div>;
  };
};

let render =
    (
      ~name,
      ~version,
      ~info: Ocamlorg.Package.Info.t,
      ~docs,
      ~docs_status,
      ~all_versions,
      ~path,
    ) =>
  if (path == "") {
    <div>

        <Header name version all_versions docs_status path mode=Info />
        <br />
        <div
          style="border-bottom: solid #0002 1px; padding-bottom: 1rem; margin-bottom: 1rem; ">
          <h2> {info.synopsis |> Html.txt} </h2>
          <p>
            {info.description
             |> Omd.of_string
             |> Omd.to_html
             |> Html.Unsafe.data}
          </p>
        </div>
        <div>
          <h2> "Package information" </h2>
          <div style="display: flex">
            <div
              style="flex: 1; border-right: solid #0002 1px; padding-bottom: 1rem; margin-bottom: 1rem; margin-right: 1rem; padding-right: 1rem;  ">
              <div>
                <h3> "Author " </h3>
                <div style="padding-left: 1rem">
                  {info.authors |> String.concat(";") |> Html.txt}
                </div>
              </div>
              <div>
                <h3> "License " </h3>
                <div style="padding-left: 1rem">
                  {info.license |> Html.txt}
                </div>
              </div>
              <div>
                <h3> "Homepage " </h3>
                <div style="padding-left: 1rem">
                  ...{
                       info.homepage
                       |> List.map(addr =>
                            <a href=addr> {addr |> Html.txt} </a>
                          )
                     }
                </div>
              </div>
              <div>
                <h3> "Maintainer " </h3>
                <div style="padding-left: 1rem">
                  {info.maintainers |> String.concat(";") |> Html.txt}
                </div>
              </div>
            </div>
            <div style="flex: 1;">
              <Tags tags={info.tags} />
              <Depends depends={info.dependencies} />
              <Depopts depopts={info.depopts} />
              <Conflicts conflicts={info.conflicts} />
            </div>
          </div>
        </div>
      </div>;
      /* Root: we display opam package informations */
  } else {
    switch (docs) {
    | Error(e) =>
      let message =
        switch (e) {
        | `Not_found => "The documentation page could not be found. This is a bug."
        | `Msg(e) => e
        };

      <div>
        <Header name version all_versions docs_status path mode=Docs />
        <br />
        <div> {message |> Html.txt} </div>
      </div>;
    | Ok(docs) =>
      <div>
        <Header name version all_versions docs_status path mode=Docs />
        <div id="odoc-content"> docs </div>
        <script src="/static/highlight.pack.js" />
        <script> "hljs.highlightAll();" </script>
      </div>
    };
  };

let prefix = kind =>
  switch (kind) {
  | Blessed => "/packages"
  | Universe(u) => "/universes/" ++ u
  };

let render = (~kind, ~name, ~version, ~path, ()) => {
  let opam = OpamPackage.create(name, version);
  let* versions = Ocamlorg.State.get_package(name);
  let info = OpamPackage.Version.Map.find(version, versions);

  let path =
    switch (path) {
    | "docs" => "/"
    | v => v
    };

  let docs = Ocamlorg.State.docs();

  let docs_info = Ocamlorg.Documentation.package_info(docs, opam);

  let docs_status =
    switch (docs_info) {
    | None => Ocamlorg.Documentation.Package.Unknown
    | Some(t) => Ocamlorg.Documentation.Package.status(t)
    };

  let docs_target =
    prefix(kind)
    ++ "/"
    ++ OpamPackage.Name.to_string(name)
    ++ "/"
    ++ OpamPackage.Version.to_string(version)
    ++ "/"
    ++ path;

  let+ docs =
    switch (docs_status) {
    | Built(_) =>
      Ocamlorg.Documentation.load(Ocamlorg.State.docs(), docs_target)
    | Pending =>
      Lwt.return_error(`Msg("Documentation is currently building."))
    | Failed => Lwt.return_error(`Msg("Documentation failed to build."))
    | Unknown =>
      Lwt.return_error(
        `Msg("The docs CI don't know yet about this package."),
      )
    };

  Fmt.to_to_string(
    Html.pp_elt(),
    render(
      ~name,
      ~version,
      ~info,
      ~docs_status,
      ~docs,
      ~all_versions=versions,
      ~path,
    ),
  );
};
