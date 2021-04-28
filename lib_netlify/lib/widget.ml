module rec Boolean : sig
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

  include S.Widget with type t := t
end = struct
  let widget_name = "boolean"

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

  include S.Widget with type t := t
end = struct
  let widget_name = "code"

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

  include S.Widget with type t := t
end = struct
  let widget_name = "color"

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

  include S.Widget with type t := t
end = struct
  let widget_name = "datetime"

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

  include S.Widget with type t := t
end = struct
  let widget_name = "file"

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

  include S.Widget with type t := t
end = struct
  let widget_name = "hidden"

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

  include S.Widget with type t := t
end = struct
  let widget_name = "image"

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

  include S.Widget with type t := t
end = struct
  let widget_name = "list"

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
  type typ = Point | LineString | Polygon

  val typ_to_yaml : typ -> Yaml.value

  val typ_of_yaml : Yaml.value -> typ Yaml.res

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

  include S.Widget with type t := t
end = struct
  type typ = Point | LineString | Polygon

  let typ_to_yaml = function
    | Point -> `String "point"
    | LineString -> `String "LineString"
    | Polygon -> `String "polygon"

  let typ_of_yaml = function
    | `String "point" -> Ok Point
    | `String "LineString" -> Ok LineString
    | `String "polygon" -> Ok Polygon
    | _ -> Error (`Msg "Parsing Map type failed")

  let widget_name = "map"

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

  include S.Widget with type t := t
end = struct
  let widget_name = "markdown"

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
  type typ = Float | Int

  val typ_to_yaml : typ -> Yaml.value

  val typ_of_yaml : Yaml.value -> typ Yaml.res

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

  include S.Widget with type t := t
end = struct
  type typ = Float | Int

  let typ_of_yaml = function
    | `String "float" -> Ok Float
    | `String "int" -> Ok Int
    | _ -> Error (`Msg "Error parsing type for numbers")

  let typ_to_yaml = function Float -> `String "float" | Int -> `String "int"

  let widget_name = "number"

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

  include S.Widget with type t := t
end = struct
  let widget_name = "object"

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

  include S.Widget with type t := t
end = struct
  let widget_name = "relation"

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
  type opt = Strings of string list | Obj of (string * string) list

  val opt_to_yaml : opt -> Yaml.value

  val opt_of_yaml : Yaml.value -> opt Yaml.res

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

  include S.Widget with type t := t
end = struct
  type opt = Strings of string list | Obj of (string * string) list

  let opt_to_yaml = function
    | Strings strings -> `A (List.map (fun s -> `String s) strings)
    | Obj pairs -> `A (List.map (fun (k, v) -> `O [ (k, `String v) ]) pairs)

  let opt_of_yaml : Yaml.value -> opt Yaml.res = function
    | `A [] -> Ok (Strings [])
    | `A xs -> (
        let rec strings acc = function
          | [] -> List.rev acc
          | `String s :: rest -> strings (s :: acc) rest
          | _ :: _ -> failwith "Needed only strings"
        in
        let rec objs acc = function
          | [] -> List.rev acc
          | `O [ (k, `String v) ] :: rest -> objs ((k, v) :: acc) rest
          | _ :: _ -> failwith "Needed only key value pairs"
        in
        try Ok (Strings (strings [] xs))
        with Failure _msg -> (
          try Ok (Obj (objs [] xs)) with Failure msg -> Error (`Msg msg) ) )
    | _ -> Error (`Msg "")

  let widget_name = "select"

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

  include S.Widget with type t := t
end = struct
  let widget_name = "string"

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

  include S.Widget with type t := t
end = struct
  let widget_name = "text"

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
end = struct
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

  let to_yaml = function
    | `Boolean b -> Boolean.to_yaml b
    | `Code c -> Code.to_yaml c
    | `Color c -> Color.to_yaml c
    | `DateTime c -> DateTime.to_yaml c
    | `File c -> File.to_yaml c
    | `Hidden c -> Hidden.to_yaml c
    | `Image c -> Image.to_yaml c
    | `List c -> Lst.to_yaml c
    | `Map c -> Map.to_yaml c
    | `Markdown c -> Markdown.to_yaml c
    | `Number c -> Number.to_yaml c
    | `Object c -> Object.to_yaml c
    | `Relation c -> Relation.to_yaml c
    | `Select c -> Select.to_yaml c
    | `String c -> String.to_yaml c
    | `Text c -> Text.to_yaml c

  let of_yaml t =
    let open Rresult in
    match t with
    | `O assoc as widget -> (
        match List.assoc_opt "widget" assoc with
        | Some (`String s) when s = Boolean.widget_name ->
            Boolean.of_yaml widget >>| fun t -> `Boolean t
        | Some (`String s) when s = Code.widget_name ->
            Code.of_yaml widget >>| fun t -> `Code t
        | Some (`String s) when s = Color.widget_name ->
            Color.of_yaml widget >>| fun t -> `Color t
        | Some (`String s) when s = DateTime.widget_name ->
            DateTime.of_yaml widget >>| fun t -> `DateTime t
        | Some (`String s) when s = File.widget_name ->
            File.of_yaml widget >>| fun t -> `File t
        | Some (`String s) when s = Hidden.widget_name ->
            Hidden.of_yaml widget >>| fun t -> `Hidden t
        | Some (`String s) when s = Image.widget_name ->
            Image.of_yaml widget >>| fun t -> `Image t
        | Some (`String s) when s = Lst.widget_name ->
            Lst.of_yaml widget >>| fun t -> `List t
        | Some (`String s) when s = Map.widget_name ->
            Map.of_yaml widget >>| fun t -> `Map t
        | Some (`String s) when s = Markdown.widget_name ->
            Markdown.of_yaml widget >>| fun t -> `Markdown t
        | Some (`String s) when s = Number.widget_name ->
            Number.of_yaml widget >>| fun t -> `Number t
        | Some (`String s) when s = Object.widget_name ->
            Object.of_yaml widget >>| fun t -> `Object t
        | Some (`String s) when s = Relation.widget_name ->
            Relation.of_yaml widget >>| fun t -> `Relation t
        | Some (`String s) when s = Select.widget_name ->
            Select.of_yaml widget >>| fun t -> `Select t
        | Some (`String s) when s = String.widget_name ->
            String.of_yaml widget >>| fun t -> `String t
        | Some (`String s) when s = Text.widget_name ->
            Text.of_yaml widget >>| fun t -> `Text t
        | _ -> Error (`Msg "Failed to parse widget") )
    | yaml -> Error (`Msg (Fmt.str "Failed to parse widget: %a" Yaml.pp yaml))
end

(* let rec widget_of_yaml key = function
  | `Float _ -> `Number (Number.make ~label:key ~name:key ())
  | `String _ -> `String (String.make ~label:key ~name:key ())
  | `Bool _ -> `Boolean (Boolean.make ~label:key ~name:key ())
  | `A lst ->
      `List
        (Lst.make ~label:key ~name:key ~fields:(List.map widget_of_map lst) ())
  | `O obj -> `Object (Object.make ~label:key ~name:key ~fields)

and widget_of_map = functo *)
