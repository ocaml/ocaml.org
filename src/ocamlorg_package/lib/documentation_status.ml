type otherdocs = {
  readme : string option;
  license : string option;
  changes : string option;
}

type t = { failed : bool; otherdocs : otherdocs }

open Yojson.Safe.Util

let first_opt = function x :: _ -> Some x | [] -> None

let strip_prefix (p : string option) =
  let v : string list option = Option.map (String.split_on_char '/') p in
  match v with
  | None -> None
  | Some (_ :: _ :: _ :: _ :: _ :: xs) -> Some (String.concat "/" xs)
  | _ -> None

let of_yojson (v : Yojson.Safe.t) : t =
  let failed = member "failed" v |> to_bool in
  let otherdocs = member "otherdocs" v in
  {
    failed;
    otherdocs =
      {
        readme =
          otherdocs |> member "readme" |> to_list |> first_opt
          |> Option.map to_string |> strip_prefix;
        license =
          otherdocs |> member "license" |> to_list |> first_opt
          |> Option.map to_string |> strip_prefix;
        changes =
          otherdocs |> member "changes" |> to_list |> first_opt
          |> Option.map to_string |> strip_prefix;
      };
  }
