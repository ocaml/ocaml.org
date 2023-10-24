type location = { lat : float; long : float }
[@@deriving of_yaml, show { with_path = false }]

type metadata = {
  title : string;
  url : string;
  textual_location : string;
  location : location option;
  start_date : string;
  start_time : float option;
  end_time : float option;
  end_date : string option;
}
[@@deriving of_yaml, show { with_path = false }]

type t = {
  title : string;
  url : string;
  slug : string;
  textual_location : string;
  location : location option;
  start_date : string;
  start_time : float option;
  end_time : float option;
  end_date : string option;
}
[@@deriving
  stable_record ~version:metadata ~remove:[ slug ], show { with_path = false }]

let of_metadata m = of_metadata m ~slug:(Utils.slugify m.title)
let decode s = Result.map of_metadata (metadata_of_yaml s)

let all () =
  Utils.map_files decode "events/*.md"
  |> List.sort (fun e1 e2 ->
         (* Sort the events by reversed start date. *)
         String.compare e2.start_date e1.start_date)

let template () =
  Format.asprintf
    {|
type location = { lat : float; long : float }

type t =
  { title : string
  ; url : string
  ; slug : string
  ; textual_location : string
  ; location : location option
  ; start_date : string
  ; start_time : float option
  ; end_time : float option
  ; end_date : string option
  }

let all = %a
|}
    (Fmt.brackets (Fmt.list pp ~sep:Fmt.semi))
    (all ())
