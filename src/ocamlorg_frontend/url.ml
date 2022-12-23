let index = "/"
let packages = "/packages"
let packages_search = "/packages/search"
let with_hash = Option.fold ~none:"/p" ~some:(( ^ ) "/u/")
let package ?hash v = with_hash hash ^ "/" ^ v
let package_docs v = "/p/" ^ v ^ "/doc"

let package_with_version ?hash v version =
  with_hash hash ^ "/" ^ v ^ "/" ^ version

let package_doc ?hash ?(page = "index.html") v version =
  with_hash hash ^ "/" ^ v ^ "/" ^ version ^ "/doc/" ^ page

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
