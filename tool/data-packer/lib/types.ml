(* Data types imported from Data_intf. Uses ppx_import to avoid duplicating type
   definitions. The aggregate is serialised to the embedded blob with Marshal
   (see Packer/Unpacker), so no per-type bin_prot deriver is needed. *)

(* Simple types *)

module Testimonial = struct
  type t = [%import: Data_intf.Testimonial.t] [@@deriving of_yaml, show]
end

module Job = struct
  type t = [%import: Data_intf.Job.t] [@@deriving of_yaml, show]
end

module Code_example = struct
  type t = Data_intf.Code_examples.t = { title : string; body : string }
  [@@deriving of_yaml, show]
end

module Opam_user = struct
  type t = [%import: Data_intf.Opam_user.t] [@@deriving of_yaml, show]
end

module Resource = struct
  type t = [%import: Data_intf.Resource.t] [@@deriving of_yaml, show]
end

module Video = struct
  type t = [%import: Data_intf.Video.t] [@@deriving show]
end

module Academic_testimonial = struct
  type t = [%import: Data_intf.Academic_testimonial.t]
  [@@deriving of_yaml, show]
end

(* Types with nested definitions *)

module Book = struct
  type difficulty = [%import: Data_intf.Book.difficulty] [@@deriving show]

  let difficulty_of_yaml = function
    | `String "beginner" -> Ok Beginner
    | `String "intermediate" -> Ok Intermediate
    | `String "advanced" -> Ok Advanced
    | _ -> Error (`Msg "Invalid difficulty")

  type link = [%import: Data_intf.Book.link] [@@deriving of_yaml, show]
  type t = [%import: Data_intf.Book.t] [@@deriving show]
end

module Academic_institution = struct
  type location = [%import: Data_intf.Academic_institution.location]
  [@@deriving of_yaml, show]

  type course = [%import: Data_intf.Academic_institution.course]
  [@@deriving show]

  type t = [%import: Data_intf.Academic_institution.t] [@@deriving show]
end

module Event = struct
  type event_type = [%import: Data_intf.Event.event_type] [@@deriving show]

  let event_type_of_yaml = function
    | `String "meetup" -> Ok Meetup
    | `String "conference" -> Ok Conference
    | `String "seminar" -> Ok Seminar
    | `String "hackathon" -> Ok Hackathon
    | `String "retreat" -> Ok Retreat
    | _ -> Error (`Msg "Invalid event_type")

  type location = [%import: Data_intf.Event.location] [@@deriving of_yaml, show]

  type recurring_event = [%import: Data_intf.Event.recurring_event]
  [@@deriving show]

  type utc_datetime = [%import: Data_intf.Event.utc_datetime]
  [@@deriving of_yaml, show]

  type t = [%import: Data_intf.Event.t] [@@deriving show]
end

module Exercise = struct
  type difficulty = [%import: Data_intf.Exercise.difficulty] [@@deriving show]

  let difficulty_of_yaml = function
    | `String "beginner" -> Ok Beginner
    | `String "intermediate" -> Ok Intermediate
    | `String "advanced" -> Ok Advanced
    | _ -> Error (`Msg "Invalid difficulty")

  type t = [%import: Data_intf.Exercise.t] [@@deriving show]
end

module Paper = struct
  type link = [%import: Data_intf.Paper.link] [@@deriving of_yaml, show]
  type t = [%import: Data_intf.Paper.t] [@@deriving show]
end

module Tool = struct
  type lifecycle = [%import: Data_intf.Tool.lifecycle] [@@deriving show]

  let lifecycle_of_yaml = function
    | `String "incubate" -> Ok `Incubate
    | `String "active" -> Ok `Active
    | `String "sustain" -> Ok `Sustain
    | `String "deprecate" -> Ok `Deprecate
    | _ -> Error (`Msg "Invalid lifecycle")

  type t = [%import: Data_intf.Tool.t] [@@deriving show]
end

module Release = struct
  type kind = [%import: Data_intf.Release.kind] [@@deriving show]
  type t = [%import: Data_intf.Release.t] [@@deriving show]
end

module Success_story = struct
  type t = [%import: Data_intf.Success_story.t] [@@deriving show]
end

module Industrial_user = struct
  type t = [%import: Data_intf.Industrial_user.t] [@@deriving show]
end

module News = struct
  type t = [%import: Data_intf.News.t] [@@deriving show]
end

module Page = struct
  type t = [%import: Data_intf.Page.t] [@@deriving show]
end

module Outreachy = struct
  type project = [%import: Data_intf.Outreachy.project]
  [@@deriving of_yaml, show]

  type t = [%import: Data_intf.Outreachy.t] [@@deriving of_yaml, show]
end

module Governance = struct
  type member = [%import: Data_intf.Governance.member]
  [@@deriving of_yaml, show]

  type contact_kind = [%import: Data_intf.Governance.contact_kind]
  [@@deriving show]

  type contact = [%import: Data_intf.Governance.contact] [@@deriving show]

  type dev_meeting = [%import: Data_intf.Governance.dev_meeting]
  [@@deriving show]

  type team = [%import: Data_intf.Governance.team] [@@deriving show]
end

module Conference = struct
  type role = [%import: Data_intf.Conference.role] [@@deriving show]

  type important_date = [%import: Data_intf.Conference.important_date]
  [@@deriving show]

  type committee_member = [%import: Data_intf.Conference.committee_member]
  [@@deriving show]

  type presentation = [%import: Data_intf.Conference.presentation]
  [@@deriving show]

  type t = [%import: Data_intf.Conference.t] [@@deriving show]
end

module Blog = struct
  type source = [%import: Data_intf.Blog.source] [@@deriving show]
  type post = [%import: Data_intf.Blog.post] [@@deriving show]
end

module Changelog = struct
  type release = [%import: Data_intf.Changelog.release] [@@deriving show]
  type post = [%import: Data_intf.Changelog.post] [@@deriving show]
  type t = [%import: Data_intf.Changelog.t] [@@deriving show]
end

module Backstage = struct
  type release = [%import: Data_intf.Backstage.release] [@@deriving show]
  type post = [%import: Data_intf.Backstage.post] [@@deriving show]
  type t = [%import: Data_intf.Backstage.t] [@@deriving show]
end

module Cookbook = struct
  type category = [%import: Data_intf.Cookbook.category] [@@deriving show]
  type task = [%import: Data_intf.Cookbook.task] [@@deriving show]

  type code_block_with_explanation =
    [%import: Data_intf.Cookbook.code_block_with_explanation]
  [@@deriving show]

  type package = [%import: Data_intf.Cookbook.package]
  [@@deriving of_yaml, show]

  type t = [%import: Data_intf.Cookbook.t] [@@deriving show]
end

module Is_ocaml_yet = struct
  type external_package = [%import: Data_intf.Is_ocaml_yet.external_package]
  [@@deriving show]

  type package = [%import: Data_intf.Is_ocaml_yet.package] [@@deriving show]
  type category = [%import: Data_intf.Is_ocaml_yet.category] [@@deriving show]
  type t = [%import: Data_intf.Is_ocaml_yet.t] [@@deriving show]
end

module Tutorial = struct
  type section = [%import: Data_intf.Tutorial.section] [@@deriving show]
  type toc = [%import: Data_intf.Tutorial.toc] [@@deriving show]

  type contribute_link = [%import: Data_intf.Tutorial.contribute_link]
  [@@deriving show]

  type banner = [%import: Data_intf.Tutorial.banner] [@@deriving of_yaml, show]

  type external_tutorial = [%import: Data_intf.Tutorial.external_tutorial]
  [@@deriving show]

  type recommended_next_tutorials =
    [%import: Data_intf.Tutorial.recommended_next_tutorials]
  [@@deriving show]

  type prerequisite_tutorials =
    [%import: Data_intf.Tutorial.prerequisite_tutorials]
  [@@deriving show]

  type search_document_section =
    [%import: Data_intf.Tutorial.search_document_section]
  [@@deriving show]

  type search_document = [%import: Data_intf.Tutorial.search_document]
  [@@deriving show]

  type t = [%import: Data_intf.Tutorial.t] [@@deriving show]
end

module Tool_page = struct
  type toc = [%import: Data_intf.Tool_page.toc] [@@deriving of_yaml, show]

  type contribute_link = [%import: Data_intf.Tool_page.contribute_link]
  [@@deriving show]

  type t = [%import: Data_intf.Tool_page.t] [@@deriving show]
end

module Planet = struct
  (* Entry type - BlogPost or Video. We define it directly with type equality
     since ppx_import has trouble with types referencing other modules. *)
  type entry = Data_intf.Planet.entry =
    | BlogPost of Blog.post
    | Video of Video.t
  [@@deriving show]
end

(* The aggregated data structure containing all types *)
module All_data = struct
  type t = {
    (* Simple YAML data *)
    testimonials : Testimonial.t list;
    academic_testimonials : Academic_testimonial.t list;
    jobs : Job.t list;
    opam_users : Opam_user.t list;
    resources : Resource.t list;
    featured_resources : Resource.t list;
    videos : Video.t list;
    (* Markdown-based content *)
    academic_institutions : Academic_institution.t list;
    books : Book.t list;
    code_examples : Code_example.t list;
    papers : Paper.t list;
    tools : Tool.t list;
    releases : Release.t list;
    release_latest : Release.t option;
    release_lts : Release.t option;
    success_stories : Success_story.t list;
    industrial_users : Industrial_user.t list;
    news : News.t list;
    events : Event.t list;
    recurring_events : Event.recurring_event list;
    exercises : Exercise.t list;
    pages : Page.t list;
    conferences : Conference.t list;
    tutorials : Tutorial.t list;
    tutorial_search_documents : Tutorial.search_document list;
    (* Complex data structures *)
    changelog : Changelog.t list;
    backstage : Backstage.t list;
    planet : Planet.entry list;
    blog_sources : Blog.source list;
    blog_posts : Blog.post list;
    cookbook_recipes : Cookbook.t list;
    cookbook_tasks : Cookbook.task list;
    cookbook_top_categories : Cookbook.category list;
    is_ocaml_yet : Is_ocaml_yet.t list;
    outreachy : Outreachy.t list;
    governance_teams : Governance.team list;
    governance_working_groups : Governance.team list;
    tool_pages : Tool_page.t list;
  }

  let empty =
    {
      testimonials = [];
      academic_testimonials = [];
      jobs = [];
      opam_users = [];
      resources = [];
      featured_resources = [];
      videos = [];
      academic_institutions = [];
      books = [];
      code_examples = [];
      papers = [];
      tools = [];
      releases = [];
      release_latest = None;
      release_lts = None;
      success_stories = [];
      industrial_users = [];
      news = [];
      events = [];
      recurring_events = [];
      exercises = [];
      pages = [];
      conferences = [];
      tutorials = [];
      tutorial_search_documents = [];
      changelog = [];
      backstage = [];
      planet = [];
      blog_sources = [];
      blog_posts = [];
      cookbook_recipes = [];
      cookbook_tasks = [];
      cookbook_top_categories = [];
      is_ocaml_yet = [];
      outreachy = [];
      governance_teams = [];
      governance_working_groups = [];
      tool_pages = [];
    }
end
