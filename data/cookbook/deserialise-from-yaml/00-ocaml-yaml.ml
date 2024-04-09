---
packages:
- name: yaml
  version: 3.2.0
- name: ppx_deriving_yaml
  version: 0.2.2
libraries:
  - yaml
ppxes:
  - ppx_deriving_yaml
discussion: |
  - The `yaml` packages provides means to parse and print Yaml source into a generic type: `Yaml.value`
  - The `ppx_deriving_yaml` package provides means to convert to and from `Yaml.value` into custom record types.
  - If both serialising and deserialising are needed, the attribute `of_yaml` can be replaced by `yaml`.
---
(** The syntax `{yaml| ... |yaml}` is a quoted string. The `yaml` identifier has
  no meaning, it only needs to be the same at both ends. No escaping is needed
  inside a quoted string. In a “real-world” example, the YAML source would be
  read from a file or received from a network request, this is out of the scope
  of this recipe.
*)
let yaml = {yaml|
- name: pâte sucrée
- ingredients:
  - flour: 250
  - butter: 100
  - sugar: 100
  - egg: 50
  - salt: 5
- steps:
  - soften butter
  - add sugar
  - add egg and salt
  - add flour
|yaml}

(** The `@@deriving` attribute triggers the definition of function
  `ingredient_of_yaml` of type ``Yaml.value -> (ingredient, [> `Msg of string ])
  result``. This provided by the `ppx_deriving_yaml` package. *)
type ingredient = {
  name: string;
  weight: int;
} [@@deriving of_yaml]

(** The `@@deriving` attribute triggers the definition of function
  `recipe_of_yaml` of type ``Yaml.value -> (ingredient, [> `Msg of string ])
  result`` This provided by the `ppx_deriving_yaml` package. *)
type recipe = {
  name: string;
  ingredients: ingredient list;
  steps: string list;
} [@@deriving of_yaml]

(** Parsing the YAML format above does not produce `Yaml.value` results suitable
  for `ingredient_of_yaml`, post processing is needed. This what that function
  does. *)
let add_keys : Yaml.value -> Yaml.value = function
  | `O [(name, `Float weight)] -> `O [("name", `String name); ("weight", `Float weight)]
  | v -> v

(** Parsing the YAML format above does not produce `Yaml.value` results suitable
  for `recipe_of_yaml`, post processing is needed. This what that function does. *)

let at_ingredients f = function
  | `A [
       `O [("name", `String name)];
       `O [("ingredients", `A ingredients)];
       `O [("steps", `A steps)];
     ] -> `O [
       ("name", `String name);
       ("ingredients", Yaml.Util.map_exn f (`A ingredients));
       ("steps", `A steps);
     ]
  | v -> v

(** Everything is combined: parsing, post-processing and conversion into custom
  record types. The function `Yaml.of_string` is provided by the `yaml` package.
  Since `Yaml.of_string` returns a `result` wrapped value, post-processing must
  take place under a call to `Result.map`. Since `recipe_of_yaml` also returns a
  `result` wrapped value, it must be called using `Result.bind` which does the
  same as `Result.bind` except it peels-off the double `result` wrapping. Refer
  to the [Error Handling](/docs/error-handling) guide for more on processing
  `result` values. `Fun.flip` is a artefact needed by type-cheking, otherwise
  `Result.bind` does not expect its arguments in the order required by this
  pipe. *)
let pate_sucree =
  yaml
  |> Yaml.of_string
  |> Result.map (at_ingredients add_keys)
  |> Fun.flip Result.bind recipe_of_yaml

