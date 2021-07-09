let badge = package => {
  let docs = Ocamlorg.State.docs();
  let pkg = Ocamlorg.Documentation.package_info(docs, package);
  switch (pkg) {
  | Some(pkg) =>
    switch (Ocamlorg.Documentation.Package.status(pkg)) {
    | Built(_) => "📗"
    | Pending => "🟠"
    | Failed => "❌"
    | Unknown => ""
    }
  | None => ""
  };
};
