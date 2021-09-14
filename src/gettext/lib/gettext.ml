type category =
  | LC_CTYPE
  | LC_NUMERIC
  | LC_TIME
  | LC_COLLATE
  | LC_MONETARY
  | LC_MESSAGES
  | LC_ALL

let string_of_category = function
  | LC_CTYPE ->
    "LC_CTYPE"
  | LC_NUMERIC ->
    "LC_NUMERIC"
  | LC_TIME ->
    "LC_TIME"
  | LC_COLLATE ->
    "LC_COLLATE"
  | LC_MONETARY ->
    "LC_MONETARY"
  | LC_MESSAGES ->
    "LC_MESSAGES"
  | LC_ALL ->
    "LC_ALL"

let category_of_string = function
  | "LC_CTYPE" ->
    LC_CTYPE
  | "LC_NUMERIC" ->
    LC_NUMERIC
  | "LC_TIME" ->
    LC_TIME
  | "LC_COLLATE" ->
    LC_COLLATE
  | "LC_MONETARY" ->
    LC_MONETARY
  | "LC_MESSAGES" ->
    LC_MESSAGES
  | "LC_ALL" ->
    LC_ALL
  | _ ->
    raise (Invalid_argument "category_of_string")

let compare_cateogry c1 c2 =
  let val_category x =
    match x with
    | LC_CTYPE ->
      0
    | LC_NUMERIC ->
      1
    | LC_TIME ->
      2
    | LC_COLLATE ->
      3
    | LC_MONETARY ->
      4
    | LC_MESSAGES ->
      5
    | LC_ALL ->
      6
  in
  compare (val_category c1) (val_category c2)

exception Unknown_msgid of (string * category * string * string)

module type Config = sig
  val default_locale : string

  val default_domain : string

  val allowed_locales : string list option

  val po : (Gettext_locale.t * category * string * Gettext_po.t) list
  (* (locale, category, domain, translations) *)
end

module type Impl = sig
  val get_locale : unit -> string

  val put_locale : string -> unit

  val with_locale : string -> (unit -> 'a) -> 'a

  val gettext : string -> string

  val fgettext : ('a, Format.formatter, unit, unit, unit, string) format6 -> 'a

  val dgettext : string -> string -> string

  val fdgettext
    :  string
    -> ('a, Format.formatter, unit, unit, unit, string) format6
    -> 'a

  val dcgettext : string -> category -> string -> string

  val fdcgettext
    :  string
    -> category
    -> ('a, Format.formatter, unit, unit, unit, string) format6
    -> 'a

  val ngettext : string -> string -> int -> string

  val fngettext
    :  ('a, Format.formatter, unit, unit, unit, string) format6
    -> ('a, Format.formatter, unit, unit, unit, string) format6
    -> int
    -> 'a

  val dngettext : string -> string -> string -> int -> string

  val fdngettext
    :  string
    -> ('a, Format.formatter, unit, unit, unit, string) format6
    -> ('a, Format.formatter, unit, unit, unit, string) format6
    -> int
    -> 'a

  val dcngettext : string -> category -> string -> string -> int -> string

  val fdcngettext
    :  string
    -> category
    -> ('a, Format.formatter, unit, unit, unit, string) format6
    -> ('a, Format.formatter, unit, unit, unit, string) format6
    -> int
    -> 'a
end

module Translation_map = struct
  module Key = struct
    type t = Gettext_locale.t * category * string
    (* (locale, category, domain) *)

    let compare (locale_1, category_1, domain_1) (locale_2, category_2, domain_2)
      =
      String.compare domain_1 domain_2
      + (2 * compare_cateogry category_1 category_2)
      + (3 * Gettext_locale.compare locale_1 locale_2)
  end

  include Map.Make (Key)
end

module Make (Config : Config) : Impl = struct
  type t =
    { mutable locale : Gettext_locale.t
    ; translations : Gettext_po.translations Translation_map.t
          (* Map a (locale, category, domain) tuple to a translation map. *)
    }

  module String_map = Map.Make (String)

  let merge key translations map =
    let content =
      Gettext_po.{ no_domain = translations; domain = String_map.empty }
    in
    match Translation_map.find_opt key map with
    | None ->
      Translation_map.add key content.Gettext_po.no_domain map
    | Some existing_map ->
      let existing_po =
        Gettext_po.{ no_domain = existing_map; domain = String_map.empty }
      in
      let merged = Gettext_po.merge_po existing_po content in
      Translation_map.add key merged.Gettext_po.no_domain map

  let translations_of_po po =
    List.fold_left
      (fun map (locale, category, domain, content) ->
        let key = locale, category, domain in
        let map = merge key content.Gettext_po.no_domain map in
        String_map.fold
          (fun domain translations acc ->
            let key = locale, category, domain in
            merge key translations acc)
          content.Gettext_po.domain
          map)
      Translation_map.empty
      po

  let t =
    { locale = Gettext_locale.of_string Config.default_locale
    ; translations = translations_of_po Config.po
    }

  let get_locale () = Gettext_locale.to_string t.locale

  let put_locale s = t.locale <- Gettext_locale.of_string s

  let with_locale s f =
    let initial_locale = get_locale () in
    put_locale s;
    Fun.protect ~finally:(fun () -> put_locale initial_locale) f

  let dcgettext domain category msgid =
    let translated =
      match
        Translation_map.find_opt (t.locale, category, domain) t.translations
      with
      | Some translations ->
        (match String_map.find_opt msgid translations with
        | Some commented_translation ->
          (match commented_translation.Gettext_po.comment_translation with
          | Gettext_po.Singular (_, xs) ->
            String.concat "" xs
          | Gettext_po.Plural (_, _, xs :: _) ->
            String.concat "" xs
          | Gettext_po.Plural _ ->
            raise (Failure "dcgettext"))
        | None ->
          raise
            (Unknown_msgid
               (Gettext_locale.to_string t.locale, category, domain, msgid)))
      | None ->
        raise
          (Unknown_msgid
             (Gettext_locale.to_string t.locale, category, domain, msgid))
    in
    match translated with "" -> msgid | _ -> translated

  let fdcgettext domain category fmt =
    let fmt =
      Scanf.format_from_string
        (dcgettext domain category (string_of_format fmt))
        fmt
    in
    Format.asprintf fmt

  let dgettext domain msgid = dcgettext domain LC_MESSAGES msgid

  let fdgettext domain fmt = fdcgettext domain LC_MESSAGES fmt

  let gettext msgid = dcgettext "messages" LC_MESSAGES msgid

  let fgettext fmt = fdcgettext "messages" LC_MESSAGES fmt

  let dcngettext domain category msgid msgid_plural n =
    let plural_form = Plural.plural (Gettext_locale.to_string t.locale) n in
    let translated =
      match
        Translation_map.find_opt (t.locale, category, domain) t.translations
      with
      | Some translations ->
        (match String_map.find_opt msgid translations with
        | Some commented_translation ->
          (match commented_translation.Gettext_po.comment_translation with
          | Gettext_po.Singular (_, xs) ->
            String.concat "" xs
          | Gettext_po.Plural (_, _, forms) ->
            String.concat "" (List.nth forms plural_form))
        | None ->
          raise
            (Unknown_msgid
               (Gettext_locale.to_string t.locale, category, domain, msgid)))
      | None ->
        raise
          (Unknown_msgid
             (Gettext_locale.to_string t.locale, category, domain, msgid))
    in
    match translated with
    | "" when plural_form > 0 ->
      msgid_plural
    | "" ->
      msgid
    | _ ->
      translated

  let fdcngettext domain category fmt fmt_plural n =
    let fmt =
      Scanf.format_from_string
        (dcngettext
           domain
           category
           (string_of_format fmt)
           (string_of_format fmt_plural)
           n)
        fmt
    in
    Format.asprintf fmt

  let dngettext domain msgid msgid_plural n =
    dcngettext domain LC_MESSAGES msgid msgid_plural n

  let fdngettext domain msgid msgid_plural n =
    fdcngettext domain LC_MESSAGES msgid msgid_plural n

  let ngettext msgid msgid_plural n =
    dcngettext "messages" LC_MESSAGES msgid msgid_plural n

  let fngettext msgid msgid_plural n =
    fdcngettext "messages" LC_MESSAGES msgid msgid_plural n
end

let from_crunch
    ?(default_locale = "en")
    ?(default_domain = "messages")
    ?allowed_locales
    file_list
    read
  =
  let po =
    List.filter_map
      (fun f ->
        match String.split_on_char '/' f with
        | [ locale; category; filename ] ->
          (try
             let locale = Gettext_locale.of_string locale in
             let category = category_of_string category in
             let domain = Filename.remove_extension filename in
             if Filename.extension filename = ".po" then
               let content = read f in
               Some (locale, category, domain, Gettext_po.read_po content)
             else
               None
           with
          | _ ->
            None)
        | _ ->
          None)
      file_list
  in
  let m =
    (module Make (struct
      let default_locale = default_locale

      let default_domain = default_domain

      let allowed_locales = allowed_locales

      let po = po
    end) : Impl)
  in
  m

let from_directory ?default_locale ?default_domain ?allowed_locales dir =
  let file_list =
    let rec loop result = function
      | f :: fs when Sys.is_directory f ->
        Sys.readdir f
        |> Array.to_list
        |> List.map (Filename.concat f)
        |> List.append fs
        |> loop result
      | f :: fs ->
        loop (f :: result) fs
      | [] ->
        result
    in
    loop [] [ dir ]
  in
  let read_file filename =
    let lines = ref [] in
    let chan = open_in filename in
    try
      while true do
        lines := input_line chan :: !lines
      done;
      assert false
    with
    | End_of_file ->
      close_in chan;
      String.concat "\n" (List.rev !lines)
  in
  from_crunch
    ?default_locale
    ?default_domain
    ?allowed_locales
    file_list
    read_file
