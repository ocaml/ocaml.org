module Github = Current_github
module Git = Current_git

let v3_ocaml_org = "patricoferris/ocamlorg"

let site_directory = Current.state_dir "v3-ocaml-org"

let schedule = Current_cache.Schedule.v ()

type t =
  { opam_dir : Fpath.t
  ; callback : unit -> unit
  ; site_dir : Fpath.t
  }

let site_dir t = t.site_dir

let init ~opam_dir ~callback = { opam_dir; callback; site_dir = site_directory }

let opam_repository ~callback t =
  let schedule = Current_cache.Schedule.v ~valid_for:(Duration.of_min 5) () in
  let opam_repo = "https://github.com/ocaml/opam-repository.git" in
  let commit = Git.clone ~schedule opam_repo in
  Git_copy.copy ~callback ~commit t.opam_dir

let v t =
  let { site_dir; callback; _ } = t in
  let image = Current_docker.Default.pull ~schedule v3_ocaml_org in
  let main () =
    let v3_site = Docker_copy.copy ~src:(Fpath.v "/data") ~dst:site_dir image in
    let opam_repo = Current.map (fun _ -> ()) @@ opam_repository ~callback t in
    Current.all [ v3_site; opam_repo ]
  in
  let engine = Current.Engine.create main in
  let routes =
    Routes.((s "webhooks" / s "github" /? nil) @--> Github.webhook)
    :: Current_web.routes engine
  in
  let site =
    Current_web.Site.v
      ~name:"ocaml.org pipeline"
      ~has_role:(fun _ _ -> true)
      routes
  in
  Lwt.choose
    [ Current.Engine.thread engine
    ; Current_web.run ~mode:(`TCP (`Port 8081)) site
    ]
