(* Academic testimonial parser - adapted from
   ood-gen/lib/academic_testimonial.ml *)

type t = [%import: Data_intf.Academic_testimonial.t] [@@deriving of_yaml, show]

let all () = Utils.yaml_sequence_file of_yaml "academic-testimonials.yml"
