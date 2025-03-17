type t = [%import: Data_intf.Testimonial.t] [@@deriving of_yaml, show]

let all () = Utils.yaml_sequence_file of_yaml "testimonials.yml"

let template () =
  Format.asprintf {|
include Data_intf.Testimonial
let all = %a
|}
    (Fmt.Dump.list pp) (all ())
