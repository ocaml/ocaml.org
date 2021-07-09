open Tyxml;

let item = ((name, (version, info))) => {
  let package = OpamPackage.create(name, version);
  let name = OpamPackage.Name.to_string(name);
  let version = OpamPackage.Version.to_string(version);
  let uri = name ++ "/" ++ version;
  <tr className="pkg-item">
    <td> <a href=uri> {name |> Html.txt} </a> </td>
    <td style="display: flex; justify-content: space-between;">
      <div> {version |> Html.txt} </div>
      <div> {Package_docs_template.badge(package) |> Html.txt} </div>
    </td>
    <td> {info.Ocamlorg.Package.Info.synopsis |> Html.txt} </td>
  </tr>;
};

module CharMap = Map.Make(Char);

let make_map = packages => {
  let res = ref(CharMap.empty);

  List.iter(
    ((name, _) as entry) => {
      let v = OpamPackage.Name.to_string(name).[0] |> Char.uppercase_ascii;
      res :=
        CharMap.update(
          v,
          st =>
            switch (st) {
            | None => Some([entry])
            | Some(values) => Some([entry, ...values])
            },
          res^,
        );
    },
    packages,
  );

  res^;
};

let compile = ((chr, items)) => {
  let c = Char.escaped(chr);
  [
    <tr>
      <td colspan="3"> <h2 id={"index-" ++ c}> {c |> Html.txt} </h2> </td>
    </tr>,
    ...items,
  ];
};

let render = packages => {
  let by_char = make_map(packages);

  let content =
    CharMap.map(List.map(item), by_char)
    |> CharMap.bindings
    |> List.map(compile)
    |> List.flatten;

  let chars =
    CharMap.bindings(by_char)
    |> List.map(fst)
    |> List.map(c => {
         let c = Char.escaped(c);
         <a
           href={"#index-" ++ c}
           style="margin-right: 0.75rem; font-size: 1.75rem;">
           {c |> Html.txt}
         </a>;
       });

  <div>
    <h1 style="margin: 0; padding-bottom: 1rem"> "Package index" </h1>
    <div
      style="background-color: rgba(253, 244, 226, 0.5); margin: 0 -2rem; padding: 0 2rem;">
      ...chars
    </div>
    <br />
    <table class_="list-packages">
      <thead>
        <tr>
          <th style="width: 25%;"> "Name" </th>
          <th> "Latest version" </th>
          <th> "Description" </th>
        </tr>
      </thead>
      <tbody> ...content </tbody>
    </table>
  </div>;
};

let render = packages => {
  Fmt.to_to_string(Html.pp_elt(), render(packages));
};
