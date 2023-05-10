open Ocamlorg

module Store = struct
  module type S = sig
    val create_event : Event.t -> (unit, string) result Lwt.t
    val get_events : unit -> (Event.t list, string) result Lwt.t
  end

  module In_memory : S = struct
    let events = ref []

    let create_event event =
      events := event :: !events;
      Lwt.return (Ok ())

    let get_events () = Lwt.return (Ok !events)
  end
end

module Handler = struct
  let overview ~prefix _req =
    let loadavg_list = My_metrics.loadavg_report () in
    let memory_list = My_metrics.memory_report () in
    Dream.html
      (Overview_template.render ~prefix ~ocaml_version:Info.ocaml_version
         ~dream_version:(Info.dream_version ())
         ~dashboard_version:(Info.version ()) ~uptime:(Info.uptime_string ())
         ~commit:Commit.hash ~os_version:(Info.os_version ()) ~loadavg_list
         ~memory_list ())

  let analytics ~store ~prefix _req =
    let open Lwt.Syntax in
    let (module Repo : Store.S) = store in
    let* events = Repo.get_events () in
    match events with
    | Ok events -> Dream.html (Analytics_template.render ~prefix events)
    | Error _ ->
        Dream.respond ~code:500
          "could not get the list of events from the store"
end

module Middleware = struct
  let analytics store handler req =
    let open Lwt.Syntax in
    let ua = Dream.header req "user-agent" |> Option.map User_agent.parse in
    let* () =
      match ua with
      | None ->
          Logs.warn (fun m -> m "No user agent in the request headers");
          Lwt.return ()
      | Some x when User_agent.is_bot x ->
          Logs.warn (fun m -> m "Request is from a bot");
          Lwt.return ()
      | Some ua -> (
          let (module Repo : Store.S) = store in
          let url = Dream.target req in
          let referer = Dream.header req "referer" in
          let client = Dream.client req in
          let* event = Event.create ~ua ~url ~referer ~client in
          let+ result = Repo.create_event event in
          match result with
          | Ok _ -> ()
          | Error err ->
              Logs.warn (fun m ->
                  m "An error occured while collecting analytics data: %s" err))
    in
    handler req
end

module Router = struct
  let route ~prefix middlewares store =
    Dream.scope prefix middlewares
      [
        Dream.get "" (Handler.overview ~prefix);
        Dream.get "/analytics" (Handler.analytics ~prefix ~store);
        Dream.get "/assets/**" (Dream.static "_build/default/src/dream_dashboard/asset");
      ]
end

let route ?(store = (module Store.In_memory : Store.S)) ?(prefix = "/dashboard")
    ?(middlewares = []) () =
  Router.route ~prefix middlewares store

let analytics ?(store = (module Store.In_memory : Store.S)) () =
  Middleware.analytics store

let () = My_metrics.init_metrics ()
