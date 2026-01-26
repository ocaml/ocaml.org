(* Job parser - adapted from ood-gen/lib/job.ml *)

open Import

type t = [%import: Data_intf.Job.t] [@@deriving of_yaml, show]

let all () =
  let job_date j = Option.value ~default:"1970-01-01" j.publication_date in
  Utils.yaml_sequence_file of_yaml "jobs.yml"
  |> List.sort (fun j1 j2 -> compare (job_date j2) (job_date j1))
