let all () =
  let content = Data.read "opam-repository-timestamps.txt" |> Option.get in
  let lines = String.split_on_char '\n' (String.trim content) in
  lines
  |> List.map (fun line ->
         match String.split_on_char ' ' line with
         | [ filepath; timestamp ] -> (filepath, int_of_string timestamp)
         | _ ->
             failwith
               (Printf.sprintf
                  "The opam-repository-timestamps.txt file format is not \
                   valid: %s"
                  line))

let pp ppf (filepath, timestamp) =
  Fmt.pf ppf {|(%a, %a)|} Pp.string filepath Pp.int timestamp

let pp_list = Pp.list pp
let template () = Format.asprintf {|let t = %a|} pp_list (all ())
