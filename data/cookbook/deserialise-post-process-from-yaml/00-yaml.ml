---
packages:
- name: yaml
  tested_version: 3.2.0
  used_libraries:
  - yaml
- name: ppx_deriving_yaml
  tested_version: 0.2.2
  used_libraries:
  - ppx_deriving_yaml
---
(** The syntax `{| ... |}` is a quoted string. *)
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

(** The `[@@deriving of_yaml]` attribute makes library `ppx_deriving_yaml` generate the function
  ``ingredient_of_yaml : Yaml.value -> (ingredient, [> `Msg of string]) result``
  If both serialising and deserialising are needed, replace `of_yaml` by `yaml`. *)
type ingredient = {
  name: string;
  weight: int;
} [@@deriving of_yaml]

(** The `[@@deriving of_yaml]` attribute makes library `ppx_deriving_yaml` generate the function
  ``recipe_of_yaml : Yaml.value -> (ingredient, [> `Msg of string]) result``. *)
type recipe = {
  name: string; [@key "french name"]
  ingredients: ingredient list;
  steps: string list;
} [@@deriving of_yaml]

(** Post-processing is needed before using `recipe_of_yaml`.
  This what function `add_keys` and `at_ingredients` do. *)
let add_keys : Yaml.value -> Yaml.value = function
  | `O [(name, `Float weight)] ->
      `O [
        ("name", `String name);
        ("weight", `Float weight);
      ]
  | v -> v

let at_ingredients f : Yaml.value -> Yaml.value = function
  | `O [
      ("french name", `String name);
      ("ingredients", `A ingredients);
      ("steps", `A steps)
    ] -> `O [
      ("french name", `String name);
      ("ingredients", Yaml.Util.map_exn f (`A ingredients));
      ("steps", `A steps);
    ]
  | v -> v

(** Parsing, post-processing and conversion into recordd are chained. *)
let pate_sucree =
  yaml
  |> Yaml.of_string
  |> Result.map (at_ingredients add_keys)
  |> fun yaml -> Result.bind yaml recipe_of_yaml

