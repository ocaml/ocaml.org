(* Single-pass HTML -> safe text + structured references for the MCP
   [ocaml_module_documentation] tool (issue #3775, Block B hardening).

   docs-ci returns rendered odoc HTML built from community-authored, hence
   attacker-influenceable, doc comments. Returning it verbatim to an LLM client
   is both a hazard and waste:

   - Exfiltration / indirect prompt injection: an auto-rendered [<img>] or a
   previewable link is the classic channel for leaking context to an attacker
   URL. odoc's [{%html:%}] escape hatch lets a doc author emit such markup. -
   Bloat: a single rendered module page measured ~222 KB, mostly markup, which
   wastes tokens (cost, latency, energy) and buries the actual signal.

   This module turns that HTML into: - [body]: lightweight-Markdown,
   active-markup-free text (no [<img>], no [<script>], no [href] — and no
   Markdown that could re-form a link/image); - [references]: a deduplicated
   list where cross-references carry the target package / version / path, so an
   agent can navigate across dependencies by feeding them straight back into the
   tool.

   Everything happens in ONE streaming fold over Markup.ml's HTML signal stream:
   no DOM is materialised and the tree is never re-traversed. This keeps memory
   and CPU bounded on large pages (the whole point on a shared server) and is
   the safest shape for a sanitiser — an allowlist applied while consuming the
   stream, never a regex over the raw string. *)

(* A link recovered from the page. Internal cross-references (same- or
   cross-package) become tool-callable coordinates; external links are kept as
   inert data and never as a fetchable element. *)
type reference =
  | Module of {
      text : string;
      package : string;
      version : string;
      path : string;
      fragment : string option;
    }
  | Source of {
      text : string;
      package : string;
      version : string;
      path : string;
    }
  | Anchor of { text : string; fragment : string }
  | External of { text : string; url : string }

type t = {
  body : string;
  references : reference list;
  truncated : bool; (* the body hit the byte cap *)
  references_truncated : bool; (* the reference list hit its cap *)
}

(* Defaults: body cap ~100 KB (a safety backstop — the strip already shrinks
   most pages well under it), input cap 2 MB (refuse to parse a pathological
   page), and a reference-count cap. All overridable for tests. *)
let default_max_bytes = 100_000
let default_max_input = 2_000_000
let default_max_refs = 300

(* --- small string helpers (no Str dependency) --- *)

let replace_all ~sub ~by s =
  let ls = String.length sub in
  if ls = 0 then s
  else
    let n = String.length s in
    let b = Buffer.create n in
    let i = ref 0 in
    while !i < n do
      if !i + ls <= n && String.sub s !i ls = sub then (
        Buffer.add_string b by;
        i := !i + ls)
      else (
        Buffer.add_char b s.[!i];
        incr i)
    done;
    Buffer.contents b

(* Strip invisible / control characters that carry *hidden* instructions (as
   opposed to the active-markup exfiltration the escaping/defang handles): C0
   controls (bar tab/newline), DEL, and the Unicode zero-width and bidi
   overrides an author could use to smuggle text past a human reviewer while the
   model still reads it. Operates on UTF-8 bytes, matching the specific
   sequences: U+200B–200F, U+202A–202E, U+2060, U+2066–2069 (E2 80/81 ..),
   U+FEFF (EF BB BF), U+061C (D8 9C). *)
let strip_invisible s =
  let n = String.length s in
  let b = Buffer.create n in
  let i = ref 0 in
  while !i < n do
    let c = s.[!i] in
    let code = Char.code c in
    if code = 0xE2 && !i + 2 < n then
      let c1 = Char.code s.[!i + 1] and c2 = Char.code s.[!i + 2] in
      if
        (c1 = 0x80 && ((c2 >= 0x8B && c2 <= 0x8F) || (c2 >= 0xAA && c2 <= 0xAE)))
        || (c1 = 0x81 && (c2 = 0xA0 || (c2 >= 0xA6 && c2 <= 0xA9)))
      then i := !i + 3
      else (
        Buffer.add_char b c;
        incr i)
    else if
      code = 0xEF
      && !i + 2 < n
      && Char.code s.[!i + 1] = 0xBB
      && Char.code s.[!i + 2] = 0xBF
    then i := !i + 3 (* U+FEFF ZWNBSP / BOM *)
    else if code = 0xD8 && !i + 1 < n && Char.code s.[!i + 1] = 0x9C then
      i := !i + 2 (* U+061C ALM *)
    else if code = 0x7F || (code < 0x20 && c <> '\t' && c <> '\n' && c <> '\r')
    then incr i (* C0 controls / DEL *)
    else (
      Buffer.add_char b c;
      incr i)
  done;
  Buffer.contents b

(* HTML-escape every piece of doc-derived text we emit. odoc docs legitimately
   contain HTML/XML examples (e.g. dream's own XSS docs mention "<script>"), and
   Markup.ml decodes the source entities back to raw "<"/">"; if we re-emitted
   those verbatim, a client rendering the body as Markdown-with-raw-HTML would
   treat "<script>"/"<style>"/event handlers as live markup. Escaping "&<>"
   guarantees no raw tag can form anywhere in the body — in prose or after a
   code-fence breakout — so the strip's safety does not depend on the consumer's
   renderer. ("&" first, so "<"→"&lt;" is not re-escaped.) *)
let escape s =
  s
  |> replace_all ~sub:"&" ~by:"&amp;"
  |> replace_all ~sub:"<" ~by:"&lt;"
  |> replace_all ~sub:">" ~by:"&gt;"

(* Neutralise the one Markdown construct escaping doesn't cover: the "](" join
   of an image/inline-link. We never emit links ourselves, but doc text may
   contain a literal "![alt](url)" that a Markdown renderer would revive into an
   auto-fetched image. Breaking "](" defuses both image and inline-link syntax.
   (Angle-bracket autolinks are already dead once "<" is escaped.) *)
let defang s = replace_all ~sub:"](" ~by:"] (" s

(* A free-text field not derived from HTML (e.g. a package [synopsis] /
   [description]): still attacker-authored, so give it the same treatment as
   body prose — strip invisibles, escape, defang — but keep newlines (no
   whitespace collapse). Exposed for the overview tool's prose fields. *)
let sanitize_field s = defang (escape (strip_invisible s))
let is_ws c = c = ' ' || c = '\t' || c = '\n' || c = '\r'

(* Collapse whitespace runs to a single space (used outside <pre>, where odoc's
   HTML carries copious layout whitespace that is pure noise to a model). *)
let collapse_ws s =
  let b = Buffer.create (String.length s) in
  let prev_ws = ref false in
  String.iter
    (fun c ->
      if is_ws c then (
        if not !prev_ws then Buffer.add_char b ' ';
        prev_ws := true)
      else (
        Buffer.add_char b c;
        prev_ws := false))
    s;
  Buffer.contents b

(* Doc text ready for the body: whitespace-collapsed (outside <pre>), escaped,
   and defanged. *)
let clean_text ~pre s =
  let s = strip_invisible s in
  let s = if pre then s else collapse_ws s in
  defang (escape s)

(* Cap consecutive newlines at 2 so paragraph breaks don't stack up. *)
let squeeze_blank_lines s =
  let b = Buffer.create (String.length s) in
  let nl = ref 0 in
  String.iter
    (fun c ->
      if c = '\n' then (
        incr nl;
        if !nl <= 2 then Buffer.add_char b c)
      else (
        nl := 0;
        Buffer.add_char b c))
    s;
  Buffer.contents b

(* --- reference resolution --- *)

(* Resolve a relative [href] path against the current page's directory segments,
   collapsing "." and "..". An href starting with "/" is site-absolute. Returns
   the resolved path as a segment list. *)
let resolve_relative ~base_dir href_path =
  let start =
    if String.starts_with ~prefix:"/" href_path then [] else base_dir
  in
  let stack = ref (List.rev start) in
  List.iter
    (fun s ->
      match s with
      | "" | "." -> ()
      | ".." -> ( match !stack with _ :: t -> stack := t | [] -> ())
      | s -> stack := s :: !stack)
    (String.split_on_char '/' href_path);
  List.rev !stack

(* Classify a resolved internal path. docs-ci lays doc pages out under
   [p/<pkg>/<ver>/doc/<rest>] and, for cross-universe disambiguation, under
   [u/<hash>/<pkg>/<ver>/doc/<rest>]; both encode the target package and the
   exact version resolved at build time. [doc/src/...] pages are rendered
   source, reported as [Source] but not served by the module tool. *)
let classify_internal ~text ~fragment segs =
  let build pkg ver rest =
    let path = String.concat "/" rest in
    match rest with
    | [] -> None
    | "src" :: _ -> Some (Source { text; package = pkg; version = ver; path })
    | _ -> Some (Module { text; package = pkg; version = ver; path; fragment })
  in
  match segs with
  | "p" :: pkg :: ver :: "doc" :: rest -> build pkg ver rest
  | "u" :: _hash :: pkg :: ver :: "doc" :: rest -> build pkg ver rest
  | _ -> None

let make_resolve ~package ~version ~path =
  (* Directory segments of /p/<package>/<version>/doc/<path>, minus the
     filename. *)
  let base_dir =
    let segs =
      [ "p"; package; version; "doc" ] @ String.split_on_char '/' path
    in
    match List.rev segs with _ :: t -> List.rev t | [] -> []
  in
  fun ~href ~text ->
    let href_path, fragment =
      match String.index_opt href '#' with
      | Some i ->
          ( String.sub href 0 i,
            Some (String.sub href (i + 1) (String.length href - i - 1)) )
      | None -> (href, None)
    in
    if
      String.starts_with ~prefix:"http://" href
      || String.starts_with ~prefix:"https://" href
      || String.starts_with ~prefix:"//" href
      || String.starts_with ~prefix:"mailto:" href
    then Some (External { text; url = href })
    else if href_path = "" then
      match fragment with
      | Some f -> Some (Anchor { text; fragment = f })
      | None -> None
    else
      classify_internal ~text ~fragment (resolve_relative ~base_dir href_path)

let ref_key = function
  | Module { package; version; path; fragment; _ } ->
      String.concat "|"
        [ "m"; package; version; path; Option.value ~default:"" fragment ]
  | Source { package; version; path; _ } ->
      String.concat "|" [ "s"; package; version; path ]
  | Anchor { fragment; _ } -> "a|" ^ fragment
  | External { url; _ } -> "e|" ^ url

let reference_to_json =
  let opt k = function Some v -> [ (k, `String v) ] | None -> [] in
  function
  | Module { text; package; version; path; fragment } ->
      `Assoc
        ([
           ("kind", `String "module");
           ("text", `String text);
           ("package", `String package);
           ("version", `String version);
           ("path", `String path);
         ]
        @ opt "fragment" fragment)
  | Source { text; package; version; path } ->
      `Assoc
        [
          ("kind", `String "source");
          ("text", `String text);
          ("package", `String package);
          ("version", `String version);
          ("path", `String path);
        ]
  | Anchor { text; fragment } ->
      `Assoc
        [
          ("kind", `String "anchor");
          ("text", `String text);
          ("fragment", `String fragment);
        ]
  | External { text; url } ->
      `Assoc
        [
          ("kind", `String "external");
          ("text", `String text);
          ("url", `String url);
        ]

(* --- the streaming fold --- *)

(* Elements whose entire subtree is dropped: active/fetching markup and form
   controls. Default-deny: only text and the few structural elements handled in
   [on_start] survive; anything not listed there emits nothing but its text. *)
let dropped =
  [
    "script";
    "style";
    "img";
    "svg";
    "iframe";
    "object";
    "embed";
    "link";
    "meta";
    "video";
    "audio";
    "source";
    "track";
    "picture";
    "base";
    "form";
    "input";
    "button";
    "textarea";
    "select";
    "option";
    "noscript";
    "canvas";
    "map";
    "area";
    "math";
    "template";
    "frame";
    "frameset";
    "applet";
    "param";
  ]

let heading_level = function
  | "h1" -> Some 1
  | "h2" -> Some 2
  | "h3" -> Some 3
  | "h4" -> Some 4
  | "h5" -> Some 5
  | "h6" -> Some 6
  | _ -> None

type st = {
  body : Buffer.t;
  mutable body_len : int;
  max_bytes : int;
  mutable truncated : bool;
  mutable drop_depth : int; (* >0 => inside a dropped subtree *)
  mutable stack : string list; (* allowed open elements, innermost first *)
  mutable pre_depth : int;
  mutable anchor : (string option * Buffer.t) option;
      (* href, link-text buffer *)
  mutable refs_rev : reference list;
  mutable refs_count : int;
  mutable refs_capped : bool;
  max_refs : int;
  seen : (string, unit) Hashtbl.t;
  resolve : href:string -> text:string -> reference option;
}

let emit st s =
  if s <> "" && not st.truncated then
    let len = String.length s in
    if st.body_len + len > st.max_bytes then (
      let room = st.max_bytes - st.body_len in
      if room > 0 then Buffer.add_string st.body (String.sub s 0 room);
      Buffer.add_string st.body
        "\n\n[\xe2\x80\xa6 documentation truncated \xe2\x80\xa6]";
      st.body_len <- st.max_bytes;
      st.truncated <- true)
    else (
      Buffer.add_string st.body s;
      st.body_len <- st.body_len + len)

let find_href attrs =
  List.find_map
    (fun ((_, n), v) ->
      if String.lowercase_ascii n = "href" then Some v else None)
    attrs

let finalize_anchor st =
  match st.anchor with
  | None -> ()
  | Some (href, tb) -> (
      st.anchor <- None;
      let text = String.trim (collapse_ws (Buffer.contents tb)) in
      let r =
        match href with Some href -> st.resolve ~href ~text | None -> None
      in
      (* Keep the link text in the prose so it still reads naturally — except
         for odoc's per-definition "Source" links, which are navigation chrome
         that would otherwise glue onto the prose ("Sourcetype request = ...").
         Still record them in [references]. *)
      (match r with
      | Some (Source _) -> ()
      | _ -> emit st (sanitize_field text));
      match r with
      | None -> ()
      | Some r ->
          let key = ref_key r in
          if not (Hashtbl.mem st.seen key) then
            if st.refs_count < st.max_refs then (
              Hashtbl.add st.seen key ();
              st.refs_rev <- r :: st.refs_rev;
              st.refs_count <- st.refs_count + 1)
            else st.refs_capped <- true (* new target dropped: surface it *))

let on_text st raw =
  if st.drop_depth > 0 then ()
  else
    match st.anchor with
    | Some (_, tb) -> Buffer.add_string tb raw
    | None -> emit st (clean_text ~pre:(st.pre_depth > 0) raw)

let on_start st name attrs =
  if st.drop_depth > 0 then st.drop_depth <- st.drop_depth + 1
  else if List.mem name dropped then st.drop_depth <- st.drop_depth + 1
  else (
    st.stack <- name :: st.stack;
    match name with
    | "a" when st.anchor = None ->
        st.anchor <- Some (find_href attrs, Buffer.create 32)
    | _ when st.anchor <> None -> () (* inside a link: capture text only *)
    | "pre" ->
        st.pre_depth <- st.pre_depth + 1;
        emit st "\n\n```\n"
    | _ when heading_level name <> None ->
        emit st
          ("\n\n" ^ String.make (Option.get (heading_level name)) '#' ^ " ")
    | "li" -> emit st "\n- "
    | "p" | "div" | "section" | "ul" | "ol" | "table" | "tr" -> emit st "\n\n"
    | "br" -> emit st "\n"
    | _ -> ())

let on_end st =
  if st.drop_depth > 0 then st.drop_depth <- st.drop_depth - 1
  else
    match st.stack with
    | name :: rest -> (
        st.stack <- rest;
        match name with
        | "a" -> finalize_anchor st
        | "pre" when st.anchor = None ->
            if st.pre_depth > 0 then st.pre_depth <- st.pre_depth - 1;
            emit st "\n```\n"
        | _ -> ())
    | [] -> ()

let transform ?(max_bytes = default_max_bytes) ?(max_input = default_max_input)
    ?(max_refs = default_max_refs) ~package ~version ~path ~html () =
  if String.length html > max_input then
    {
      body = "[documentation page too large to process]";
      references = [];
      truncated = true;
      references_truncated = false;
    }
  else
    let st =
      {
        body = Buffer.create 4096;
        body_len = 0;
        max_bytes;
        truncated = false;
        drop_depth = 0;
        stack = [];
        pre_depth = 0;
        anchor = None;
        refs_rev = [];
        refs_count = 0;
        refs_capped = false;
        max_refs;
        seen = Hashtbl.create 256;
        resolve = make_resolve ~package ~version ~path;
      }
    in
    let step () (signal : Markup.signal) =
      (match signal with
      | `Start_element (name, attrs) ->
          on_start st (String.lowercase_ascii (snd name)) attrs
      | `End_element -> on_end st
      | `Text ss -> on_text st (String.concat "" ss)
      | `Comment _ | `Doctype _ | `PI _ | `Xml _ -> ());
      ()
    in
    Markup.(string html |> parse_html |> signals |> fold step ());
    (match st.anchor with Some _ -> finalize_anchor st | None -> ());
    let body = squeeze_blank_lines (String.trim (Buffer.contents st.body)) in
    {
      body;
      references = List.rev st.refs_rev;
      truncated = st.truncated;
      references_truncated = st.refs_capped;
    }
