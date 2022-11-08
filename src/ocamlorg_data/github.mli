val read_token: string -> string

module Repo: sig
    type t = {
        name: string;
        description: string;
        pull_request_total_count: int;
        pull_requests: string list (* author_login list *)
    }

    val request : string -> string -> (t, [> `Msg of string]) result Lwt.t
end