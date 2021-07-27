type t =
  { name : string
  ; handle : string option
  ; image : string option
  }

let make ~name ?handle ?image () = { name; handle; image }

let all =
  [ { name = "Xavier Leroy"
    ; handle = Some "xavierleroy"
    ; image = Some "https://avatars.githubusercontent.com/u/3845810?v=4"
    }
  ; { name = "Damien Doligez"
    ; handle = Some "damiendoligez"
    ; image = Some "https://avatars.githubusercontent.com/u/19104?v=4"
    }
  ; { name = "David Allsopp"
    ; handle = Some "dra27"
    ; image = Some "https://avatars.githubusercontent.com/u/5250680?v=4"
    }
  ; { name = "Alain Frisch"
    ; handle = Some "alainfrisch"
    ; image = Some "https://avatars.githubusercontent.com/u/3305274?v=4"
    }
  ; { name = "Gabriel Scherer"
    ; handle = Some "gasche"
    ; image = Some "https://avatars.githubusercontent.com/u/426238?v=4"
    }
  ; { name = "Jacques Garrigue"
    ; handle = Some "garrigue"
    ; image = Some "https://avatars.githubusercontent.com/u/870242?v=4"
    }
  ; { name = "Anil Madhavapeddy"
    ; handle = Some "avsm"
    ; image = Some "https://avatars.githubusercontent.com/u/53164?v=4"
    }
  ; { name = "Lucas Pluvinage"
    ; handle = Some "TheLortex"
    ; image = Some "https://avatars.githubusercontent.com/u/966015?v=4"
    }
  ; { name = "Jon Ludlam"
    ; handle = Some "jonludlam"
    ; image = Some "https://avatars.githubusercontent.com/u/210963?v=4"
    }
  ; { name = "Thibaut Mattio"
    ; handle = Some "tmattio"
    ; image = Some "https://avatars.githubusercontent.com/u/6162008?v=4"
    }
  ; { name = "Anton Bachin"
    ; handle = Some "aantron"
    ; image = Some "https://avatars.githubusercontent.com/u/12073668?v=4"
    }
  ; { name = "Patrick Ferris"
    ; handle = Some "patricoferris"
    ; image = Some "https://avatars.githubusercontent.com/u/20166594?v=4"
    }
  ; { name = "Didier Rémy"
    ; handle = Some "diremy"
    ; image = Some "https://avatars.githubusercontent.com/u/1357930?v=4"
    }
  ; { name = "Gabriel Radanne"
    ; handle = Some "Drup"
    ; image = Some "https://avatars.githubusercontent.com/u/801124?v=4"
    }
  ; { name = "Daniel Bünzli"
    ; handle = Some "dbuenzli"
    ; image = Some "https://avatars.githubusercontent.com/u/485596?v=4"
    }
  ]

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
