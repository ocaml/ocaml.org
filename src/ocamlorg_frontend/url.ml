let index = "/"
let learn = "/learn"
let packages = "/packages"
let packages_search = "/packages/search"
let package v = "/p/" ^ v
let package_with_univ hash v = "/u/" ^ hash ^ "/" ^ v
let package_with_version v version = "/p/" ^ v ^ "/" ^ version

let package_with_hash_with_version hash v version =
  "/u/" ^ hash ^ "/" ^ v ^ "/" ^ version

let package_toplevel v version = "/p/" ^ v ^ "/" ^ version ^ "/toplevel"

let package_toplevel_with_hash hash v version =
  "/u/" ^ hash ^ "/" ^ v ^ "/" ^ version ^ "/toplevel"

let package_doc v version page = "/p/" ^ v ^ "/" ^ version ^ "/doc/" ^ page

let package_doc_with_hash hash v version page =
  "/u/" ^ hash ^ "/" ^ v ^ "/" ^ version ^ "/doc/" ^ page

let community = "/community"
let success_stories = "/success-stories"
let success_story v = "/success-stories/" ^ v
let industrial_users = "/industrial-users"
let academic_users = "/academic-users"
let about = "/about"
let manual_with_version v = "/manual/" ^ v
let manual = "/manual"
let books = "/books"
let releases = "/releases"
let release v = "/releases/" ^ v
let events = "/events"
let workshop v = "/workshops/" ^ v
let blog = "/blog"
let news = "/news"
let news_post v = "/news/" ^ v
let opportunities = "/opportunities"
let opportunity v = "/opportunities/" ^ v
let carbon_footprint = "/carbon-footprint"
let playground = "/playground"
let papers = "/papers"
let tutorial name = "/learn/" ^ name
let getting_started = tutorial "up-and-running-with-ocaml"
let best_practices = "/learn/best-practices"
let problems = "/problems"
let platform s = "/platform/" ^ s
