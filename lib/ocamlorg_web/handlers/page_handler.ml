let index site_dir = Dream.static site_dir

let not_found _req =
  Page_layout_template.render ~title:"Not found" Not_found_template.render
  |> Dream.html ~status:`Not_Found
