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
discussion: |
  - The `hl_yaml` package provides means to process, parse and print YAML data
  - The `ppx_deriving_yojson` package provides means to convert to and from `Yojson.Safe.t` into custom record types.
  - If both serialising and deserialising are needed, the attribute `of_yojson` can be replaced by `yojson`.
  - Package `hl_yaml` depends on `ppx_deriving_yojson`, you only needs to require the former.
  - To test this recipe in Utop, you need to execute `#require "hl_yaml"` and `#require "ppx_deriving_yojson"`
---
(** The syntax `{yaml| ... |yaml}` is a quoted string. The `yaml` identifier has
  no meaning, it is informative only and needs to be the same at both ends. No
  escaping is needed inside a quoted string. In a “real-world” example, the YAML
  source would be read from a file or received from a network request, this is
  out of the scope of this recipe.
*)
let yaml = {yaml|
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
|yaml}

(** The `@@deriving` attribute triggers the definition of function
  `ingredient_of_yojson : Yojson.Safe.t -> (ingredient, string) result`.
  This provided by the `ppx_deriving_yojson` package. *)
type ingredient = {
  name: string;
  weight: int;
} [@@deriving of_yojson]

(** The `@@deriving` attribute triggers the definition of function
  `recipe_of_yojson : Yojson.Safe.t -> (ingredient, string) result`.
  This provided by the `ppx_deriving_yojson` package. *)
type recipe = {
  name: string; [@key "french name"]
  ingredients: ingredient list;
  steps: string list;
} [@@deriving of_yojson]

(** Parsing the YAML format above does not produce `Yojson.Safe.t` results suitable
  for `ingredient_of_yojson`, post processing is needed. This what that function
  does. *)
let add_keys : Yojson.Safe.t -> Yojson.Safe.t = function
  | `Assoc [(name, `Int weight)] ->
      `Assoc [
        ("name", `String name);
        ("weight", `Int weight);
      ]
  | v -> v

(** Parsing the YAML format above does not produce `Yojson.Safe.t` results suitable
  for `recipe_of_yojson`, post processing is needed. This what that function does. *)
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

(** Everything in is right place: parsing, post-processing and conversion into
  custom record types. The function `Hl_yaml.Unix.parse` is provided by the
  `hl_yaml` package. *)
let pate_sucree =
  let of_yojson json = json |> at_ingredients add_keys |> recipe_of_yojson
  yaml
  |> Hl_yaml.Unix.parse ~of_yojson
