type metadata = {
  title : string;
  link : string;
  locations : string list;
  publication_date : string option;
  company : string;
  company_logo : string;
}
[@@deriving of_yaml, show { with_path = false }]

let all () =
  let job_date j = Option.value ~default:"1970-01-01" j.publication_date in
  Utils.yaml_sequence_file metadata_of_yaml "jobs.yml"
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
