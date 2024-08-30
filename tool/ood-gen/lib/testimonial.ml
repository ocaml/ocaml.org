open Data_intf.Testimonial

let all () =
  Utils.yaml_sequence_file of_yaml "testimonials.yml"

let template () =
  Format.asprintf {|
include Data_intf.Testimonial
let all = %a
|}
    (Fmt.brackets (Fmt.list pp ~sep:Fmt.semi))
    (all ())
