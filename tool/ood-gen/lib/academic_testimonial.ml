open Data_intf.Academic_testimonial

let all () = Utils.yaml_sequence_file of_yaml "academic-testimonials.yml"

let template () =
  Format.asprintf {|
include Data_intf.Academic_testimonial
let all = %a
|}
    (Fmt.brackets (Fmt.list pp ~sep:Fmt.semi))
    (all ())
