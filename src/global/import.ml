module String = struct
  include Stdlib.String
  module Map = Map.Make (Stdlib.String)

let index = "/"
let opr_sys = Stdlib.Sys.os_type
let install = "/install"
let packages = "/packages"
let packages_search = "/packages/search"
let packages_autocomplete_fragment = "/packages/autocomplete"

module Package : sig
  val overview : ?hash:string -> ?version:string -> string -> string
  val versions : ?hash:string -> ?version:string -> string -> string

  val documentation :
    ?hash:string -> ?version:string -> ?page:string -> string -> string

  val file :
    ?hash:string -> ?version:string -> filepath:string -> string -> string

  val search_index : ?version:string -> digest:string -> string -> string
end = struct
  let with_hash = Option.fold ~none:"/p" ~some:(( ^ ) "/u/")
  let with_version = Option.fold ~none:"/latest" ~some:(( ^ ) "/")

  let base ?hash ?version page name =
    with_hash hash ^ "/" ^ name ^ with_version version ^ page

  let overview ?hash ?version = base ?hash ?version ""
  let versions ?hash ?version = base ?hash ?version "/versions"

  let documentation ?hash ?version ?(page = "index.html") =
    base ?hash ?version ("/doc/" ^ page)

  let file ?hash ?version ~filepath = base ?hash ?version ("/" ^ filepath)
  let search_index ?version ~digest = base ?version ("/search-index/" ^ digest)
end

let sitemap = "/sitemap.xml"
let community = "/community"
let resources = "/resources"
let events = "/events"
let success_story v = "/success-stories/" ^ v
let industrial_users = "/industrial-users"
let academic_users = "/academic-users"
let about = "/about"

let minor v =
  match String.split_on_char '.' v with
  | x :: y :: _ -> x ^ "." ^ y
  | _ -> invalid_arg (v ^ ": invalid OCaml version")

let v2 = "https://v2.ocaml.org"
let manual_with_version v = "/manual/" ^ minor v ^ "/index.html"
let manual = "/manual"
let api_with_version v = "/manual/" ^ minor v ^ "/api/index.html"
let api = "/api"
let books = "/books"
let changelog = "/changelog"
let changelog_entry id = "/changelog/" ^ id
let releases = "/releases"
let release v = "/releases/" ^ v
let workshops = "/workshops"
let workshop v = "/workshops/" ^ v
let ocaml_planet = "/ocaml-planet"
let local_blog source = "/blog/" ^ source
let blog_post source v = "/blog/" ^ source ^ "/" ^ v
let news = "/news"
let news_post v = "/news/" ^ v
let jobs = "/jobs"
let governance = "/governance"
let governance_team id = "/governance/" ^ id
let carbon_footprint = "/policies/carbon-footprint"
let privacy_policy = "/policies/privacy-policy"
let governance_policy = "/policies/governance"
let code_of_conduct = "/policies/code-of-conduct"
let playground = "/play"
let papers = "/papers"
let learn = "/docs"
let learn_get_started = "/docs/get-started"
let learn_language = "/docs/language"
let learn_guides = "/docs/guides"
let learn_platform = "/docs/tools"
let tools = "/tools"
let platform = "/platform"
let tool_page name = "/tools/" ^ name
let tutorial name = "/docs/" ^ name
let tutorial_search = "/docs/search"
let getting_started = "/docs/get-started"
let installing_ocaml = "/docs/installing-ocaml"
let exercises = "/exercises"
let outreachy = "/outreachy"
let logos = "/logo"
let cookbook = "/cookbook"
let cookbook_task task_slug = cookbook ^ "/" ^ task_slug
let cookbook_recipe ~task_slug slug = "/cookbook/" ^ task_slug ^ "/" ^ slug

let github_opam_file package_name package_version =
  Printf.sprintf
    "https://github.com/ocaml/opam-repository/blob/master/packages/%s/%s.%s/opam"
    package_name package_name package_version

let is_ocaml_yet id = Printf.sprintf "/docs/is-ocaml-%s-yet" id
  let contains_s s1 s2 =
    try
      let len = String.length s2 in
      for i = 0 to String.length s1 - len do
        if String.sub s1 i len = s2 then raise Exit
      done;
      false
    with Exit -> true

  let is_sub_ignore_case pattern text =
    contains_s (lowercase_ascii text) (lowercase_ascii pattern)

  (* ripped off stringext, itself ripping it off from one of dbuenzli's libs *)
  let cut s ~on =
    let sep_max = length on - 1 in
    if sep_max < 0 then invalid_arg "Stringext.cut: empty separator"
    else
      let s_max = length s - 1 in
      if s_max < 0 then None
      else
        let k = ref 0 in
        let i = ref 0 in
        (* We run from the start of [s] to end with [i] trying to match the
           first character of [on] in [s]. If this matches, we verify that the
           whole [on] is matched using [k]. If it doesn't match we continue to
           look for [on] with [i]. If it matches we exit the loop and extract a
           substring from the start of [s] to the position before the [on] we
           found and another from the position after the [on] we found to end of
           string. If [i] is such that no separator can be found we exit the
           loop and return the no match case. *)
        try
          while !i + sep_max <= s_max do
            (* Check remaining [on] chars match, access to unsafe s (!i + !k) is
               guaranteed by loop invariant. *)
            if unsafe_get s !i <> unsafe_get on 0 then incr i
            else (
              k := 1;
              while
                !k <= sep_max && unsafe_get s (!i + !k) = unsafe_get on !k
              do
                incr k
              done;
              if !k <= sep_max then (* no match *) incr i else raise Exit)
          done;
          None (* no match in the whole string. *)
        with Exit ->
          (* i is at the beginning of the separator *)
          let left_end = !i - 1 in
          let right_start = !i + sep_max + 1 in
          Some
            (sub s 0 (left_end + 1), sub s right_start (s_max - right_start + 1))
end

module List = struct
  include Stdlib.List

  let rec take n = function
    | _ when n = 0 -> []
    | [] -> []
    | hd :: tl -> hd :: take (n - 1) tl

  let rec drop i = function _ :: u when i > 0 -> drop (i - 1) u | u -> u
end

module Acc_biggest (Elt : sig
  type t

  val compare : t -> t -> int
end) : sig
  (** Accumulate the [n] bigger elements given to [acc]. *)

  type elt = Elt.t
  type t

  val make : int -> t
  val acc : elt -> t -> t
  val to_list : t -> elt list
end = struct
  type elt = Elt.t
  type t = int * elt list

  let make size = (size, [])

  (* Insert sort is enough. *)
  let rec insert_sort elt = function
    | [] -> [ elt ]
    | hd :: _ as t when Elt.compare hd elt >= 0 -> elt :: t
    | hd :: tl -> hd :: insert_sort elt tl

  let acc elt (rem, elts) =
    let elts = insert_sort elt elts in
    if rem = 0 then (0, List.tl elts) else (rem - 1, elts)

  let to_list (_, elts) = elts
end

module Result = struct
  include Stdlib.Result

  let const_error e _ = Error e
  let apply f = Result.fold ~ok:Result.map ~error:const_error f
  let get_ok ~error = fold ~ok:Fun.id ~error:(fun e -> raise (error e))
  let sequential_or f g x = fold (f x) ~ok ~error:(Fun.const (g x))
end
