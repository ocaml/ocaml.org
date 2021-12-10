module Meta : sig
  module Proficiency : sig
    type t =
      [ `Advanced
      | `Beginner
      | `Intermediate
      ]

    val to_string : t -> string

    val of_string : string -> (t, [> `Msg of string ]) result
  end

  module Archetype : sig
    type t =
      [ `Application_developer
      | `Beginner
      | `Distribution_manager
      | `End_user
      | `Library_author
      | `Teacher
      ]

    val to_string : t -> string

    val of_string : string -> (t, [> `Msg of string ]) result
  end
end

module Academic_institution : sig
  type location =
    { lat : float
    ; long : float
    }

  type course =
    { name : string
    ; acronym : string option
    ; online_resource : string option
    }

  type t =
    { name : string
    ; slug : string
    ; description : string
    ; url : string
    ; logo : string option
    ; continent : string
    ; courses : course list
    ; location : location option
    ; body_md : string
    ; body_html : string
    }

  val all_en : t list

  val all_fr : t list

  val all : ?lang:[> `English | `French ] -> unit -> t list

  val get_by_slug : ?lang:[> `English | `French ] -> string -> t option
end

module Book : sig
  type link =
    { description : string
    ; uri : string
    }

  type t =
    { title : string
    ; slug : string
    ; description : string
    ; authors : string list
    ; language : string
    ; published : string option
    ; cover : string option
    ; isbn : string option
    ; links : link list
    ; rating : int option
    ; featured : bool
    ; body_md : string
    ; body_html : string
    }

  val all : t list

  val get_by_slug : string -> t option
end

module Job : sig
  type t =
    { id : int
    ; title : string
    ; link : string
    ; description_html : string
    ; location : string
    ; country : string
    ; company : string
    ; company_logo : string
    ; fullfilled : bool
    }

  val all : t list

  val all_not_fullfilled : t list

  val get_by_id : int -> t option
end

module Meetup : sig
  type location =
    { lat : float
    ; long : float
    }

  type t =
    { title : string
    ; slug : string
    ; url : string
    ; textual_location : string
    ; location : location
    }

  val all : t list

  val get_by_slug : string -> t option
end

module Industrial_user : sig
  type t =
    { name : string
    ; slug : string
    ; description : string
    ; logo : string option
    ; url : string
    ; locations : string list
    ; consortium : bool
    ; featured : bool
    ; body_md : string
    ; body_html : string
    }

  val all_en : t list

  val all_fr : t list

  val all : ?lang:[> `English | `French ] -> unit -> t list

  val get_by_slug : ?lang:[> `English | `French ] -> string -> t option
end

module Paper : sig
  type link =
    { description : string
    ; uri : string
    }

  type t =
    { title : string
    ; slug : string
    ; publication : string
    ; authors : string list
    ; abstract : string
    ; tags : string list
    ; year : int
    ; links : link list
    ; featured : bool
    }

  val all : t list

  val get_by_slug : string -> t option
end

module Problem : sig
  type difficulty =
    [ `Beginner
    | `Intermediate
    | `Advanced
    ]

  type t =
    { title : string
    ; number : string
    ; difficulty : difficulty
    ; tags : string list
    ; statement : string
    ; solution : string
    }

  val all : t list

  val filter_by_tag : tag:string -> t list -> t list

  val filter_no_tag : t list -> t list
end

module Success_story : sig
  type t =
    { title : string
    ; slug : string
    ; logo : string
    ; background : string
    ; theme : string
    ; synopsis : string
    ; url : string
    ; body_md : string
    ; body_html : string
    }

  val all_en : t list

  val all_fr : t list

  val all : ?lang:[> `English | `French ] -> unit -> t list

  val get_by_slug : ?lang:[> `English | `French ] -> string -> t option
end

module Tool : sig
  type lifecycle =
    [ `Incubate
    | `Active
    | `Sustain
    | `Deprecate
    ]

  type t =
    { name : string
    ; slug : string
    ; source : string
    ; license : string
    ; synopsis : string
    ; description : string
    ; lifecycle : lifecycle
    }

  val all : t list

  val get_by_slug : string -> t option
end

module Tutorial : sig
  type t =
    { title : string
    ; slug : string
    ; description : string
    ; date : string
    ; tags : string list
    ; users : Meta.Proficiency.t list
    ; body_md : string
    ; toc_html : string
    ; body_html : string
    }

  val all : t list

  val get_by_slug : string -> t option
end

module Video : sig
  type kind =
    [ `Conference
    | `Mooc
    | `Lecture
    ]

  val kind_of_string : string -> (kind, [> `Msg of string ]) result

  val kind_to_string : kind -> string

  type t =
    { title : string
    ; slug : string
    ; description : string
    ; people : string list
    ; kind : kind
    ; tags : string list
    ; paper : string option
    ; link : string
    ; embed : string option
    ; year : int
    }

  val all : t list

  val get_by_slug : string -> t option
end

module Watch : sig
  type t =
    { name : string
    ; embed_path : string
    ; thumbnail_path : string
    ; description : string option
    ; published_at : string
    ; updated_at : string
    ; language : string
    ; category : string
    }

  val all : t list
end

module News : sig
  type t =
    { title : string
    ; slug : string
    ; description : string option
    ; url : string
    ; date : string
    ; preview_image : string option
    ; body_html : string
    }

  val all : t list

  val get_by_slug : string -> t option
end

module Opam_user : sig
  type t =
    { name : string
    ; email : string option
    ; github_username : string option
    ; avatar : string option
    }

  val all : t list

  val make
    :  name:string
    -> ?email:string
    -> ?github_username:string
    -> ?avatar:string
    -> unit
    -> t

  val find_by_name : string -> t option
end

module Workshop : sig
  type role =
    [ `Co_chair
    | `Chair
    ]

  val role_to_string : role -> string

  val role_of_string : string -> (role, [> `Msg of string ]) result

  type important_date =
    { date : string
    ; info : string
    }

  type committee_member =
    { name : string
    ; role : role option
    ; affiliation : string option
    ; picture : string option
    }

  type presentation =
    { title : string
    ; authors : string list
    ; link : string option
    ; video : string option
    ; slides : string option
    ; poster : bool option
    ; additional_links : string list option
    }

  type t =
    { title : string
    ; slug : string
    ; location : string
    ; date : string
    ; important_dates : important_date list
    ; presentations : presentation list
    ; program_committee : committee_member list
    ; organising_committee : committee_member list
    ; toc_html : string
    ; body_md : string
    ; body_html : string
    }

  val all : t list

  val get_by_slug : string -> t option
end

module Workflow : sig
  type t =
    { title : string
    ; body_md : string
    ; body_html : string
    }

  val all : t list
end

module Release : sig
  type kind = [ `Compiler ]

  type t =
    { kind : kind
    ; version : string
    ; date : string
    ; intro_md : string
    ; intro_html : string
    ; highlights_md : string
    ; highlights_html : string
    ; body_md : string
    ; body_html : string
    }

  val all : t list

  val get_by_version : string -> t option
end
