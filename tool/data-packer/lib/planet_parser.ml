(* Planet parser - adapted from ood-gen/lib/planet.ml *)

(* Entry type - BlogPost or Video. We use the Data_intf types directly since
   ppx_import has trouble with types referencing other modules. *)
type entry = Data_intf.Planet.entry =
  | BlogPost of Data_intf.Blog.post
  | Video of Data_intf.Video.t

let date_of_entry = function
  | BlogPost { Data_intf.Blog.date; _ } -> date
  | Video { Data_intf.Video.published; _ } -> published

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
