(** Odoc types for sidebar's global table of content *)

type 'a node = { node : 'a; children : 'a node list }

and sidebar_node = {
  url : string option;
  kind : string option;
  content : string;
}

and tree = sidebar_node node
and t = tree list [@@deriving of_yojson]
