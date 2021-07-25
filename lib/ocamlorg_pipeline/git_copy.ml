module Git = Current_git

module Copy = struct
  open Lwt.Infix

  type t = unit -> unit

  module Key = struct
    type t =
      { commit : Git.Commit.t
      ; dst : Fpath.t
      }

    let to_yojson t : Yojson.Safe.t =
      `Assoc
        [ "commit", `String (Git.Commit.hash t.commit)
        ; "dst", `String (Fpath.to_string t.dst)
        ]

    let digest t = Yojson.Safe.to_string (to_yojson t)
  end

  module Value = Current.Unit

  let id = "git-copy"

  let build callback job (key : Key.t) =
    let open Lwt_result.Syntax in
    Current.Job.start job ~level:Current.Level.Mostly_harmless >>= fun () ->
    let cp dir =
      ( ""
      , [| "cp"
         ; "-a"
         ; "--"
         ; Fpath.to_string dir ^ "/.git"
         ; Fpath.to_string key.dst
        |] )
    in
    let reset =
      ( ""
      , [| "git"
         ; "-C"
         ; Fpath.to_string key.dst
         ; "reset"
         ; "--hard"
         ; Git.Commit.hash key.commit
        |] )
    in
    let+ res =
      Git.with_checkout ~job key.commit (fun repo ->
          let* () = Current.Process.exec ~cancellable:true ~job (cp repo) in
          Current.Process.exec ~cancellable:true ~job reset)
    in
    callback ();
    res

  let pp f (key : Key.t) =
    Fmt.pf f "copying %a to %a" Git.Commit.pp key.commit Fpath.pp key.dst

  let auto_cancel = true
end

module CopyC = Current_cache.Make (Copy)

let copy ~callback ~commit dst =
  let open Current.Syntax in
  Current.component "copying"
  |> let> commit = commit in
     CopyC.get callback { Copy.Key.commit; dst }
