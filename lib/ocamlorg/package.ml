module Info = struct
  type t =
    { synopsis : string
    ; description : string
    ; authors : string list
    ; license : string
    ; publication_date : string
    ; homepage : string list
    ; tags : string list
    ; maintainers : string list
    ; dependencies : (OpamPackage.Name.t * string option) list
    ; depopts : (OpamPackage.Name.t * string option) list
    ; conflicts : (OpamPackage.Name.t * string option) list
    }

  let relop_to_string = OpamPrinter.FullPos.relop_kind

  let filter_to_string = OpamFilter.to_string

  let string_of_formula = function
    | OpamFormula.Empty ->
      None
    | formula ->
      Some
        (OpamFormula.string_of_formula
           (function
             | OpamTypes.Filter f ->
               filter_to_string f
             | Constraint (relop, f) ->
               relop_to_string relop ^ " " ^ filter_to_string f)
           formula)

  let parse_formula =
    OpamFormula.fold_left
      (fun lst (name, cstr) -> (name, string_of_formula cstr) :: lst)
      []

  let get_conflicts (opam : OpamFile.OPAM.t) =
    let data = OpamFile.OPAM.conflicts opam in
    parse_formula data

  let get_dependencies (opam : OpamFile.OPAM.t) =
    let data = OpamFile.OPAM.depends opam in
    parse_formula data

  let get_depopts (opam : OpamFile.OPAM.t) =
    let data = OpamFile.OPAM.depopts opam in
    parse_formula data

  let of_opamfile (opam : OpamFile.OPAM.t) =
    let open OpamFile.OPAM in
    { synopsis = synopsis opam |> Option.value ~default:"no synopsis"
    ; authors = author opam
    ; maintainers = maintainer opam
    ; license = license opam |> String.concat "; "
    ; description =
        descr opam |> Option.map OpamFile.Descr.body |> Option.value ~default:""
    ; homepage = homepage opam
    ; tags = tags opam
    ; publication_date = "today"
    ; conflicts = get_conflicts opam
    ; dependencies = get_dependencies opam
    ; depopts = get_depopts opam
    }
end

type t =
  { name : OpamPackage.Name.t
  ; version : OpamPackage.Version.t
  ; info : Info.t
  }

let of_opamfile (opam : OpamFile.OPAM.t) =
  let open OpamFile.OPAM in
  { name = name opam; version = version opam; info = Info.of_opamfile opam }
