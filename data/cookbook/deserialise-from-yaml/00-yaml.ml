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
(* The syntax `{| ... |}` is a quoted string. *)
let yaml = {|
french name: pâte sucrée
ingredients:
- name: flour
  weight: 250
- name: butter
  weight: 100
- name: sugar
  weight: 100
- name: egg
  weight: 50
- name: salt
  weight: 5
steps:
- soften butter
- add sugar
- add egg and salt
- add flour
|}

(* The `[@@deriving of_yaml]` attribute makes library `ppx_deriving_yaml` generate the function
  ``ingredient_of_yaml : Yaml.value -> (ingredient, [> `Msg of string]) result``
  If both serialising and deserialising are needed, replace `of_yaml` by `yaml`. *)
type ingredient = {
  name: string;
  weight: int;
} [@@deriving of_yaml]

(* The `[@@deriving of_yaml]` attribute makes library `ppx_deriving_yaml` generate the function
  ``recipe_of_yaml : Yaml.value -> (ingredient, [> `Msg of string]) result``. *)
type recipe = {
  name: string; [@key "french name"]
  ingredients: ingredient list;
  steps: string list;
} [@@deriving of_yaml]

(* Parsing and conversion into record are chained. *)
let pate_sucree =
  yaml
  |> Yaml.of_string
  |> fun yaml -> Result.bind yaml recipe_of_yaml

