module Docker = Current_docker

module Copy = struct
  open Docker.Raw

  type t = No_context

  module Key = struct
    type t =
      { docker_context : string option
      ; image : Docker.Default.Image.t
      ; src : Fpath.t
      ; dst : Fpath.t
      }

    let to_yojson t : Yojson.Safe.t =
      `Assoc
        [ ( "docker_context"
          , match t.docker_context with Some c -> `String c | None -> `Null )
        ; "image", `String (Docker.Default.Image.hash t.image)
        ; "src", `String (Fpath.to_string t.src)
        ; "dst", `String (Fpath.to_string t.dst)
        ]

    let cmd ~job { docker_context; image; src; dst } =
      let create =
        Cmd.docker ~docker_context [ "create"; Docker.Default.Image.hash image ]
      in
      let cp id =
        Cmd.docker
          ~docker_context
          [ "cp"
          ; Fmt.str "%s:%s/." id (Fpath.to_string src)
          ; Fpath.to_string dst
          ]
      in
      Cmd.with_container ~docker_context ~kill_on_cancel:true ~job create
      @@ fun id -> Current.Process.exec ~cancellable:true ~job (cp id)

    let digest t = Yojson.Safe.to_string (to_yojson t)
  end

  module Value = Current.Unit

  let id = "docker-copy"

  let build No_context job key =
    let open Lwt.Syntax in
    let* () = Current.Job.start job ~level:Current.Level.Mostly_harmless in
    Key.cmd ~job key

  let pp f (key : Key.t) =
    Fmt.pf f "copy %a:%a" Docker.Default.Image.pp key.image Fpath.pp key.src

  let auto_cancel = true
end

module CopyC = Current_cache.Make (Copy)

let copy ?docker_context ~src ~dst image =
  let open Current.Syntax in
  Current.component "copy %a" Fpath.pp src
  |> let> image = image in
     CopyC.get Copy.No_context { Copy.Key.docker_context; image; src; dst }
