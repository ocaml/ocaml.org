module rec Boolean : sig
  val widget_name : string

  type t = {
    label : string;
    name : string;
    widget : string; [@default widget_name]
    required : bool option;
    hint : string option;
    pattern : (string * string) option;
    default : bool option;
  }
  [@@deriving make, yaml]
end

and Code : sig
  val widget_name : string

  type t = {
    label : string;
    name : string;
    widget : string; [@default widget_name]
    required : bool option;
    hint : string option;
    pattern : (string * string) option;
    default_language : string option;
    allow_language_selection : bool option;
    keys : Yaml.value option;  (** Hmmm... *)
    output_code_only : bool option;
  }
  [@@deriving make, yaml]
end

and Color : sig
  val widget_name : string

  type t = {
    label : string;
    name : string;
    widget : string; [@default widget_name]
    required : bool option;
    hint : string option;
    pattern : (string * string) option;
    default : string option;
    allow_input : bool option; [@key "allowInput"]
    enable_alpha : bool option; [@key "enableAlpha"]
  }
  [@@deriving make, yaml]
end

and DateTime : sig
  val widget_name : string

  type t = {
    label : string;
    name : string;
    widget : string; [@default widget_name]
    required : bool option;
    hint : string option;
    pattern : (string * string) option;
    default : string option;
    format : string option;
    date_format : bool option;
    (* Should suppport moment *)
    time_format : bool option;
    picker_utc : bool option;
  }
  [@@deriving make, yaml]
end

and File : sig
  val widget_name : string

  type t = {
    label : string;
    name : string;
    widget : string; [@default widget_name]
    required : bool option;
    hint : string option;
    pattern : (string * string) option;
    default : string option;
    media_library : string option;
    allow_multiple : bool option;
    config : Yaml.value option;
  }
  [@@deriving make, yaml]
end

and Hidden : sig
  val widget_name : string

  type t = {
    label : string;
    name : string;
    widget : string; [@default widget_name]
    required : bool option;
    hint : string option;
    pattern : (string * string) option;
    default : string option; (* Hmmm... *)
  }
  [@@deriving make, yaml]
end

and Image : sig
  val widget_name : string

  type t = {
    label : string;
    name : string;
    widget : string; [@default widget_name]
    required : bool option;
    hint : string option;
    pattern : (string * string) option;
    default : string option;
    media_library : Yaml.value option;
    allow_multiple : bool option;
    config : Yaml.value option;
  }
  [@@deriving make, yaml]
end

and Lst : sig
  val widget_name : string

  type t = {
    label : string;
    name : string;
    widget : string; [@default widget_name]
    required : bool option;
    hint : string option;
    pattern : (string * string) option;
    default : Yaml.value option;
    allow_add : bool option;
    collapsed : bool option;
    summary : string option;
    minimize_collapsed : bool option;
    label_singular : string option;
    field : Widget.t option;  (** TODO REC MODULES :( *)
    fields : Widget.t list option;
    max : int option;
    min : int option;
    add_to_top : bool option;
  }
  [@@deriving make, yaml]
end

and Map : sig
  val widget_name : string

  type typ = Point | LineString | Polygon

  val typ_of_yaml : Yaml.value -> typ Yaml.res

  val typ_to_yaml : typ -> Yaml.value

  type t = {
    label : string;
    name : string;
    widget : string; [@default widget_name]
    required : bool option;
    hint : string option;
    pattern : (string * string) option;
    decimals : int option;
    default : string option;
    typ : typ option; [@key "type"]
  }
  [@@deriving make, yaml]
end

and Markdown : sig
  val widget_name : string

  type t = {
    label : string;
    name : string;
    widget : string; [@default widget_name]
    required : bool option;
    hint : string option;
    pattern : (string * string) option;
    default : string option;
    minimal : bool option;
    buttons : string list option;
        (** XXX(patricoferris), TODO: Variant-ise the possibilities *)
    editor_components : string list option;
    modes : string list option;
    sanitize_preview : bool option;
  }
  [@@deriving make, yaml]
end

and Number : sig
  val widget_name : string

  type typ = Float | Int

  val typ_of_yaml : Yaml.value -> typ Yaml.res

  val typ_to_yaml : typ -> Yaml.value

  type t = {
    label : string;
    name : string;
    widget : string; [@default widget_name]
    required : bool option;
    hint : string option;
    pattern : (string * string) option;
    default : float option;
    value_type : typ option;
    min : float option;
    max : float option;
    step : float option;
  }
  [@@deriving make, yaml]
end

and Object : sig
  val widget_name : string

  type t = {
    label : string;
    name : string;
    widget : string; [@default widget_name]
    required : bool option;
    hint : string option;
    pattern : (string * string) option;
    default : Yaml.value option;
    (* hmmm... *)
    collapsed : bool option;
    summary : string option;
    fields : Widget.t list;
  }
  [@@deriving make, yaml]
end

and Relation : sig
  val widget_name : string

  type t = {
    label : string;
    name : string;
    widget : string; [@default widget_name]
    required : bool option;
    hint : string option;
    pattern : (string * string) option;
    collection : string;
    value_field : string;
    search_fields : string list;
    file : string option;
    display_fields : string list option;
    default : string option;
    multiple : bool option;
    min : int option;
    max : int option;
    options_length : int option;
  }
  [@@deriving make, yaml]
end

and Select : sig
  val widget_name : string

  type opt = Strings of string list | Obj of (string * string) list

  val opt_of_yaml : Yaml.value -> opt Yaml.res

  val opt_to_yaml : opt -> Yaml.value

  type t = {
    label : string;
    name : string;
    widget : string; [@default widget_name]
    required : bool option;
    hint : string option;
    pattern : (string * string) option;
    options : opt;
    multiple : bool option;
    min : int option;
    max : int option;
  }
  [@@deriving make, yaml]
end

and String : sig
  val widget_name : string

  type t = {
    label : string;
    name : string;
    widget : string; [@default widget_name]
    required : bool option;
    hint : string option;
    pattern : (string * string) option;
    default : string option;
  }
  [@@deriving make, yaml]
end

and Text : sig
  val widget_name : string

  type t = {
    label : string;
    name : string;
    widget : string; [@default widget_name]
    required : bool option;
    hint : string option;
    pattern : (string * string) option;
    default : string option;
  }
  [@@deriving make, yaml]
end

and Widget : sig
  type t =
    [ `Boolean of Boolean.t
    | `Code of Code.t
    | `Color of Color.t
    | `DateTime of DateTime.t
    | `File of File.t
    | `Hidden of Hidden.t
    | `Image of Image.t
    | `List of Lst.t
    | `Map of Map.t
    | `Markdown of Markdown.t
    | `Number of Number.t
    | `Object of Object.t
    | `Relation of Relation.t
    | `Select of Select.t
    | `String of String.t
    | `Text of Text.t ]
  [@@deriving yaml]
end
