module Url = Url
module Navmap = Navmap
module Toc = Toc

type package = Package_intf.meta =
  { name : string
  ; description : string
  ; license : string
  ; version : string
  ; versions : string list
  ; tags : string list
  ; authors : Ood.Opam_user.t list
  ; maintainers : Ood.Opam_user.t list
  }

let about () = About.render ()

let academic_users users = Academic_users.render users

let best_practices best_practices = Best_practices.render best_practices

let books books = Books.render books

let community () = Community.render ()

let workshop ~videos workshop = Workshop.render ~videos workshop

let events ~workshops ~meetups = Events.render ~workshops ~meetups

let home () = Home.render ()

let industrial_users users = Industrial_users.render users

let learn ~papers ~release ~books = Learn.render ~papers ~release ~books

let manual () = Manual.render ()

let blog () = Blog.render ()

let blog_category () = Blog_category.render ()

let opportunities ?search ?country opportunities =
  Opportunities.render ?search ?country opportunities

let opportunity opportunity = Opportunity.render opportunity

let package_overview
    ~readme ~dependencies ~rev_dependencies ~homepages ~source package
  =
  Package_overview.render
    ~readme
    ~dependencies
    ~rev_dependencies
    ~homepages
    ~source
    package

let package_documentation
    ~documentation_status
    ~toplevel_status
    ~title
    ~path
    ~toc
    ~maptoc
    ~content
    package
  =
  Package_documentation.render
    ~documentation_status
    ~toplevel_status
    ~title
    ~path
    ~toc
    ~maptoc
    ~content
    package

let package_toplevel
    ~documentation_status ~toplevel_status ~toplevel_url package
  =
  Package_toplevel.render
    ~documentation_status
    ~toplevel_status
    ~toplevel_url
    package

let packages packages = Packages.render packages

let packages_search ~total packages = Packages_search.render ~total packages

let papers ?search ~recommended_papers papers =
  Papers.render ?search ~recommended_papers papers

let problems problems = Problems.render problems

let release release = Release.render release

let releases ?search releases = Releases.render ?search releases

let success_stories success_stories = Success_stories.render success_stories

let success_story success_story = Success_story.render success_story

let tutorial tutorial = Tutorial.render tutorial

let carbon_footprint () = Carbon_footprint.render ()

let privacy () = Privacy.render ()

let terms () = Terms.render ()

let not_found () = Not_found.render ()
