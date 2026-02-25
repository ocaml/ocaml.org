(* Blog parser - adapted from ood-gen/lib/blog.ml *)

open Import

type source = [%import: Data_intf.Blog.source] [@@deriving show]
type post = [%import: Data_intf.Blog.post] [@@deriving show]

module Source = struct
  type t = {
    id : string;
    name : string;
    url : string;
    publish_all : bool option;
    disabled : bool option;
  }
  [@@deriving of_yaml]

  type sources = t list [@@deriving of_yaml]

  let all () : source list =
    let file = "planet-sources.yml" in
    let result =
      let ( let* ) = Result.bind in
      let* yaml = Utils.yaml_file file in
      let* sources =
        sources_of_yaml yaml |> Result.map_error (Utils.where file)
      in
      Ok
        (sources
        |> List.map (fun { id; name; url; publish_all; disabled } ->
               {
                 Data_intf.Blog.id;
                 name;
                 url;
                 description = "";
                 publish_all = Option.value ~default:true publish_all;
                 disabled = Option.value ~default:false disabled;
               }))
    in
    result
    |> Result.get_ok ~error:(fun (`Msg msg) ->
           Exn.Decode_error (file ^ ": " ^ msg))
end

module Post = struct
  type source_on_external_post = { name : string; url : string }
  [@@deriving of_yaml]

  type metadata = {
    title : string;
    description : string option;
    url : string;
    date : string;
    preview_image : string option;
    authors : string list option;
    source : source_on_external_post option;
    ignore : bool option;
  }
  [@@deriving of_yaml]

  let all_sources = Source.all ()

  let of_metadata ~source m : post option =
    if Option.value ~default:false m.ignore then None
    else
      Some
        {
          title = m.title;
          source =
            (match source with
            | Ok s -> s
            | Error (`Msg e) -> (
                match m.source with
                | Some { name; url } ->
                    {
                      id = "";
                      name;
                      url;
                      description = "";
                      publish_all = true;
                      disabled = false;
                    }
                | None ->
                    failwith
                      (e
                     ^ " and there is no source defined in the markdown file")));
          url = m.url;
          slug = "";
          description = m.description;
          authors = Option.value ~default:[] m.authors;
          date = m.date;
          preview_image = m.preview_image;
        }

  let decode (fpath, (head, _)) =
    let metadata =
      metadata_of_yaml head |> Result.map_error (Utils.where fpath)
    in
    let source =
      match Str.split (Str.regexp_string "/") fpath with
      | _ :: second :: _ -> (
          match
            List.find_opt (fun (s : source) -> s.id = second) all_sources
          with
          | Some source -> Ok source
          | None -> Error (`Msg ("No source found for: " ^ fpath)))
      | _ ->
          failwith
            ("Trying to determine the source for " ^ fpath
           ^ " but the path is not long enough (should start with \
              planet/SOURCE_NAME/...)")
    in
    metadata
    |> Result.map_error (Utils.where fpath)
    |> Result.map (of_metadata ~source)

  let all () : post list =
    Utils.map_md_files decode "planet/*/*.md"
    |> List.filter_map (fun x -> x)
    |> List.sort (fun (a : post) (b : post) -> String.compare b.date a.date)
end

let all_sources () = Source.all ()
let all_posts () = Post.all ()
