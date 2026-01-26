(* Planet parser - adapted from ood-gen/lib/planet.ml *)

(* Entry type - BlogPost or Video. We use the Data_intf types directly since
   ppx_import has trouble with types referencing other modules. *)
type entry = Data_intf.Planet.entry =
  | BlogPost of Data_intf.Blog.post
  | Video of Data_intf.Video.t

let pp_entry fmt = function
  | BlogPost p -> Format.fprintf fmt "BlogPost (%s)" p.title
  | Video v -> Format.fprintf fmt "Video (%s)" v.title

let show_entry e = Format.asprintf "%a" pp_entry e

let date_of_entry = function
  | BlogPost { date; _ } -> date
  | Video { published; _ } -> published

let all () : entry list =
  let external_posts =
    Blog_parser.all_posts ()
    |> List.map (fun (p : Data_intf.Blog.post) -> BlogPost p)
  in
  let videos =
    Video_parser.all () |> List.map (fun (v : Data_intf.Video.t) -> Video v)
  in
  external_posts @ videos
  |> List.sort (fun (a : entry) (b : entry) ->
         String.compare (date_of_entry b) (date_of_entry a))
