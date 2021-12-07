open Js_of_ocaml
open Js_of_ocaml_tyxml

let keywords =
  [ "\\bas\\b"
  ; "\\bdo\\b"
  ; "\\belse\\b"
  ; "\\bend\\b"
  ; "\\bexception\\b"
  ; "\\bfun\\b"
  ; "\\bfunctor\\b"
  ; "\\bif\\b"
  ; "\\bin\\b"
  ; "\\binclude\\b"
  ; "\\blet\\b"
  ; "\\bof\\b"
  ; "\\bopen\\b"
  ; "\\brec\\b"
  ; "\\bstruct\\b"
  ; "\\bthen\\b"
  ; "\\btype\\b"
  ; "\\bval\\b"
  ; "\\bwhile\\b"
  ; "\\bwith\\b"
  ]

let operators =
  [ "\\+"
  ; "\\\\"
  ; "\\;"
  ; "\\-"
  ; "\\*"
  ; "\\&"
  ; "\\%"
  ; "\\="
  ; "\\<"
  ; "\\>"
  ; "\\!"
  ; "\\?"
  ; "\\|"
  ; "\\@"
  ; "\\."
  ; "\\~"
  ]

let let_expression =
  "\\blet[ \\t\\r\\n\\v\\f]+(?:rec[ \
   \\t\\r\\n\\v\\f]+)?(?<func>[a-z_][A-Za-z0-9_']*)\\b"

let get_func_names s =
  let re = RegExp.create ~opts:[ Global; Multiline; Indices ] let_expression in
  let rec loop acc s =
    match RegExp.exec re s with
    | None ->
      List.rev acc
    | Some res ->
      (match RegExp.get_indices res with
      | _ :: (st, e) :: _ ->
        loop (("function-binding", st, e) :: acc) s
      | _ ->
        List.rev acc)
  in
  loop [] s

let find_match keyword s regexp =
  let re = RegExp.create ~opts:[ Global; Multiline; Indices ] regexp in
  let rec loop acc s =
    match RegExp.exec re s with
    | None ->
      List.rev acc
    | Some res ->
      (match RegExp.get_indices res with
      | [] ->
        List.rev acc
      | (st, e) :: _ ->
        (* Note [exec] updates [lastIndex] so we can carry on matching without
           String.sub *)
        loop ((keyword, st, e) :: acc) s)
  in
  loop [] s

let src_to_spans s offs =
  let rec loop acc idx = function
    | [] ->
      let el = Tyxml_js.Html.txt (String.sub s idx (String.length s - idx)) in
      List.rev (el :: acc)
    | (k, st, e) :: rest as lst ->
      let diff = st - idx in
      if diff > 0 then
        let el = Tyxml_js.Html.txt (String.sub s idx diff) in
        loop (el :: acc) (idx + diff) lst
      else
        let el =
          Tyxml_js.Html.span
            ~a:[ Tyxml_js.Html.a_class [ k ] ]
            [ Tyxml_js.Html.txt @@ String.sub s st (e - st) ]
        in
        loop (el :: acc) (idx + (e - st)) rest
  in
  loop [] 0 offs

let sharp ~a_class:_ s =
  let keywords =
    List.fold_left (fun acc t -> find_match "keyword" s t :: acc) [] keywords
    |> List.concat
  in
  let operators =
    List.fold_left
      (fun acc t -> find_match "keyword-operator" s t :: acc)
      []
      operators
    |> List.concat
  in
  let numbers = find_match "numeric" s "\\b\\d*\\.?\\d+\\b" in
  let names = get_func_names s in
  let highlights =
    List.sort
      (fun (_, s1, _) (_, s2, _) -> Int.compare s1 s2)
      (keywords @ operators @ numbers @ names)
  in
  Tyxml_js.Html.div @@ src_to_spans s highlights

let ocaml ~a_class:cl src =
  Tyxml_js.Html.(span ~a:[ a_class [ cl ] ] [ i [ txt src ] ])

let text = ocaml

let highlight from_ to_ e =
  match Js.Opt.to_option e##.textContent with
  | None ->
    assert false
  | Some x ->
    let x = Js.to_string x in
    let (`Pos from_) = from_ in
    let to_ = match to_ with `Pos n -> n | `Last -> String.length x - 1 in
    e##.innerHTML := Js.string "";
    let span kind s =
      if s <> "" then
        let span = Tyxml_js.Html.(span ~a:[ a_class [ kind ] ] [ txt s ]) in
        Dom.appendChild e (Tyxml_js.To_dom.of_element span)
    in
    span "normal" (String.sub x 0 from_);
    span "errorloc" (String.sub x from_ (to_ - from_));
    span "normal" (String.sub x to_ (String.length x - to_))
