---
packages:
- name: hl_yaml
  tested_version: 1.0.0
  used_libraries:
  - hl_yaml
- name: ppx_deriving_yojson
  tested_version: 3.7.0
  used_libraries:
  - ppx_deriving_yaml
---
(** The syntax `{| ... |}` is a quoted string. *)
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

(** The `[@@deriving of_yojson]`  attribute makes library `ppx_deriving_yojson` generate the function
  `ingredient_of_yojson : Yojson.Safe.t -> (ingredient, string) result`. If both serialising
  and deserialising are needed, `of_yojson` can be replaced by `yojson`.*)
type ingredient = {
  name: string;
  weight: int;
} [@@deriving of_yojson]

(** Converting into record is passed as an argument into parsing. *)
let pate_sucree =
  yaml
  |> Hl_yaml.Unix.parse ~of_yojson:recipe_of_yojson
