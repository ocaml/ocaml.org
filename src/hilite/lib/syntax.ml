type 'a res = ('a, [ `Msg of string ]) result

let span class_gen t =
  let drop_last lst =
    let l = List.length lst in
    List.filteri (fun i _ -> i < l - 1) lst
  in
  let span_gen c s = "<span class='" ^ (class_gen c) ^ "'>" ^ s ^ "</span>" in
  span_gen (String.concat "-" (drop_last t))

let mk_block lang =
  List.map
    (List.map (fun (scope, str) -> (span (fun c -> lang ^ "-" ^ c) scope) str))

let rec highlight_tokens i spans line = function
  | [] ->
    List.rev spans
  | tok :: toks ->
    let j = TmLanguage.ending tok in
    assert (j > i);
    let text = String.sub line i (j - i) in
    let scope =
      match TmLanguage.scopes tok with
      | [] ->
        []
      | scope :: _ ->
        String.split_on_char '.' scope
    in
    highlight_tokens j ((scope, text) :: spans) line toks

let highlight_string t grammar stack str =
  let lines = String.split_on_char '\n' str in
  let rec loop stack acc = function
    | [] ->
      List.rev acc
    | line :: lines ->
      (* Some patterns don't work if there isn't a newline *)
      let line = line ^ "\n" in
      let tokens, stack = TmLanguage.tokenize_exn t grammar stack line in
      let spans = highlight_tokens 0 [] line tokens in
      loop stack (spans :: acc) lines
  in
  loop stack [] lines

let lang_to_plist s =
  match String.lowercase_ascii s with
  | "ocaml" ->
    Jsons.ocaml |> Yojson.Basic.from_string
  | "dune" ->
    Jsons.dune |> Yojson.Basic.from_string
  | "opam" ->
    Jsons.opam |> Yojson.Basic.from_string
  | l ->
    failwith ("Language not supported: " ^ l)

let src_code_to_tyxml_html ~lang ~src =
  let t = TmLanguage.create () in
  let plist = lang_to_plist lang in
  let grammar = TmLanguage.of_yojson_exn plist in
  TmLanguage.add_grammar t grammar;
  match TmLanguage.find_by_name t lang with
  | None ->
    Error (`Msg ("Unknown language " ^ lang))
  | Some grammar ->
    Ok (highlight_string t grammar TmLanguage.empty src |> mk_block lang)

let drop_last lst =
  let rec aux acc = function
    | [] ->
      List.rev acc
    | [ _ ] ->
      List.rev acc
    | x :: xs ->
      aux (x :: acc) xs
  in
  aux [] lst

let src_code_to_html ~lang ~src =
  src_code_to_tyxml_html ~lang ~src |> function
  | Ok tyxml ->
    let lst = if List.length tyxml = 1 then tyxml else drop_last tyxml in
    Ok ("<pre><code>" ^ (String.concat "" @@ List.concat lst) ^ "</code></pre>")
  | Error (`Msg m) ->
    Error (`Msg m)
