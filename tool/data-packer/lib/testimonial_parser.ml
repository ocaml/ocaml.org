(* Testimonial parser - adapted from ood-gen/lib/testimonial.ml *)

type t = [%import: Data_intf.Testimonial.t] [@@deriving of_yaml, show]

let all () = Utils.yaml_sequence_file of_yaml "testimonials.yml"
