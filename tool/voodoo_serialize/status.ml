module Otherdocs = struct
  type t = {
    readme : Fpath.t list;
    license : Fpath.t list;
    changes : Fpath.t list;
    others : Fpath.t list;
  }

  let empty = { readme = []; license = []; changes = []; others = [] }

  let equal x y =
    Util.list_equal Fpath.equal x.readme y.readme
    && Util.list_equal Fpath.equal x.license y.license
    && Util.list_equal Fpath.equal x.changes y.changes
    && Util.list_equal Fpath.equal x.others y.others

  let pp fs x =
    Format.fprintf fs "(readme:%a) (license:%a) (changes:%a) (others:%a)"
      (Format.pp_print_list Fpath.pp)
      x.readme
      (Format.pp_print_list Fpath.pp)
      x.license
      (Format.pp_print_list Fpath.pp)
      x.changes
      (Format.pp_print_list Fpath.pp)
      x.others

  let of_yojson json =
    let open Yojson.Safe.Util in
    let readme =
      json |> member "readme" |> to_list |> List.map Fpath_.of_yojson
    in
    let license =
      json |> member "license" |> to_list |> List.map Fpath_.of_yojson
    in
    let changes =
      json |> member "changes" |> to_list |> List.map Fpath_.of_yojson
    in
    let others =
      json |> member "others" |> to_list |> List.map Fpath_.of_yojson
    in
    { readme; license; changes; others }

  let to_yojson { readme; license; changes; others } =
    let readme = ("readme", `List (List.map Fpath_.to_yojson readme)) in
    let license = ("license", `List (List.map Fpath_.to_yojson license)) in
    let changes = ("changes", `List (List.map Fpath_.to_yojson changes)) in
    let others = ("others", `List (List.map Fpath_.to_yojson others)) in
    `Assoc [ readme; license; changes; others ]
end

type t = { failed : bool; otherdocs : Otherdocs.t }

let equal x y = x.failed = y.failed && Otherdocs.equal x.otherdocs y.otherdocs

let pp fs x =
  Format.fprintf fs "(failed:%b) (otherdocs:%a)" x.failed Otherdocs.pp
    x.otherdocs

let of_yojson json =
  let open Yojson.Safe.Util in
  let failed = json |> member "failed" |> to_bool in
  let otherdocs = json |> member "otherdocs" |> Otherdocs.of_yojson in
  { failed; otherdocs }

let to_yojson { failed; otherdocs } =
  let failed = ("failed", `Bool failed) in
  let otherdocs = ("otherdocs", Otherdocs.to_yojson otherdocs) in
  `Assoc [ failed; otherdocs ]
