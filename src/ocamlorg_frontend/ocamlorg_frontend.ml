module Url = Url
module Navmap = Navmap
module Toc = Toc
include Package_intf

let about () = About.render ()
let academic_users users = Academic_users.render users
let best_practices best_practices = Best_practices.render best_practices
let books books = Books.render books
let community ~workshops ~meetups = Community.render ~workshops ~meetups
let workshop ~videos workshop = Workshop.render ~videos workshop
let home () = Home.render ()
let industrial_users ~users ~success_stories = Industrial_users.render ~users ~success_stories
let learn ~papers ~release ~books = Learn.render ~papers ~release ~books
let platform tools = Platform.render tools

let blog ~featured ~rss ~rss_page ~rss_pages_number ~news =
  Blog.render ~featured ~rss ~rss_page ~rss_pages_number ~news

let news ~page ~pages_number news = News.render ~page ~pages_number news
let news_post news = News_post.render news

let opportunities ?search ?location ~locations opportunities =
  Opportunities.render ?search ?location ~locations opportunities

let package_overview ~readme ~dependencies ~rev_dependencies ~homepages ~source
    package =
  Package_overview.render ~readme ~dependencies ~rev_dependencies ~homepages
    ~source package

let package_documentation ~documentation_status ~toplevel_status ~title ~path
    ~toc ~maptoc ~content package =
  Package_documentation.render ~documentation_status ~toplevel_status ~title
    ~path ~toc ~maptoc ~content package

let package_toplevel ~documentation_status ~toplevel_status ~toplevel_url
    package =
  Package_toplevel.render ~documentation_status ~toplevel_status ~toplevel_url
    package

let packages stats = Packages.render stats
let packages_search ~total packages = Packages_search.render ~total packages

let papers ?search ~recommended_papers papers =
  Papers.render ?search ~recommended_papers papers

let problems problems = Problems.render problems
let release release = Release.render release
let releases ?search releases = Releases.render ?search releases
let success_story success_story = Success_story.render success_story
let tutorial tutorial = Tutorial.render tutorial

let page ~title ~description ~meta_title ~meta_description ~content =
  Page.render ~title ~description ~meta_title ~meta_description ~content

let not_found () = Not_found.render ()
