type t = [%import: Data_intf.Academic_testimonial.t] [@@deriving of_yaml, show]

let all () = Utils.yaml_sequence_file of_yaml "academic-testimonials.yml"

let template () =
  Format.asprintf {|
include Data_intf.Academic_testimonial
let all = %a
|}
    (Fmt.Dump.list pp) (all ())
