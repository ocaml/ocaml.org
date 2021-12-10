let option fmt ppf = function
  | Some v ->
    Fmt.pf ppf "Some %a" fmt v
  | None ->
    Fmt.pf ppf "None"

let list fmt = Fmt.brackets (Fmt.list fmt ~sep:Fmt.semi)

let string_list = Fmt.brackets (Fmt.list (Fmt.quote Fmt.string) ~sep:Fmt.semi)

let string ppf v =
  Fmt.pf ppf "{js|%s|js}" (Str.global_replace (Str.regexp "\\\\") "\\\\\\\\" v)

let int = Fmt.int

let bool = Fmt.bool
