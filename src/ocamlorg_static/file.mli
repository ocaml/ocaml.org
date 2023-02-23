(* We serve static files (e.g. assets) under two relative URLs:

   /{PATH}

   and

   /_/{DIGEST}/{PATH}

   For the latter path, we allow browsers to cache the file received for a very
   long time, treating it like an immutable resource with a unique URL based on
   a file content digest.

   This module implements references to static files (with or without digest)
   and conversions between (1) a file path + optional digest, and (2) the
   corresponding relative URL under which the static file is served via HTTP. *)

(* renders a relative URL from the optional [digest] and [filepath] *)
val to_url_path : ?digest:string -> string -> string

type t = { filepath : string; digest : string option }

(* tries to convert a relative URL to a static file reference by extracting the
   digest (if applicable) and filepath *)
val of_url_path : string -> t option
