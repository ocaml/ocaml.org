module Breadcrumbs = Breadcrumbs
module Navmap = Navmap
module Toc = Toc
module Url = Url
include Package_intf

let about () = About.render ()
let academic_users users = Academic_users.render users
let best_practices best_practices = Best_practices.render best_practices
let books books = Books.render books
let community ~workshops ~meetups = Community.render ~workshops ~meetups
let workshop ~videos workshop = Workshop.render ~videos workshop
let home () = Home.render ()

let industrial_users ~users ~success_stories =
  Industrial_users.render ~users ~success_stories

let learn ~papers ~release ~books = Learn.render ~papers ~release ~books
let platform tools = Platform.render tools

let blog ~featured ~rss ~rss_page ~rss_pages_number ~news =
  Blog.render ~featured ~rss ~rss_page ~rss_pages_number ~news

let news ~page ~pages_number news = News.render ~page ~pages_number news
let news_post news = News_post.render news
let jobs ?location ~locations jobs = Jobs.render ?location ~locations jobs

let package_overview ~documentation_status ~readme ~readme_title ~dependencies
    ~rev_dependencies ~conflicts ~homepages ~source ~changes_filename
    ~license_filename package =
  Package_overview.render ~documentation_status ~readme ~readme_title
    ~dependencies ~rev_dependencies ~conflicts ~homepages ~source
    ~changes_filename ~license_filename package

let package_documentation ~title ~path ~toc ~maptoc ~content package =
  Package_documentation.render ~title ~path ~toc ~maptoc ~content package

let packages stats = Packages.render stats
let packages_search ~total packages = Packages_search.render ~total packages

let papers ?search ~recommended_papers papers =
  Papers.render ?search ~recommended_papers papers

let problems problems = Problems.render problems
let release release = Release.render release
let releases ?search releases = Releases.render ?search releases
let success_story success_story = Success_story.render success_story
let tutorial tutorial ~canonical = Tutorial.render tutorial ~canonical

let page ~title ~description ~meta_title ~meta_description ~content ~canonical =
  Page.render ~title ~description ~meta_title ~meta_description ~content
    ~canonical

let playground () = Playground.render ()
let not_found () = Not_found.render ()
