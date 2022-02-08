type metadata = {
  title : string;
  link : string;
  location : string;
  company : string;
  company_logo : string;
}
[@@deriving yaml]

type t = {
  title : string;
  link : string;
  location : string;
  company : string;
  company_logo : string;
}

let path = Fpath.v "data/jobs.yml"

let decode s =
  let yaml = Utils.decode_or_raise Yaml.of_string s in
  match yaml with
  | `O [ ("jobs", `A xs) ] ->
      Ok
        (List.map
           (Utils.decode_or_raise (fun x ->
                match metadata_of_yaml x with
                | Ok raw ->
                    Ok
                      {
                        title = raw.title;
                        link = raw.link;
                        location = raw.location;
                        company = raw.company;
                        company_logo = raw.company_logo;
                      }
                | Error err -> Error err))
           xs)
  | _ -> Error (`Msg "expected a list of jobs")

let parse = decode

let all () =
  let content = Data.read "jobs.yml" |> Option.get in
  Utils.decode_or_raise decode content

let pp ppf v =
  Fmt.pf ppf
    {|
  { title = %a
  ; link = %a
  ; location = %a
  ; company = %a
  ; company_logo = %a
  }|}
    Pp.string v.title Pp.string v.link Pp.string v.location Pp.string v.company
    Pp.string v.company_logo

let pp_list = Pp.list pp

let template () =
  Format.asprintf
    {|
type t =
  { title : string
  ; link : string
  ; location : string
  ; company : string
  ; company_logo : string
  }
  
let all = %a
|}
    pp_list (all ())
