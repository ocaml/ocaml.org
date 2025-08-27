let re_slug =
  let open Re in
  let re_project_name =
    let w = rep1 alpha in
    seq [ w; rep (seq [ char '-'; w ]) ]
  in
  let re_version_string = seq [ digit; rep1 any ] in
  compile
    (seq
       [
         bos;
         seq
           [
             group (rep1 digit);
             char '-';
             group (rep1 digit);
             char '-';
             group (rep1 digit);
           ];
         char '-';
         opt
           (seq
              [ group re_project_name; set "-."; group re_version_string; eos ]);
       ])

let parse_slug s =
  match Re.exec_opt re_slug s with
  | None -> None
  | Some g ->
      let int n = Re.Group.get g n |> int_of_string in
      let year = int 1 in
      let month = int 2 in
      let day = int 3 in
      let version = Re.Group.get_opt g 5 in
      Some (Printf.sprintf "%04d-%02d-%02d" year month day, version)
