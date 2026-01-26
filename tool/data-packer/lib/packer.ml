(* The main packing logic *)

open Types

let pack_to_buffer data =
  let buf = Bigstringaf.create (1024 * 1024 * 128) in (* 128 MiB initial *)
  let pos = All_data.bin_write_t buf ~pos:0 data in
  Bigstringaf.sub buf ~off:0 ~len:pos

let pack_to_file ~output data =
  let buf = pack_to_buffer data in
  let oc = open_out_bin output in
  (* Write as raw bytes *)
  for i = 0 to Bigstringaf.length buf - 1 do
    output_char oc (Bigstringaf.get buf i)
  done;
  close_out oc;
  Printf.printf "Packed %d bytes to %s\n" (Bigstringaf.length buf) output

let load_all () =
  Printf.printf "Loading data from %s\n" (Fpath.to_string Utils.root_dir);

  (* Simple YAML data *)
  let testimonials = Testimonial_parser.all () in
  Printf.printf "  Loaded %d testimonials\n" (List.length testimonials);

  let academic_testimonials = Academic_testimonial_parser.all () in
  Printf.printf "  Loaded %d academic_testimonials\n" (List.length academic_testimonials);

  let jobs = Job_parser.all () in
  Printf.printf "  Loaded %d jobs\n" (List.length jobs);

  let opam_users = Opam_user_parser.all () in
  Printf.printf "  Loaded %d opam_users\n" (List.length opam_users);

  let resources = Resource_parser.all () in
  Printf.printf "  Loaded %d resources\n" (List.length resources);

  let featured_resources = Resource_parser.featured () in
  Printf.printf "  Loaded %d featured_resources\n" (List.length featured_resources);

  let videos = Video_parser.all () in
  Printf.printf "  Loaded %d videos\n" (List.length videos);

  (* Markdown-based content *)
  let academic_institutions = Academic_institution_parser.all () in
  Printf.printf "  Loaded %d academic_institutions\n" (List.length academic_institutions);

  let books = Book_parser.all () in
  Printf.printf "  Loaded %d books\n" (List.length books);

  let code_examples = Code_example_parser.all () in
  Printf.printf "  Loaded %d code_examples\n" (List.length code_examples);

  let papers = Paper_parser.all () in
  Printf.printf "  Loaded %d papers\n" (List.length papers);

  let tools = Tool_parser.all () in
  Printf.printf "  Loaded %d tools\n" (List.length tools);

  let releases = Release_parser.all () in
  Printf.printf "  Loaded %d releases\n" (List.length releases);

  let release_latest =
    try Some (Release_parser.latest ())
    with Invalid_argument _ -> None
  in
  Printf.printf "  Loaded release_latest: %s\n"
    (match release_latest with Some r -> r.version | None -> "none");

  let release_lts =
    try Some (Release_parser.lts ())
    with Invalid_argument _ -> None
  in
  Printf.printf "  Loaded release_lts: %s\n"
    (match release_lts with Some r -> r.version | None -> "none");

  let success_stories = Success_story_parser.all () in
  Printf.printf "  Loaded %d success_stories\n" (List.length success_stories);

  let industrial_users = Industrial_user_parser.all () in
  Printf.printf "  Loaded %d industrial_users\n" (List.length industrial_users);

  let news = News_parser.all () in
  Printf.printf "  Loaded %d news\n" (List.length news);

  let events = Event_parser.all () in
  Printf.printf "  Loaded %d events\n" (List.length events);

  let recurring_events = Event_parser.recurring_event_all () in
  Printf.printf "  Loaded %d recurring_events\n" (List.length recurring_events);

  let exercises = Exercise_parser.all () in
  Printf.printf "  Loaded %d exercises\n" (List.length exercises);

  let pages = Page_parser.all () in
  Printf.printf "  Loaded %d pages\n" (List.length pages);

  let conferences = Conference_parser.all () in
  Printf.printf "  Loaded %d conferences\n" (List.length conferences);

  let tutorials = Tutorial_parser.all () in
  Printf.printf "  Loaded %d tutorials\n" (List.length tutorials);

  let tutorial_search_documents = Tutorial_parser.all_search_documents () in
  Printf.printf "  Loaded %d tutorial_search_documents\n" (List.length tutorial_search_documents);

  (* Complex data structures *)
  let changelog = Changelog_parser.all () in
  Printf.printf "  Loaded %d changelog entries\n" (List.length changelog);

  let backstage = Backstage_parser.all () in
  Printf.printf "  Loaded %d backstage entries\n" (List.length backstage);

  let planet = Planet_parser.all () in
  Printf.printf "  Loaded %d planet entries\n" (List.length planet);

  let blog_sources = Blog_parser.all_sources () in
  Printf.printf "  Loaded %d blog_sources\n" (List.length blog_sources);

  let blog_posts = Blog_parser.all_posts () in
  Printf.printf "  Loaded %d blog_posts\n" (List.length blog_posts);

  let cookbook_recipes = Cookbook_parser.all () in
  Printf.printf "  Loaded %d cookbook_recipes\n" (List.length cookbook_recipes);

  let cookbook_tasks = Cookbook_parser.tasks in
  Printf.printf "  Loaded %d cookbook_tasks\n" (List.length cookbook_tasks);

  let cookbook_top_categories = Cookbook_parser.top_categories in
  Printf.printf "  Loaded %d cookbook_top_categories\n" (List.length cookbook_top_categories);

  let is_ocaml_yet = Is_ocaml_yet_parser.all () in
  Printf.printf "  Loaded %d is_ocaml_yet pages\n" (List.length is_ocaml_yet);

  let outreachy = Outreachy_parser.all () in
  Printf.printf "  Loaded %d outreachy rounds\n" (List.length outreachy);

  let governance_teams = Governance_parser.teams () in
  Printf.printf "  Loaded %d governance_teams\n" (List.length governance_teams);

  let governance_working_groups = Governance_parser.working_groups () in
  Printf.printf "  Loaded %d governance_working_groups\n" (List.length governance_working_groups);

  let tool_pages = Tool_page_parser.all () in
  Printf.printf "  Loaded %d tool_pages\n" (List.length tool_pages);

  {
    All_data.testimonials;
    academic_testimonials;
    jobs;
    opam_users;
    resources;
    featured_resources;
    videos;
    academic_institutions;
    books;
    code_examples;
    papers;
    tools;
    releases;
    release_latest;
    release_lts;
    success_stories;
    industrial_users;
    news;
    events;
    recurring_events;
    exercises;
    pages;
    conferences;
    tutorials;
    tutorial_search_documents;
    changelog;
    backstage;
    planet;
    blog_sources;
    blog_posts;
    cookbook_recipes;
    cookbook_tasks;
    cookbook_top_categories;
    is_ocaml_yet;
    outreachy;
    governance_teams;
    governance_working_groups;
    tool_pages;
  }
