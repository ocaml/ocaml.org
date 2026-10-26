(* Data types imported from Data_intf. Uses ppx_import to avoid duplicating type
   definitions. The aggregate is serialised to the embedded blob with Marshal
   (see Packer/Unpacker), so no per-type bin_prot deriver is needed. *)

(* Simple types *)

module Testimonial = struct
  type t = [%import: Data_intf.Testimonial.t] [@@deriving of_yaml]
end

module Job = struct
  type t = [%import: Data_intf.Job.t] [@@deriving of_yaml]
end

module Code_example = struct
  type t = Data_intf.Code_examples.t = { title : string; body : string }
  [@@deriving of_yaml]
end

module Opam_user = struct
  type t = [%import: Data_intf.Opam_user.t] [@@deriving of_yaml]
end

module Resource = struct
  type t = [%import: Data_intf.Resource.t] [@@deriving of_yaml]
end

module Video = struct
  type t = Data_intf.Video.t
end

module Academic_testimonial = struct
  type t = [%import: Data_intf.Academic_testimonial.t] [@@deriving of_yaml]
end

(* Types with nested definitions *)

module Book = struct
  type difficulty = Data_intf.Book.difficulty

  let difficulty_of_yaml : _ -> (difficulty, [> `Msg of string ]) result =
    function
    | `String "beginner" -> Ok Beginner
    | `String "intermediate" -> Ok Intermediate
    | `String "advanced" -> Ok Advanced
    | _ -> Error (`Msg "Invalid difficulty")

  type link = [%import: Data_intf.Book.link] [@@deriving of_yaml]
  type t = Data_intf.Book.t
end

module Academic_institution = struct
  type location = [%import: Data_intf.Academic_institution.location]
  [@@deriving of_yaml]

  type course = Data_intf.Academic_institution.course
  type t = Data_intf.Academic_institution.t
end

module Event = struct
  type event_type = Data_intf.Event.event_type

  let event_type_of_yaml : _ -> (event_type, [> `Msg of string ]) result =
    function
    | `String "meetup" -> Ok Meetup
    | `String "conference" -> Ok Conference
    | `String "seminar" -> Ok Seminar
    | `String "hackathon" -> Ok Hackathon
    | `String "retreat" -> Ok Retreat
    | _ -> Error (`Msg "Invalid event_type")

  type location = [%import: Data_intf.Event.location] [@@deriving of_yaml]
  type recurring_event = Data_intf.Event.recurring_event

  type utc_datetime = [%import: Data_intf.Event.utc_datetime]
  [@@deriving of_yaml]

  type t = Data_intf.Event.t
end

module Exercise = struct
  type difficulty = Data_intf.Exercise.difficulty

  let difficulty_of_yaml : _ -> (difficulty, [> `Msg of string ]) result =
    function
    | `String "beginner" -> Ok Beginner
    | `String "intermediate" -> Ok Intermediate
    | `String "advanced" -> Ok Advanced
    | _ -> Error (`Msg "Invalid difficulty")

  type t = Data_intf.Exercise.t
end

module Paper = struct
  type link = [%import: Data_intf.Paper.link] [@@deriving of_yaml]
  type t = Data_intf.Paper.t
end

module Tool = struct
  type lifecycle = Data_intf.Tool.lifecycle

  let lifecycle_of_yaml = function
    | `String "incubate" -> Ok `Incubate
    | `String "active" -> Ok `Active
    | `String "sustain" -> Ok `Sustain
    | `String "deprecate" -> Ok `Deprecate
    | _ -> Error (`Msg "Invalid lifecycle")

  type t = Data_intf.Tool.t
end

module Release = struct
  type kind = Data_intf.Release.kind
  type t = Data_intf.Release.t
end

module Success_story = struct
  type t = Data_intf.Success_story.t
end

module Industrial_user = struct
  type t = Data_intf.Industrial_user.t
end

module News = struct
  type t = Data_intf.News.t
end

module Page = struct
  type t = Data_intf.Page.t
end

module Outreachy = struct
  type project = [%import: Data_intf.Outreachy.project] [@@deriving of_yaml]
  type t = [%import: Data_intf.Outreachy.t] [@@deriving of_yaml]
end

module Governance = struct
  type member = [%import: Data_intf.Governance.member] [@@deriving of_yaml]
  type contact_kind = Data_intf.Governance.contact_kind
  type contact = Data_intf.Governance.contact
  type dev_meeting = Data_intf.Governance.dev_meeting
  type team = Data_intf.Governance.team
end

module Conference = struct
  type role = Data_intf.Conference.role
  type important_date = Data_intf.Conference.important_date
  type committee_member = Data_intf.Conference.committee_member
  type presentation = Data_intf.Conference.presentation
  type t = Data_intf.Conference.t
end

module Blog = struct
  type source = Data_intf.Blog.source
  type post = Data_intf.Blog.post
end

module Changelog = struct
  type release = Data_intf.Changelog.release
  type post = Data_intf.Changelog.post
  type t = Data_intf.Changelog.t
end

module Backstage = struct
  type release = Data_intf.Backstage.release
  type post = Data_intf.Backstage.post
  type t = Data_intf.Backstage.t
end

module Cookbook = struct
  type category = Data_intf.Cookbook.category
  type task = Data_intf.Cookbook.task

  type code_block_with_explanation =
    Data_intf.Cookbook.code_block_with_explanation

  type package = [%import: Data_intf.Cookbook.package] [@@deriving of_yaml]
  type t = Data_intf.Cookbook.t
end

module Is_ocaml_yet = struct
  type external_package = Data_intf.Is_ocaml_yet.external_package
  type package = Data_intf.Is_ocaml_yet.package
  type category = Data_intf.Is_ocaml_yet.category
  type t = Data_intf.Is_ocaml_yet.t
end

module Tutorial = struct
  type section = Data_intf.Tutorial.section
  type toc = Data_intf.Tutorial.toc
  type contribute_link = Data_intf.Tutorial.contribute_link
  type banner = [%import: Data_intf.Tutorial.banner] [@@deriving of_yaml]
  type external_tutorial = Data_intf.Tutorial.external_tutorial

  type recommended_next_tutorials =
    Data_intf.Tutorial.recommended_next_tutorials

  type prerequisite_tutorials = Data_intf.Tutorial.prerequisite_tutorials
  type search_document_section = Data_intf.Tutorial.search_document_section
  type search_document = Data_intf.Tutorial.search_document
  type t = Data_intf.Tutorial.t
end

module Tool_page = struct
  type toc = [%import: Data_intf.Tool_page.toc] [@@deriving of_yaml]
  type contribute_link = Data_intf.Tool_page.contribute_link
  type t = Data_intf.Tool_page.t
end

module Planet = struct
  (* Entry type - BlogPost or Video. We define it directly with type equality
     since ppx_import has trouble with types referencing other modules. *)
  type entry = Data_intf.Planet.entry =
    | BlogPost of Blog.post
    | Video of Video.t
end

(* The aggregated data structure containing all types.

   Keep this structurally identical (same fields, same order) to
   Data_intf.All_data.t: the packer Marshals a value of this type into data.bin,
   and the runtime (Data.all_data) deserialises it as Data_intf.All_data.t with
   no dependency on this build-time library. If you add/reorder a field here,
   mirror it in src/ocamlorg_data/data_intf.ml. *)
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
