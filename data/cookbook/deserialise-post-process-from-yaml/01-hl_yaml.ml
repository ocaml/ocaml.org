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

(* This YAML string contains a list of ingredients where the ingredients are represented as
  a YAML object, with keys representing names and values representing amounts.  *)
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

(* The `[@@deriving of_yojson]` attribute makes the `ppx_deriving_yojson` library generate the function
  `ingredient_of_yojson : Yojson.Safe.t -> (ingredient, string) result`. *)
type ingredient = {
  name: string;
  weight: int;
} [@@deriving of_yojson]

(* The `[@@deriving of_yojson]` attribute makes the `ppx_deriving_yojson` library generate the function
  ``recipe_of_yojson : Yojson.Safe.t -> (ingredient, string) result``. *)
type recipe = {
  name: string; [@key "french name"]
  ingredients: ingredient list;
  steps: string list;
} [@@deriving of_yojson]

(* Since the structure of the YAML file does not exactly match the `recipe` type,
  we (1) parse the YAML file to the representation `Yojson.Safe.t`,
  and then (2) modify the `Yojson.Safe.t` value to change the structure to match the `recipe` type,
  so we can use the `recipe_of_yojson` function.

  The functions `add_keys` and `at_ingredients` perform this post-processing. *)
let add_keys = function
  | `Assoc [(name, `Int weight)] ->
      `Assoc [
        ("name", `String name);
        ("weight", `Int weight);
      ]
  | v -> v

let at_ingredients f = function
  | `Assoc [
      ("french name", `String name);
      ("ingredients", `List ingredients);
      ("steps", `List steps)
    ] -> `Assoc [
      ("french name", `String name);
      ("ingredients",
        Yojson.Safe.Util.map f (`List ingredients));
      ("steps", `List steps);
    ]
  | v -> v

(* Parse, post-process, and convert the YAML string into an OCaml value of type `recipe`. *)
let pate_sucree =
  let of_yojson json =
    json
    |> at_ingredients add_keys
    |> recipe_of_yojson in
  yaml
  |> Hl_yaml.Unix.parse ~of_yojson
