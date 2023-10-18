type link = { description : string; uri : string }
[@@deriving of_yaml, show { with_path = false }]

type metadata = {
  title : string;
  slug : string;
  description : string;
  recommendation : string option;
  authors : string list;
  language : string list;
  published : string;
  cover : string;
  isbn : string option;
  links : link list;
  rating : int option;
  featured : bool;
  difficulty : string option;
  pricing : string;
}
[@@deriving of_yaml, show { with_path = false }]

type t = {
  title : string;
  slug : string;
  description : string;
  recommendation : string option;
  authors : string list;
  language : string list;
  published : string;
  cover : string;
  isbn : string option;
  links : link list;
  rating : int option;
  featured : bool;
  difficulty : string option;
  pricing : string;
  body_md : string;
  body_html : string;
}
[@@deriving
  stable_record ~version:metadata ~remove:[ body_md; body_html ],
    show { with_path = false }]

let of_metadata m = of_metadata m

let decode (_, (head, body)) =
  let metadata = metadata_of_yaml head in
  let body_md = String.trim body in
  let body_html = Omd.of_string body |> Omd.to_html in
  Result.map (of_metadata ~body_md ~body_html) metadata

let all () =
  Utils.map_files decode "books/"
  |> List.sort (fun b1 b2 ->
         (* Sort the books by reversed publication date. *)
         String.compare b2.published b1.published)

let template () =
  Format.asprintf
    {|
type link = { description : string; uri : string }

type t = 
  { title : string
  ; slug : string
  ; description : string
  ; recommendation : string option
  ; authors : string list
  ; language : string list
  ; published : string
  ; cover : string
  ; isbn : string option
  ; links : link list
  ; rating : int option
  ; featured : bool
  ; difficulty : string option
  ; pricing : string
  ; body_md : string
  ; body_html : string
  }

let all = %a
|}
    (Fmt.brackets (Fmt.list pp ~sep:Fmt.semi))
    (all ())
