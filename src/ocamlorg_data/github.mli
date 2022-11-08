type repo = {
    name: string;
    description: string;
    pull_request_total_count: int;
    pull_requests: string list (* author_login list *)
}
val read_token: string -> string
val request_repo : string -> string -> (repo, [> `Msg of string]) result Lwt.t