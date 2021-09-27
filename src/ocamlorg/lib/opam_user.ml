type t = Ood.Opam_user.t =
  { name : string
  ; email : string option
  ; github_username : string option
  ; avatar : string option
  }

let make ~name ?email ?github_username ?avatar () =
  { name; email; github_username; avatar }

let all = Ood.Opam_user.all

let find_by_name s =
  let pattern = String.lowercase_ascii s in
  let contains s1 s2 =
    try
      let len = String.length s2 in
      for i = 0 to String.length s1 - len do
        if String.sub s1 i len = s2 then raise Exit
      done;
      false
    with
    | Exit ->
      true
  in
  all
  |> List.find_opt (fun { name; _ } ->
         if contains pattern (String.lowercase_ascii @@ name) then
           true
         else
           false)
