(** This module enables parsing the `status.json` file generated by
    ocaml-docs-ci. If the documentation generation is successful, this file
    should exist and contain info about the other pages present in the package. *)

type otherdocs = {
  readme : string option;
  license : string option;
  changes : string option;
}

type t = { failed : bool; otherdocs : otherdocs }

val of_yojson : Yojson.Safe.t -> t
(** Parse the status from the JSON format of `status.json` *)
