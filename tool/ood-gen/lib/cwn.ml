let path = Fpath.v "data/cwn"

type t = { date : string; body_html : string }

let all () =
  Utils.map_files_with_names
    (fun (file, content) ->
      let omd = Omd.of_string content in
      let date = Filename.basename file |> Filename.remove_extension in
      { date; body_html = Omd.to_html (Hilite.Md.transform omd) })
    "cwn/*.md"

let pp ppf v =
  Fmt.pf ppf {|
  { date = %a
  ; body_html = %a
  }|} Pp.string v.date
    Pp.string v.body_html

let pp_list = Pp.list pp

let template () =
  Format.asprintf
    {|
type t =
  { date : string
  ; body_html : string
  }
  
let all = %a
|}
    pp_list (all ())
