type otherdocs = {
  readme : string option;
  license : string option;
  changes : string option;
}

type t = { failed : bool; otherdocs : otherdocs }

let first_opt = function x :: _ -> Some x | [] -> None

let strip_prefix (p : string option) =
  let v : string list option = Option.map (String.split_on_char '/') p in
  match v with
  | None -> None
  | Some (_ :: _ :: _ :: _ :: _ :: xs) -> Some (String.concat "/" xs)
  | _ -> None

let of_yojson (v : Yojson.Safe.t) : t =
  let status = Voodoo_serialize.Status.of_yojson v in
  {
    failed = status.failed;
    otherdocs =
      {
        readme =
          status.otherdocs.readme |> first_opt |> Option.map Fpath.to_string
          |> strip_prefix;
        license =
          status.otherdocs.license |> first_opt |> Option.map Fpath.to_string
          |> strip_prefix;
        changes =
          status.otherdocs.changes |> first_opt |> Option.map Fpath.to_string
          |> strip_prefix;
      };
  }
