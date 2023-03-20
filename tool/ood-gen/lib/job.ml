type metadata = {
  title : string;
  link : string;
  locations : string list;
  publication_date : string option;
  company : string;
  company_logo : string;
}
[@@deriving of_yaml, show { with_path = false }]

type t = metadata [@@deriving show { with_path = false }]

let decode s =
  let yaml = Utils.decode_or_raise Yaml.of_string s in
  match yaml with
  | `O [ ("jobs", `A xs) ] ->
      Ok (List.map (Utils.decode_or_raise metadata_of_yaml) xs)
  | _ -> Error (`Msg "expected a list of jobs")

let all () =
  let job_date j = Option.value ~default:"1970-01-01" j.publication_date in
  let content = Data.read "jobs.yml" |> Option.get in
  Utils.decode_or_raise decode content
  |> List.sort (fun j1 j2 -> compare (job_date j2) (job_date j1))

let template () =
  Format.asprintf
    {|
type t =
  { title : string
  ; link : string
  ; locations : string list
  ; publication_date : string option
  ; company : string
  ; company_logo : string
  }
  
let all = %a
|}
    (Fmt.brackets (Fmt.list pp ~sep:Fmt.semi))
    (all ())
