open Data_intf.Job

let all () =
  let job_date j = Option.value ~default:"1970-01-01" j.publication_date in
  Utils.yaml_sequence_file of_yaml "jobs.yml"
  |> List.sort (fun j1 j2 -> compare (job_date j2) (job_date j1))

module JobFeed = struct
  let create_entry (job : t) =
    let content =
      Syndic.Atom.Text
        (Printf.sprintf "%s is looking for a \"%s\" (%s)\n" job.company
           job.title
           (String.concat ", " job.locations))
    in
    let id = Uri.of_string job.link in
    let authors = (Syndic.Atom.author "Job Listings on OCaml.org", []) in
    let updated =
      match job.publication_date with
      | Some date_str -> Syndic.Date.of_rfc3339 (date_str ^ "T00:00:00-00:00")
      | None -> Syndic.Date.of_rfc3339 "1970-01-01T00:00:00Z"
    in
    Syndic.Atom.entry ~content ~id ~authors ~title:(Syndic.Atom.Text job.title)
      ~updated
      ~links:[ Syndic.Atom.link id ]
      ()

  let create_feed () =
    let open Rss in
    () |> all
    |> create_entries ~create_entry
    |> entries_to_feed ~id:"jobs.xml" ~title:"OCaml Jobs"
    |> feed_to_string
end

let template () =
  Format.asprintf {|
include Data_intf.Job
let all = %a
|}
    (Fmt.brackets (Fmt.list pp ~sep:Fmt.semi))
    (all ())
