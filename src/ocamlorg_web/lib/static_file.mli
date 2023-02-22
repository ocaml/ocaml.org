(*
  We serve static files (e.g. assets) under two relative URLs:

  /{PATH}
  /_/{DIGEST}/{PATH}
  
  For the latter path, we allow browsers to cache the file received
  for a very long time, treating it like an immutable resource with a
  unique URL based on a file content digest.

  This module implements references to static files (with or without
  digest) and conversions between
  (1) a file path + optional digest, and
  (2) the corresponding relative URL under which the static file
      is served via HTTP.
*)

type t = {
  filepath : string;
  digest : string option
}

(* converts a static file reference to a relative URL by
   rendering the digest (if applicable) and filepath *)
val to_url_path : t -> string 

(* converts a relative URL to a static file reference by
   extracting the digest (if applicable) and filepath
   from the URL *)
val of_url_path : string -> t

(* given the path of a file from `assets.ml`:
   1. looks up the file's digest in and
   2. returns the corresponding digest URL
   for use in templates *)
val asset_digest_url :
  string ->
  string
