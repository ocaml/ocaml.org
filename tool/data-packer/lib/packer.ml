(* The main packing logic *)

open Types

let pack_to_buffer data =
  let buf = Bigstringaf.create (1024 * 1024 * 128) in
  (* 128 MiB initial *)
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
  Printf.eprintf "Packed %d bytes to %s\n" (Bigstringaf.length buf) output

let load_all () =
  let testimonials = Testimonial_parser.all () in
  let academic_testimonials = Academic_testimonial_parser.all () in
  let jobs = Job_parser.all () in
  let opam_users = Opam_user_parser.all () in
  let resources = Resource_parser.all () in
  let featured_resources = Resource_parser.featured () in
  let videos = Video_parser.all () in
  let academic_institutions = Academic_institution_parser.all () in
  let books = Book_parser.all () in
  let code_examples = Code_example_parser.all () in
  let papers = Paper_parser.all () in
  let tools = Tool_parser.all () in
  let releases = Release_parser.all () in
  let release_latest =
    try Some (Release_parser.latest ()) with Invalid_argument _ -> None
  in
  let release_lts =
    try Some (Release_parser.lts ()) with Invalid_argument _ -> None
  in
  let success_stories = Success_story_parser.all () in
  let industrial_users = Industrial_user_parser.all () in
  let news = News_parser.all () in
  let events = Event_parser.all () in
  let recurring_events = Event_parser.recurring_event_all () in
  let exercises = Exercise_parser.all () in
  let pages = Page_parser.all () in
  let conferences = Conference_parser.all () in
  let tutorials = Tutorial_parser.all () in
  let tutorial_search_documents = Tutorial_parser.all_search_documents () in
  let changelog = Changelog_parser.all () in
  let backstage = Backstage_parser.all () in
  let planet = Planet_parser.all () in
  let blog_sources = Blog_parser.all_sources () in
  let blog_posts = Blog_parser.all_posts () in
  let cookbook_recipes = Cookbook_parser.all () in
  let cookbook_tasks = Cookbook_parser.tasks in
  let cookbook_top_categories = Cookbook_parser.top_categories in
  let is_ocaml_yet = Is_ocaml_yet_parser.all () in
  let outreachy = Outreachy_parser.all () in
  let governance_teams = Governance_parser.teams () in
  let governance_working_groups = Governance_parser.working_groups () in
  let tool_pages = Tool_page_parser.all () in
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
