type metadata = {
  title : string;
  link : string;
  location : string;
  company : string;
  company_logo : string;
}
[@@deriving yaml]

type job = {
  title : string;
  link : string;
  location : string;
  company : string;
  company_logo : string;
}
[@@deriving yaml]

type t = job list [@@deriving yaml]

let all () =
  let s = Data.read "jobs.yml" |> Option.get in
  let yaml = Utils.decode_or_raise Yaml.of_string s in
  Utils.decode_or_raise of_yaml yaml

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
