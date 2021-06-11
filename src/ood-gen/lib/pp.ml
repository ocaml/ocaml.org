let option fmt ppf = function
  | Some v -> Fmt.pf ppf "Some %a" fmt v
  | None -> Fmt.pf ppf "None"

let list fmt = Fmt.brackets (Fmt.list fmt ~sep:Fmt.semi)

let string_list = Fmt.brackets (Fmt.list (Fmt.quote Fmt.string) ~sep:Fmt.semi)

let quoted_string = Fmt.quote Fmt.string

let quoted_string_escape ppf v =
  Fmt.pf ppf "%a" (Fmt.quote Fmt.string)
    (Str.global_replace (Str.regexp "\"") "\\\"" v)
