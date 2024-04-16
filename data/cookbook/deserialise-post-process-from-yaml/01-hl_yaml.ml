---
packages:
- name: hl_yaml
  tested_version: 1.0.0
  used_libraries:
  - hl_yaml
- name: ppx_deriving_yojson
  tested_version: 3.7.0
  used_libraries:
  - ppx_deriving_yojson
---
(* The syntax `{| ... |}` is a quoted string. *)
let yaml = {|
french name: pâte sucrée
ingredients:
- flour: 250
- butter: 100
- sugar: 100
- egg: 50
- salt: 5
steps:
- soften butter
- add sugar
- add egg and salt
- add flour
|}

(* The `[@@deriving of_yojson]` attribute makes library `ppx_deriving_yojson` generate the function
  `ingredient_of_yojson : Yojson.Safe.t -> (ingredient, string) result`.
  If both serialising and deserialising are needed, replace `of_yojson` by `yojson`. *)
type ingredient = {
  name: string;
  weight: int;
} [@@deriving of_yojson]

(* The `[@@deriving of_yojson]` attribute makes library `ppx_deriving_yojson` generate the function
  ``recipe_of_yojson : Yojson.Safe.t -> (ingredient, string) result``. *)
type recipe = {
  name: string; [@key "french name"]
  ingredients: ingredient list;
  steps: string list;
} [@@deriving of_yojson]

(* Post-processing is needed before using `recipe_of_yojson`.
  This what function `add_keys` and `at_ingredients` do. *)
let add_keys : Yojson.Safe.t -> Yojson.Safe.t = function
  | `Assoc [(name, `Int weight)] ->
      `Assoc [
        ("name", `String name);
        ("weight", `Int weight);
      ]
  | v -> v

let at_ingredients f : Yojson.Safe.t -> Yojson.Safe.t = function
  | `Assoc [
      ("french name", `String name);
      ("ingredients", `List ingredients);
      ("steps", `List steps)
    ] -> `Assoc [
      ("french name", `String name);
      ("ingredients", Yojson.Safe.Util.map f (`List ingredients));
      ("steps", `List steps);
    ]
  | v -> v

(* Parsing receives post-processing and conversion into record as an argument. *)
let pate_sucree =
  let of_yojson json =
    json
    |> at_ingredients add_keys
    |> recipe_of_yojson in
  yaml
  |> Hl_yaml.Unix.parse ~of_yojson
