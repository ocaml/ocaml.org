type metadata =
  { title : string
  ; link : string
  ; description : string
  ; location : string
  ; company : string
  ; company_logo : string
  ; fullfilled : bool
  }
[@@deriving yaml]

type t =
  { id : int
  ; title : string
  ; link : string
  ; description_html : string
  ; location : string
  ; company : string
  ; company_logo : string
  ; fullfilled : bool
  }

let path = Fpath.v "data/jobs.yml"

let decode s =
  let yaml = Utils.decode_or_raise Yaml.of_string s in
  match yaml with
  | `O [ ("jobs", `A xs) ] ->
    Ok
      (List.rev
         (List.mapi
            (fun i ->
              Utils.decode_or_raise (fun x ->
                  match metadata_of_yaml x with
                  | Ok raw ->
                    Ok
                      { id = i
                      ; title = raw.title
                      ; link = raw.link
                      ; description_html =
                          Omd.of_string raw.description |> Omd.to_html
                      ; location = raw.location
                      ; company = raw.company
                      ; company_logo = raw.company_logo
                      ; fullfilled = raw.fullfilled
                      }
                  | Error err ->
                    Error err))
            (List.rev xs)))
  | _ ->
    Error (`Msg "expected a list of jobs")

let parse = decode

let all () =
  let content = Data.read "jobs.yml" |> Option.get in
  Utils.decode_or_raise decode content

let pp ppf v =
  Fmt.pf
    ppf
    {|
  { id = %a
  ; title = %a
  ; link = %a
  ; description_html = %a
  ; location = %a
  ; company = %a
  ; company_logo = %a
  ; fullfilled = %a
  }|}
    Fmt.int
    v.id
    Pp.string
    v.title
    Pp.string
    v.link
    Pp.string
    v.description_html
    Pp.string
    v.location
    Pp.string
    v.company
    Pp.string
    v.company_logo
    Fmt.bool
    v.fullfilled

let pp_list = Pp.list pp

let template () =
  Format.asprintf
    {|
type t =
  { id : int
  ; title : string
  ; link : string
  ; description_html : string
  ; location : string
  ; company : string
  ; company_logo : string
  ; fullfilled : bool
  }
  
let all = %a
|}
    pp_list
    (all ())
