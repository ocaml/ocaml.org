module Url = Url

let about () = About.render ()

let academic_users users = Academic_users.render users

let best_practices best_practices = Best_practices.render best_practices

let books () = Books.render ()

let community () = Community.render ()

let workshop () = Workshop.render ()

let events () = Events.render ()

let home () = Home.render ()

let industrial_users () = Industrial_users.render ()

let learn ~papers ~release ~books = Learn.render ~papers ~release ~books

let manual () = Manual.render ()

let blog () = Blog.render ()

let blog_category () = Blog_category.render ()

let opportunities () = Opportunities.render ()

let opportunity () = Opportunity.render ()

let package_overview () = Package_overview.render ()

let package_documentation () = Package_documentation.render ()


let package_toplevel () = Package_toplevel.render ()


let packages () = Packages.render ()

let packages_search () = Packages_search.render ()

let papers () = Papers.render ()

let problems () = Problems.render ()

let release () = Release.render ()

let releases () = Releases.render ()

let success_stories () = Success_stories.render ()

let success_story () = Success_story.render ()

let tutorial () = Tutorial.render ()

let carbon_footprint () = Carbon_footprint.render ()

let privacy () = Privacy.render ()

let terms () = Terms.render ()

let not_found () = Not_found.render ()
