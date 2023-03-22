let index = "/"
let packages = "/packages"
let packages_search = "/packages/search"
let packages_autocomplete_fragment = "/packages/autocomplete"
let with_hash = Option.fold ~none:"/p" ~some:(( ^ ) "/u/")
let with_version = Option.value ~default:"latest"
let with_page p = if p = "" then "" else "/" ^ p

let package_overview ?version ?hash name =
  with_hash hash ^ "/" ^ name ^ "/" ^ with_version version

let package_documentation ?hash ?version ?(page = "index.html") name =
  with_hash hash ^ "/" ^ name ^ "/" ^ with_version version ^ "/doc/" ^ page

let package_file ?version ?hash ~filepath name =
  with_hash hash ^ "/" ^ name ^ "/" ^ with_version version ^ "/" ^ filepath

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
let releases = "/releases"
let release v = "/releases/" ^ v
let workshops = "/workshops"
let workshop v = "/workshops/" ^ v
let blog = "/blog"
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

let github_installer =
  "https://github.com/tarides/ocaml-platform-installer/releases/latest/download/installer.sh"

let github_opam_file package_name package_version =
  Printf.sprintf
    "https://github.com/ocaml/opam-repository/blob/master/packages/%s/%s.%s/opam"
    package_name package_name package_version
