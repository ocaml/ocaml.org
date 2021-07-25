module Github = Current_github
module Git = Current_git

let v3_ocaml_org = "patricoferris/ocamlorg"

let site_directory = Current.state_dir "v3-ocaml-org"

let schedule = Current_cache.Schedule.v ()

type t =
  { (* The location of the opam repository *)
    opam_dir : Fpath.t
  ; (* The location of the site directory *)
    site_dir : Fpath.t;
    github : Github.Api.t;
  }

let site_dir t = t.site_dir

let init token =
  ignore @@ Bos.OS.Dir.create Ocamlorg.Config.opam_repository_path;
  { opam_dir = Ocamlorg.Config.opam_repository_path; site_dir = site_directory; github = Github.Api.of_oauth token }

let opam_repository ~callback t =
  let opam = Github.Repo_id.{ owner = "ocaml"; name = "opam-repository" } in
  let head = Github.Api.head_commit t.github opam in
  let commit = Git.fetch (Current.map Github.Api.Commit.id head) in
  Git_copy.copy ~callback ~commit t.opam_dir

let v t =
  let image = Current_docker.Default.pull ~schedule v3_ocaml_org in
  let main () =
    let v3_site =
      Docker_copy.copy ~src:(Fpath.v "/data") ~dst:t.site_dir image
    in
    let opam_repo =
      Current.map (fun _ -> ())
      @@ opam_repository ~callback:Ocamlorg.Package.callback t
    in
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

