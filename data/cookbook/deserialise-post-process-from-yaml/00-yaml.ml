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

(* This YAML string contains a list of ingredients where the ingredients are represented as
  a YAML object, with keys representing names and values representing amounts.  *)
let yaml_string = {|
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

(* The `[@@deriving of_yaml]` attribute makes the `ppx_deriving_yaml` library generate the function
  ``ingredient_of_yaml : Yaml.value -> (ingredient, [> `Msg of string]) result``. *)
type ingredient = {
  name: string;
  weight: int;
} [@@deriving of_yaml]

(* The `[@@deriving of_yaml]` attribute makes the `ppx_deriving_yaml` library generate the function
  ``recipe_of_yaml : Yaml.value -> (ingredient, [> `Msg of string]) result``. *)
type recipe = {
  name: string; [@key "french name"]
  ingredients: ingredient list;
  steps: string list;
} [@@deriving of_yaml]

(* Since the structure of the YAML file does not exactly match the `recipe` type,
  we (1) parse the YAML file to the internal representation `Yaml.value` of the `yaml` package,
  and then (2) change the structure to match the `recipe` type, so we can use the `recipe_of_yaml`
  function.

  The functions `add_keys` and `at_ingredients` perform this post-processing. *)
let add_keys = function
  | `O [(name, `Float weight)] ->
      `O [
        ("name", `String name);
        ("weight", `Float weight);
      ]
  | v -> v

let at_ingredients f = function
  | `O [
      ("french name", `String name);
      ("ingredients", `A ingredients);
      ("steps", `A steps)
    ] -> `O [
      ("french name", `String name);
      ("ingredients",
        Yaml.Util.map_exn f (`A ingredients));
      ("steps", `A steps);
    ]
  | v -> v

(* Parse, post-process, and convert the YAML string into an OCaml value of type `recipe`. *)
let pate_sucree =
  yaml_string
  |> Yaml.of_string
  |> Result.map (at_ingredients add_keys)
  |> fun yaml -> Result.bind yaml recipe_of_yaml

