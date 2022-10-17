let index = "/"
let packages = "/packages"
let packages_search = "/packages/search"
let with_hash = function None -> "/p" | Some hash -> "/u/" ^ hash
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

let manual_with_version v =
  let minor = String.sub v 0 4 in
  "https://v2.ocaml.org/releases/" ^ minor ^ "/htmlman/index.html"

let manual = "https://v2.ocaml.org/releases/latest/manual.html"

let api_with_version v =
  let minor = String.sub v 0 4 in
  "https://v2.ocaml.org/releases/" ^ minor ^ "/api/index.html"

let api = "https://v2.ocaml.org/api/index.html"
let books = "/books"
let releases = "/releases"
let release v = "/releases/" ^ v
let workshop v = "/workshops/" ^ v
let blog = "/blog"
let news = "/news"
let news_post v = "/news/" ^ v
let jobs = "/jobs"
let carbon_footprint = "/carbon-footprint"
let privacy_policy = "/privacy-policy"
let governance = "/governance"
let playground = "/play"
let papers = "/papers"
let learn = "/docs"
let platform = "/docs/platform"
let ocaml_on_windows = "/docs/ocaml-on-windows"
let tutorial name = "/docs/" ^ name
let getting_started = tutorial "up-and-running"
let best_practices = "/docs/best-practices"
let problems = "/problems"
