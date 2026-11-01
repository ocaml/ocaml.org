(* One-off backfill of [keywords:] front matter for existing Planet posts (issue
   #3875, step 3).

   For every post under [data/planet/<source>/<slug>.md] this obtains the
   article text -- preferring the HTML body already stored after the front
   matter (posts scraped before #3463 carry one, roughly half the corpus) and
   fetching the live [url:] only when the stored body is missing or too short
   (following redirects; no Wayback, no agent -- posts with neither are logged
   and skipped). It then derives keywords with a token-free Stage-1 pipeline:
   corpus TF-IDF over the Planet corpus plus dictionary matching against opam
   package names and a controlled vocabulary. Keywords are written back as a
   minimal textual patch -- a [keywords:] block inserted before the front
   matter's closing [---] -- so existing bytes are untouched and per-post diffs
   stay reviewable. *)

let planet_dir = "data/planet"
let vocab_file = "tool/data-scrape/planet-keywords-vocab.txt"

(* Default local cache for fetched article text, so Pass B and re-runs do not
   refetch. Lives under the system temp dir -- never in the repo. *)
let default_cache_dir =
  Filename.concat (Filename.get_temp_dir_name ()) "ocamlorg-planet-text"

module SSet = Set.Make (String)

(* First index of [sub] in [s], or [None]. *)
let find_sub ~sub s =
  let n = String.length s and m = String.length sub in
  if m = 0 then Some 0
  else
    let rec loop i =
      if i + m > n then None
      else if String.sub s i m = sub then Some i
      else loop (i + 1)
    in
    loop 0

(* ------------------------------------------------------------------ *)
(* Posts on disk                                                        *)
(* ------------------------------------------------------------------ *)

type post = {
  path : string; (* data/planet/<source>/<slug>.md *)
  source : string;
  slug : string;
  title : string;
  url : string;
  has_keywords : bool;
}

(* Split a post file into (front-matter-text, body). The front matter is the
   text between the opening and closing ["---"] lines; [body] is everything
   after. Returns [None] if the file has no front matter. *)
let split_front_matter contents =
  let sep = "---\n" in
  if not (String.starts_with ~prefix:sep contents) then None
  else
    let rest = String.sub contents 4 (String.length contents - 4) in
    match find_sub ~sub:"\n---\n" rest with
    | None -> None
    | Some i ->
        let fm = String.sub rest 0 (i + 1) (* include trailing newline *) in
        let body = String.sub rest (i + 5) (String.length rest - (i + 5)) in
        Some (fm, body)

let read_file path =
  let ic = open_in_bin path in
  Fun.protect
    ~finally:(fun () -> close_in ic)
    (fun () -> really_input_string ic (in_channel_length ic))

(* Pull [url:], [title:] and the presence of [keywords:] straight from the front
   matter with the project's YAML parser. *)
let parse_meta fm =
  match Yaml.of_string fm with
  | Error _ -> None
  | Ok (`O fields) ->
      let find k =
        match List.assoc_opt k fields with
        | Some (`String s) -> Some s
        | _ -> None
      in
      let has_keywords = List.mem_assoc "keywords" fields in
      Option.map
        (fun url ->
          (url, Option.value ~default:"" (find "title"), has_keywords))
        (find "url")
  | Ok _ -> None

let collect_posts ~source_filter ~only_missing =
  let sources =
    Sys.readdir planet_dir |> Array.to_list |> List.sort String.compare
    |> List.filter (fun s ->
           Sys.is_directory (Filename.concat planet_dir s)
           && match source_filter with Some f -> f = s | None -> true)
  in
  List.concat_map
    (fun source ->
      let dir = Filename.concat planet_dir source in
      Sys.readdir dir |> Array.to_list |> List.sort String.compare
      |> List.filter_map (fun fname ->
             if not (Filename.check_suffix fname ".md") then None
             else
               let path = Filename.concat dir fname in
               match split_front_matter (read_file path) with
               | None -> None
               | Some (fm, _) -> (
                   match parse_meta fm with
                   | Some (url, title, has_keywords)
                     when url <> "" && not (only_missing && has_keywords) ->
                       Some
                         {
                           path;
                           source;
                           slug = Filename.remove_extension fname;
                           title;
                           url;
                           has_keywords;
                         }
                   | _ -> None)))
    sources

(* ------------------------------------------------------------------ *)
(* Pass A: fetch + HTML -> text, with an on-disk cache                   *)
(* ------------------------------------------------------------------ *)

(* Elements whose text is never article content, and elements whose text is code
   (kept apart so identifiers count only when they hit the dictionary). *)
let skip_tags =
  [
    "script";
    "style";
    "noscript";
    "nav";
    "header";
    "footer";
    "aside";
    "form";
    "svg";
    "head";
    "button";
    "iframe";
  ]

let code_tags = [ "pre"; "code"; "kbd"; "samp"; "tt" ]

let html_to_text html =
  let prose = Buffer.create 4096 and code = Buffer.create 1024 in
  let stack = ref [] in
  let in_any tags = List.exists (fun t -> List.mem t tags) !stack in
  (try
     Markup.string html |> Markup.parse_html |> Markup.signals
     |> Markup.iter (function
          | `Start_element ((_, name), _) ->
              stack := String.lowercase_ascii name :: !stack
          | `End_element -> (
              match !stack with _ :: tl -> stack := tl | [] -> ())
          | `Text ss ->
              if not (in_any skip_tags) then
                let buf = if in_any code_tags then code else prose in
                List.iter
                  (fun s ->
                    Buffer.add_string buf s;
                    Buffer.add_char buf ' ')
                  ss
          | _ -> ())
   with _ -> ());
  (Buffer.contents prose, Buffer.contents code)

let cache_path ~cache_dir p =
  Filename.concat cache_dir (p.source ^ "__" ^ p.slug ^ ".txt")

(* Cached text is stored as "<prose>\x00<code>". *)
let read_cached_text cf =
  match String.split_on_char '\000' (read_file cf) with
  | [ prose; code ] -> Some (prose, code)
  | _ -> None

let cache_write cf (prose, code) =
  let oc = open_out_bin cf in
  output_string oc (prose ^ "\000" ^ code);
  close_out oc

(* Posts scraped before #3463 still carry their HTML body after the front
   matter. A stored body at least this long (prose characters) is used directly,
   so roughly half the corpus needs no network at all. Shorter bodies (excerpts,
   link-only posts) fall through to a live fetch. *)
let min_local_prose = 800

(* Some stored [url:] fields carry stray spaces encoded as "%20" -- leading,
   trailing, or as a bogus "/%20/" path segment (58 frama-c posts). Clean them
   so the fetch succeeds; the malformed front-matter url is a separate data
   fix. *)
let clean_url url =
  let url = String.trim url in
  let strip_affix affix s =
    let a = String.length affix in
    let s = ref s in
    while String.starts_with ~prefix:affix !s do
      s := String.sub !s a (String.length !s - a)
    done;
    while String.ends_with ~suffix:affix !s do
      s := String.sub !s 0 (String.length !s - a)
    done;
    !s
  in
  let s = strip_affix "%20" url in
  (* Collapse a "/ /" segment left by an encoded space. *)
  let rec collapse s =
    match find_sub ~sub:"/%20/" s with
    | None -> s
    | Some i ->
        collapse
          (String.sub s 0 i ^ "/"
          ^ String.sub s (i + 5) (String.length s - (i + 5)))
  in
  collapse s

let fetch_url p =
  let url = clean_url p.url in
  try Some (Http_client.get_sync ~max_random_delay:1.0 (Uri.of_string url))
  with e ->
    if Sys.getenv_opt "BACKFILL_DEBUG" <> None then
      Printf.eprintf "fetch %s: %s\n%!" url (Printexc.to_string e);
    None

(* Resolve a post to [(fetched_now, (prose, code))], preferring the body already
   on disk and fetching the live url only when the stored body is too short. A
   fetch that fails falls back to whatever short body was stored. [None] means
   nothing usable was found (dead blog with no stored body). *)
let ensure_text ~cache_dir p =
  let cf = cache_path ~cache_dir p in
  if Sys.file_exists cf then
    Option.map (fun t -> (false, t)) (read_cached_text cf)
  else
    let local =
      match split_front_matter (read_file p.path) with
      | Some (_, body) when String.trim body <> "" ->
          let ((prose, _) as t) = html_to_text body in
          if String.length prose > 0 then Some t else None
      | _ -> None
    in
    let use ~fetched t =
      cache_write cf t;
      Some (fetched, t)
    in
    match local with
    | Some ((prose, _) as t) when String.length prose >= min_local_prose ->
        use ~fetched:false t
    | _ -> (
        (* Stored body missing or too short: fetch live, else fall back to
           it. *)
        match fetch_url p with
        | Some html ->
            let ((prose, _) as t) = html_to_text html in
            if String.length prose > 0 then use ~fetched:true t
            else Option.map (use ~fetched:false) local |> Option.join
        | None -> Option.map (use ~fetched:false) local |> Option.join)

(* ------------------------------------------------------------------ *)
(* Tokenisation and n-grams                                             *)
(* ------------------------------------------------------------------ *)

let stopwords =
  String.split_on_char ' '
    "a an and are as at be been but by can could do does for from had has have \
     here how i if in into is it its may might more most no not of on one only \
     or other our out over own so some such than that the their them then \
     there these they this those through to too us use used uses using value \
     values very was we were what when where which while who will with would \
     you your ocaml ocaml's code example examples post posts blog article \
     function functions module modules type types let rec match val int string \
     list thing things way ways first new like just also more one two way get \
     make les des une aux par sur pour dans avec sans sous que qui quoi dont \
     pas plus moins tres tout tous toute toutes son ses leur leurs mes mais \
     donc car ces cet cette celui celle ceux comme ont est sont etre etait \
     fait font nous vous ils elle elles cela ainsi alors apres avant entre \
     chez meme aussi encore bien deja lors vers selon depuis nos vos notre \
     votre cas peut etc"
  |> List.filter (fun s -> s <> "")
  |> List.fold_left (fun s w -> SSet.add w s) SSet.empty

let is_word_char c =
  (c >= 'a' && c <= 'z') || (c >= '0' && c <= '9') || c = '_' || c = '-'

(* Fold UTF-8 Latin accents to their ASCII base so accented words tokenise whole
   (e.g. "généalogie" -> "genealogie") instead of fragmenting on the multibyte
   accent. Known accents become their base letter (keeping the word together);
   any other non-ASCII byte becomes a space (a token separator). *)
let fold_accents s =
  let b = Buffer.create (String.length s) in
  let n = String.length s in
  let i = ref 0 in
  while !i < n do
    let c = Char.code s.[!i] in
    if c < 0x80 then (
      Buffer.add_char b s.[!i];
      incr i)
    else if c = 0xC3 && !i + 1 < n then (
      (match Char.code s.[!i + 1] with
      | 0x80 | 0x81 | 0x82 | 0x83 | 0x84 | 0x85 | 0xA0 | 0xA1 | 0xA2 | 0xA3
      | 0xA4 | 0xA5 ->
          Buffer.add_char b 'a'
      | 0x87 | 0xA7 -> Buffer.add_char b 'c'
      | 0x88 | 0x89 | 0x8A | 0x8B | 0xA8 | 0xA9 | 0xAA | 0xAB ->
          Buffer.add_char b 'e'
      | 0x8C | 0x8D | 0x8E | 0x8F | 0xAC | 0xAD | 0xAE | 0xAF ->
          Buffer.add_char b 'i'
      | 0x91 | 0xB1 -> Buffer.add_char b 'n'
      | 0x92 | 0x93 | 0x94 | 0x95 | 0x96 | 0xB2 | 0xB3 | 0xB4 | 0xB5 | 0xB6 ->
          Buffer.add_char b 'o'
      | 0x99 | 0x9A | 0x9B | 0x9C | 0xB9 | 0xBA | 0xBB | 0xBC ->
          Buffer.add_char b 'u'
      | 0x9D | 0xBD | 0xBF -> Buffer.add_char b 'y'
      | _ -> Buffer.add_char b ' ');
      i := !i + 2)
    else if
      c = 0xC5 && !i + 1 < n && (s.[!i + 1] = '\x92' || s.[!i + 1] = '\x93')
    then (
      Buffer.add_string b "oe";
      i := !i + 2)
    else (
      Buffer.add_char b ' ';
      incr i)
  done;
  Buffer.contents b

let tokenize s =
  let s = String.lowercase_ascii (fold_accents s) in
  let out = ref [] and buf = Buffer.create 32 in
  let flush () =
    if Buffer.length buf > 0 then (
      out := Buffer.contents buf :: !out;
      Buffer.clear buf)
  in
  String.iter
    (fun c -> if is_word_char c then Buffer.add_char buf c else flush ())
    s;
  flush ();
  List.rev !out

(* Keep alphabetic-ish tokens of length >= 3 that are not stopwords. *)
let keep_token t =
  String.length t >= 3
  && (not (SSet.mem t stopwords))
  (* Must start with a letter: drops "7th", "18", bare years, while keeping
     identifiers like "arm64" or "x86". *)
  && t.[0] >= 'a'
  && t.[0] <= 'z'

(* The n-gram set (1..3 words) of a prose token list, used both for document
   frequencies and for membership tests against the dictionary. *)
let ngram_set tokens =
  let arr = Array.of_list tokens in
  let n = Array.length arr in
  let s = ref SSet.empty in
  for i = 0 to n - 1 do
    if keep_token arr.(i) then s := SSet.add arr.(i) !s;
    if i + 1 < n then s := SSet.add (arr.(i) ^ " " ^ arr.(i + 1)) !s;
    if i + 2 < n then
      s := SSet.add (arr.(i) ^ " " ^ arr.(i + 1) ^ " " ^ arr.(i + 2)) !s
  done;
  !s

(* ------------------------------------------------------------------ *)
(* Dictionaries                                                         *)
(* ------------------------------------------------------------------ *)

(* A dictionary maps a normalised (lowercase) term to its canonical display
   form. Two sources: opam package names and the controlled-vocabulary file. *)

let load_opam_names () =
  let repo =
    match Sys.getenv_opt "OCAMLORG_REPO_PATH" with
    | Some p -> p
    | None ->
        Filename.concat
          (Option.value ~default:"." (Sys.getenv_opt "HOME"))
          ".cache/ocamlorg/opam-repository"
  in
  let packages = Filename.concat repo "packages" in
  if not (Sys.file_exists packages) then []
  else
    Sys.readdir packages |> Array.to_list
    (* Package names are their own canonical display form. Single-letter or very
       short names are too noisy to use as keywords. *)
    |> List.filter (fun n -> String.length n >= 3)
    |> List.map (fun n -> (String.lowercase_ascii n, n))

let load_vocab () =
  if not (Sys.file_exists vocab_file) then []
  else
    read_file vocab_file |> String.split_on_char '\n'
    |> List.filter_map (fun line ->
           let line = String.trim line in
           if line = "" || String.starts_with ~prefix:"#" line then None
           else
             match find_sub ~sub:"=>" line with
             | Some i ->
                 let variant = String.trim (String.sub line 0 i) in
                 let canon =
                   String.trim
                     (String.sub line (i + 2) (String.length line - (i + 2)))
                 in
                 Some (String.lowercase_ascii variant, canon)
             | None -> Some (String.lowercase_ascii line, line))

(* [canon]: normalised term -> canonical display form (opam names ∪ vocab).
   [vocab]: the subset coming from the curated vocabulary, which is boosted
   harder and exempt from the "too common to be a keyword" cut. *)
type dictionary = { canon : (string, string) Hashtbl.t; vocab : SSet.t }

let load_dictionary () =
  let canon = Hashtbl.create 4096 in
  List.iter (fun (k, v) -> Hashtbl.replace canon k v) (load_opam_names ());
  let vocab_entries = load_vocab () in
  (* Vocab wins over opam names on collision (canonical display is curated). *)
  List.iter (fun (k, v) -> Hashtbl.replace canon k v) vocab_entries;
  let vocab =
    List.fold_left (fun s (k, _) -> SSet.add k s) SSet.empty vocab_entries
  in
  { canon; vocab }

(* ------------------------------------------------------------------ *)
(* Scoring and selection                                                *)
(* ------------------------------------------------------------------ *)

type analysed = {
  grams : SSet.t; (* all n-grams: prose 1..3-grams + code identifiers *)
  code_grams : SSet.t; (* identifiers seen in code/command spans only *)
  tf : (string, int) Hashtbl.t; (* prose unigram term frequencies *)
  code_tf : (string, int) Hashtbl.t; (* code identifier frequencies *)
}

let count_tokens toks =
  let tf = Hashtbl.create 256 in
  List.iter
    (fun t ->
      if keep_token t then
        Hashtbl.replace tf t
          (1 + Option.value ~default:0 (Hashtbl.find_opt tf t)))
    toks;
  tf

let analyse (prose, code) =
  let ptoks = tokenize prose and ctoks = tokenize code in
  let prose_grams = ngram_set ptoks in
  (* Code identifiers are kept apart: an opam package name is a trustworthy
     keyword when it appears as code (e.g. [open Lwt], [opam install dune]) but
     not when it is merely an English word in prose. *)
  let code_grams =
    List.fold_left
      (fun s t -> if keep_token t then SSet.add t s else s)
      SSet.empty ctoks
  in
  let grams = SSet.union prose_grams code_grams in
  { grams; code_grams; tf = count_tokens ptoks; code_tf = count_tokens ctoks }

(* Document frequencies over the WHOLE cache, not just the batch being written,
   so IDF is stable however the run is scoped by [--source]/[--limit]. Populate
   the cache with a corpus-wide fetch first for best keyword quality. *)
let corpus_df ~cache_dir =
  let df = Hashtbl.create 65536 and ndocs = ref 0 in
  Sys.readdir cache_dir
  |> Array.iter (fun f ->
         if Filename.check_suffix f ".txt" then
           match read_cached_text (Filename.concat cache_dir f) with
           | None -> ()
           | Some text ->
               incr ndocs;
               SSet.iter
                 (fun g ->
                   Hashtbl.replace df g
                     (1 + Option.value ~default:0 (Hashtbl.find_opt df g)))
                 (analyse text).grams);
  (df, !ndocs)

(* Document frequencies over every post's STORED body on disk (no cache, no
   network). Used for scrape-time keyword generation, where the corpus text
   lives in data/planet rather than a warm cache. Posts without a stored body do
   not contribute. *)
let corpus_df_from_disk () =
  let df = Hashtbl.create 65536 and ndocs = ref 0 in
  if Sys.file_exists planet_dir then
    Sys.readdir planet_dir
    |> Array.iter (fun src ->
           let dir = Filename.concat planet_dir src in
           if Sys.is_directory dir then
             Sys.readdir dir
             |> Array.iter (fun f ->
                    if Filename.check_suffix f ".md" then
                      match
                        split_front_matter (read_file (Filename.concat dir f))
                      with
                      | Some (_, body) when String.trim body <> "" ->
                          incr ndocs;
                          SSet.iter
                            (fun g ->
                              Hashtbl.replace df g
                                (1
                                + Option.value ~default:0
                                    (Hashtbl.find_opt df g)))
                            (analyse (html_to_text body)).grams
                      | _ -> ()));
  (df, !ndocs)

let max_keywords = 10

(* Boost applied, on top of corpus IDF, to a dictionary hit so a distinctive
   term beats a raw prose token. Curated vocabulary outranks opam names. *)
let vocab_boost = 12.0
let opam_boost = 7.0

(* An opam name occurring in more than this fraction of the corpus is treated as
   too generic to be a keyword (e.g. "core", "github"). Vocab terms are
   exempt. *)
let common_opam_fraction = 0.6

let extract_keywords ~df ~ndocs ~dict ~title a =
  let title_grams = ngram_set (tokenize title) in
  let idf term =
    let d = Option.value ~default:1 (Hashtbl.find_opt df term) in
    log (float_of_int (1 + ndocs) /. float_of_int d)
  in
  let title_mult term = if SSet.mem term title_grams then 2.0 else 1.0 in
  (* Dictionary hits scored by IDF so corpus-ubiquitous names sink; curated
     vocab boosted harder, opam names dropped when they are too common. *)
  let dict_hits =
    Hashtbl.fold
      (fun term canon acc ->
        let is_vocab = SSet.mem term dict.vocab in
        (* Vocab terms match anywhere; opam names must appear as code or in the
           title to be trusted (otherwise an English-word package name like
           "sun" or "bear" fires on ordinary prose). *)
        let present =
          if is_vocab then SSet.mem term a.grams
          else SSet.mem term a.code_grams || SSet.mem term title_grams
        in
        if not present then acc
        else
          let d = Option.value ~default:1 (Hashtbl.find_opt df term) in
          if
            (not is_vocab)
            && float_of_int d > common_opam_fraction *. float_of_int ndocs
          then acc
          else
            let base = if is_vocab then vocab_boost else opam_boost in
            let score = base *. Float.max (idf term) 0.1 *. title_mult term in
            (canon, score) :: acc)
      dict.canon []
  in
  (* TF-IDF candidates: prose unigrams, plus code identifiers that *recur* (>=
     [code_min] times) so a repeatedly-used tool or command name (e.g. "day10")
     counts, while one-off code tokens (like a long results table of package
     names) do not. A term's weight is its prose count plus its code count when
     the latter clears the threshold. *)
  let code_min = 3 in
  let eff_tf = Hashtbl.copy a.tf in
  Hashtbl.iter
    (fun term c ->
      if c >= code_min then
        Hashtbl.replace eff_tf term
          (c + Option.value ~default:0 (Hashtbl.find_opt eff_tf term)))
    a.code_tf;
  let tfidf =
    Hashtbl.fold
      (fun term tf acc ->
        let i = idf term in
        if i <= 0. then acc
        else (term, float_of_int tf *. i *. title_mult term) :: acc)
      eff_tf []
  in
  (* Merge case-insensitively, preferring the canonical display form (dict hits
     are added first), keeping the strongest score, then cap the count. *)
  let module M = Map.Make (String) in
  let add m (display, score) =
    let k = String.lowercase_ascii display in
    M.update k
      (function
        | Some (d, s) -> Some (d, Float.max s score)
        | None -> Some (display, score))
      m
  in
  let merged = List.fold_left add M.empty (dict_hits @ tfidf) in
  M.bindings merged
  |> List.sort (fun (_, (_, s1)) (_, (_, s2)) -> compare s2 s1)
  |> List.filteri (fun i _ -> i < max_keywords)
  |> List.map (fun (_, (display, _)) -> display)
  |> List.sort String.compare

(* Keywords for a single post's HTML [content], given a precomputed corpus DF
   and dictionary. Used by the scraper to tag new posts at scrape time. *)
let keywords_for ~df ~ndocs ~dict ~title content =
  extract_keywords ~df ~ndocs ~dict ~title (analyse (html_to_text content))

(* ------------------------------------------------------------------ *)
(* Write-back: minimal textual patch                                    *)
(* ------------------------------------------------------------------ *)

(* Double-quote every keyword so it always decodes as a string. A bare scalar
   could be read by YAML as a bool/number/null -- e.g. "yes"/"off"/"nan"/"123"
   -- which fails the packer's [string list] decode. *)
let yaml_quote s =
  let b = Buffer.create (String.length s + 2) in
  Buffer.add_char b '"';
  String.iter
    (fun c ->
      if c = '"' || c = '\\' then Buffer.add_char b '\\';
      Buffer.add_char b c)
    s;
  Buffer.add_char b '"';
  Buffer.contents b

let yaml_block keywords =
  let b = Buffer.create 128 in
  Buffer.add_string b "keywords:\n";
  List.iter
    (fun k -> Buffer.add_string b (Printf.sprintf "- %s\n" (yaml_quote k)))
    keywords;
  Buffer.contents b

(* Drop an existing [keywords:] block (the key line and its following "- …"
   items) from front-matter text, so a rewrite replaces rather than duplicates
   it. *)
let strip_keywords fm =
  let lines = String.split_on_char '\n' fm in
  let rec drop = function
    | l :: rest when String.length l >= 2 && String.sub l 0 2 = "- " ->
        drop rest
    | rest -> rest
  in
  let rec go = function
    | l :: rest when l = "keywords:" -> go (drop rest)
    | l :: rest -> l :: go rest
    | [] -> []
  in
  String.concat "\n" (go lines)

let write_back p keywords =
  if keywords = [] then ()
  else
    let contents = read_file p.path in
    match split_front_matter contents with
    | None -> ()
    | Some (fm, body) ->
        (* fm has a trailing newline; strip any prior block, then insert before
           the closing ---. Idempotent under re-runs. *)
        let patched =
          "---\n" ^ strip_keywords fm ^ yaml_block keywords ^ "---\n" ^ body
        in
        let oc = open_out_bin p.path in
        output_string oc patched;
        close_out oc

(* ------------------------------------------------------------------ *)
(* Entry point                                                          *)
(* ------------------------------------------------------------------ *)

(* A resolved post with fewer kept content tokens (prose + code) than this is
   flagged "thin": its source text was likely a stub or short excerpt, so its
   keywords, if any, are weak. *)
let thin_content = 40

let run ~dry_run ~limit ~source_filter ~only_missing ~cache_dir ~report () =
  let cache_dir = Option.value ~default:default_cache_dir cache_dir in
  if not (Sys.file_exists cache_dir) then Unix.mkdir cache_dir 0o755;
  let posts = collect_posts ~source_filter ~only_missing in
  let posts =
    match limit with
    | Some n -> List.filteri (fun i _ -> i < n) posts
    | None -> posts
  in
  Printf.printf "Considering %d post(s)%s.\n%!" (List.length posts)
    (match source_filter with Some s -> " from " ^ s | None -> "");
  (* Pass A: resolve each post to text (stored body first, else a live
     fetch). *)
  let unresolved = ref [] and fetched = ref 0 in
  let docs =
    List.filter_map
      (fun p ->
        match ensure_text ~cache_dir p with
        | Some (did_fetch, text) ->
            if did_fetch then incr fetched;
            Some (p, analyse text)
        | None ->
            unresolved := p :: !unresolved;
            None)
      posts
  in
  (* IDF is computed over the whole cache (see [corpus_df]), which now contains
     at least this batch's text. *)
  let df, ndocs = corpus_df ~cache_dir in
  let dict = load_dictionary () in
  let written = ref 0 and empty = ref [] and thin = ref [] in
  let content_size a =
    let sum h = Hashtbl.fold (fun _ c acc -> acc + c) h 0 in
    sum a.tf + sum a.code_tf
  in
  List.iter
    (fun (p, a) ->
      let keywords = extract_keywords ~df ~ndocs ~dict ~title:p.title a in
      if dry_run then
        Printf.printf "%s/%s: %s\n" p.source p.slug
          (String.concat ", " keywords)
      else if keywords <> [] then (
        write_back p keywords;
        incr written);
      (* Flag posts worth manual review: no keywords at all, or thin source. *)
      if keywords = [] then empty := p :: !empty
      else if content_size a < thin_content then thin := p :: !thin)
    docs;
  (* Summary. *)
  Printf.printf
    "\n\
     Resolved %d (%d from stored body/cache, %d fetched live), unresolved %d, \
     empty %d, thin %d (IDF over %d cached docs)%s.\n"
    (List.length docs)
    (List.length docs - !fetched)
    !fetched (List.length !unresolved) (List.length !empty) (List.length !thin)
    ndocs
    (if dry_run then "" else Printf.sprintf ", wrote keywords to %d" !written);
  (* Itemised buckets, for stdout and the optional report file. *)
  let section title note posts =
    if posts = [] then ""
    else
      Printf.sprintf "\n## %s (%d) — %s\n" title (List.length posts) note
      ^ String.concat ""
          (List.map
             (fun p -> Printf.sprintf "  %s/%s  %s\n" p.source p.slug p.url)
             posts)
  in
  let body =
    section "Unresolved"
      "no stored body and url unreachable; needs a mirror or url fix"
      (List.rev !unresolved)
    ^ section "Empty" "resolved but produced no keywords; source text too thin"
        (List.rev !empty)
    ^ section "Thin"
        (Printf.sprintf "fewer than %d content tokens; keywords may be weak"
           thin_content)
        (List.rev !thin)
  in
  print_string body;
  match report with
  | None -> ()
  | Some file ->
      let oc = open_out file in
      output_string oc ("# Planet keyword backfill report\n" ^ body);
      close_out oc;
      Printf.printf "\nWrote report to %s\n" file
