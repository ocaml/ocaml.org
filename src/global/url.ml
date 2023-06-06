let index = "/"
let install = "/install"
let packages = "/packages"
let packages_search = "/packages/search"
let packages_autocomplete_fragment = "/packages/autocomplete"

module Package : sig
  val overview : ?hash:string -> ?version:string -> string -> string

  val documentation :
    ?hash:string -> ?version:string -> ?page:string -> string -> string

  val file :
    ?hash:string -> ?version:string -> filepath:string -> string -> string

  val search_index : ?version:string -> digest:string -> string -> string
end = struct
  let with_hash = Option.fold ~none:"/p" ~some:(( ^ ) "/u/")
  let with_version = Option.fold ~none:"/latest" ~some:(( ^ ) "/")

  let base ?hash ?version page name =
    with_hash hash ^ "/" ^ name ^ with_version version ^ page

  let overview ?hash ?version = base ?hash ?version ""

  let documentation ?hash ?version ?(page = "index.html") =
    base ?hash ?version ("/doc/" ^ page)

  let file ?hash ?version ~filepath = base ?hash ?version ("/" ^ filepath)
  let search_index ?version ~digest = base ?version ("/search-index/" ^ digest)
end

let sitemap = "/sitemap.xml"
let community = "/community"
let success_story v = "/success-stories/" ^ v
let industrial_users = "/industrial-users"
let academic_users = "/academic-users"
let about = "/about"

let minor v =
  match String.split_on_char '.' v with
  | x :: y :: _ -> x ^ "." ^ y
  | _ -> invalid_arg (v ^ ": invalid OCaml version")

let v2 = "https://v2.ocaml.org"
let manual_with_version v = v2 ^ "/releases/" ^ minor v ^ "/htmlman/index.html"
let manual = "/releases/latest/manual.html"
let api_with_version v = v2 ^ "/releases/" ^ minor v ^ "/api/index.html"
let api = "/releases/latest/api/index.html"
let books = "/books"
let changelog = "/changelog"
let releases = "/releases"
let release v = "/releases/" ^ v
let workshops = "/workshops"
let workshop v = "/workshops/" ^ v
let blog = "/blog"
let blog_post v = "/blog/" ^ v
let news = "/news"
let news_post v = "/news/" ^ v
let jobs = "/jobs"
let carbon_footprint = "/policies/carbon-footprint"
let privacy_policy = "/policies/privacy-policy"
let governance = "/policies/governance"
let code_of_conduct = "/policies/code-of-conduct"
let playground = "/play"
let papers = "/papers"
let learn = "/docs"
let platform = "/docs/platform"
let ocaml_on_windows = "/docs/ocaml-on-windows"
let tutorial name = "/docs/" ^ name
let getting_started = tutorial "up-and-running"
let best_practices = "/docs/best-practices"
let problems = "/problems"
let installer = "/install-platform.sh"
let outreachy = "/outreachy"

let github_installer =
  "https://github.com/tarides/ocaml-platform-installer/releases/latest/download/installer.sh"

let github_opam_file package_name package_version =
  Printf.sprintf
    "https://github.com/ocaml/opam-repository/blob/master/packages/%s/%s.%s/opam"
    package_name package_name package_version
