(* Protocol-level tests for the MCP dispatch (Ocamlorg_mcp.handle). These
   exercise the JSON-RPC handshake and error handling without a running
   server. *)

(* [Ocamlorg_mcp.handle] is now [Lwt]-returning (Block B's docs tools fetch
   asynchronously); these protocol tests drive it synchronously with
   [Lwt_main.run]. *)
let handle body =
  match Lwt_main.run (Ocamlorg_mcp.handle body) with
  | Some s -> Yojson.Safe.from_string s
  | None -> `Null

let member k = function `Assoc l -> List.assoc_opt k l | _ -> None
let member_exn k j = match member k j with Some v -> v | None -> `Null

let req ?id method_ params =
  let fields =
    [ ("jsonrpc", `String "2.0"); ("method", `String method_) ]
    @ (match id with Some i -> [ ("id", `Int i) ] | None -> [])
    @ match params with Some p -> [ ("params", p) ] | None -> []
  in
  Yojson.Safe.to_string (`Assoc fields)

let check_string = Alcotest.(check string)

let test_initialize () =
  let resp = handle (req ~id:1 "initialize" None) in
  let result = member_exn "result" resp in
  check_string "protocolVersion" "2025-06-18"
    (match member_exn "protocolVersion" result with
    | `String s -> s
    | _ -> "<none>");
  check_string "serverInfo.name" "ocaml.org"
    (match member_exn "serverInfo" result |> member_exn "name" with
    | `String s -> s
    | _ -> "<none>")

let test_tools_list () =
  let resp = handle (req ~id:2 "tools/list" None) in
  let tools =
    match member_exn "result" resp |> member_exn "tools" with
    | `List l -> l
    | _ -> []
  in
  Alcotest.(check int) "one tool" 1 (List.length tools);
  check_string "tool name" "ping"
    (match List.nth tools 0 |> member_exn "name" with
    | `String s -> s
    | _ -> "<none>")

let test_tools_call () =
  let params = `Assoc [ ("name", `String "ping"); ("arguments", `Assoc []) ] in
  let result =
    handle (req ~id:3 "tools/call" (Some params)) |> member_exn "result"
  in
  (match member_exn "isError" result with
  | `Bool b -> Alcotest.(check bool) "not error" false b
  | _ -> Alcotest.fail "missing isError");
  let text =
    match member_exn "content" result with
    | `List (block :: _) -> (
        match member_exn "text" block with `String s -> s | _ -> "")
    | _ -> ""
  in
  check_string "pong" "pong" text

let test_unknown_tool () =
  (* An unknown tool name is a protocol error (JSON-RPC invalid params), not an
     in-band tool-execution error. *)
  let params = `Assoc [ ("name", `String "nope") ] in
  let code =
    match
      handle (req ~id:4 "tools/call" (Some params))
      |> member_exn "error" |> member_exn "code"
    with
    | `Int c -> c
    | _ -> 0
  in
  Alcotest.(check int) "invalid params" (-32602) code

let test_unknown_method () =
  let code =
    match
      handle (req ~id:5 "bogus" None) |> member_exn "error" |> member_exn "code"
    with
    | `Int c -> c
    | _ -> 0
  in
  Alcotest.(check int) "method not found" (-32601) code

let test_notification_no_reply () =
  Alcotest.(check bool)
    "no reply" true
    (Lwt_main.run
       (Ocamlorg_mcp.handle
          (Yojson.Safe.to_string
             (`Assoc
               [
                 ("jsonrpc", `String "2.0");
                 ("method", `String "notifications/initialized");
               ])))
    = None)

let test_invalid_json () =
  let code =
    match handle "not json" |> member_exn "error" |> member_exn "code" with
    | `Int c -> c
    | _ -> 0
  in
  Alcotest.(check int) "parse error" (-32700) code

(* --- Rate limiter (Phase 2): fixed-window per-IP, time injected. --- *)

module Rl = Ocamlorg_mcp.Rate_limiter

let is_ok = function `Ok -> true | `Limited _ -> false

let test_rate_limit_window () =
  let t = Rl.create ~max_requests:3 ~window_seconds:60. () in
  (* Three requests in the window pass, the fourth is limited. *)
  List.iter
    (fun i ->
      Alcotest.(check bool)
        (Printf.sprintf "req %d ok" i)
        true
        (is_ok (Rl.check t ~now:0. ~ip:"1.2.3.4")))
    [ 1; 2; 3 ];
  (match Rl.check t ~now:0. ~ip:"1.2.3.4" with
  | `Limited retry ->
      Alcotest.(check bool) "retry_after positive" true (retry > 0.)
  | `Ok -> Alcotest.fail "fourth request should be limited");
  (* A different IP has its own budget. *)
  Alcotest.(check bool)
    "other ip ok" true
    (is_ok (Rl.check t ~now:0. ~ip:"5.6.7.8"))

let test_rate_limit_strip_port () =
  (* The IP key must drop the source port, else a fresh port per connection
     defeats the limiter. *)
  Alcotest.(check string)
    "ipv4:port" "127.0.0.1"
    (Rl.strip_port "127.0.0.1:55732");
  Alcotest.(check string) "bracketed v6" "::1" (Rl.strip_port "[::1]:443");
  Alcotest.(check string)
    "bare v6 kept" "2001:db8::1"
    (Rl.strip_port "2001:db8::1");
  Alcotest.(check string) "bare ipv4 kept" "10.0.0.1" (Rl.strip_port "10.0.0.1")

let test_rate_limit_reset () =
  let t = Rl.create ~max_requests:1 ~window_seconds:60. () in
  Alcotest.(check bool) "first ok" true (is_ok (Rl.check t ~now:0. ~ip:"a"));
  Alcotest.(check bool)
    "second limited within window" false
    (is_ok (Rl.check t ~now:30. ~ip:"a"));
  (* After the window elapses, the counter resets. *)
  Alcotest.(check bool)
    "ok after window" true
    (is_ok (Rl.check t ~now:61. ~ip:"a"))

let test_rate_limit_bounded () =
  (* With a tiny [max_entries], expired windows are swept so the table stays
     bounded under IP churn. *)
  let t = Rl.create ~max_entries:2 ~max_requests:1 ~window_seconds:10. () in
  ignore (Rl.check t ~now:0. ~ip:"a");
  ignore (Rl.check t ~now:0. ~ip:"b");
  (* At now=100 both prior windows have expired; inserting a third IP triggers a
     sweep instead of unbounded growth. *)
  ignore (Rl.check t ~now:100. ~ip:"c");
  Alcotest.(check bool) "table bounded" true (Rl.entries t <= 2)

(* --- Cache (Phase 2): bounded FIFO + TTL, time injected. --- *)

module C = Ocamlorg_mcp.Cache

let test_cache_hit_miss () =
  let t = C.create ~max_entries:8 ~ttl:60. in
  let calls = ref 0 in
  let compute () =
    incr calls;
    `String "v"
  in
  let _ = C.find_or_compute t ~now:0. ~key:"k" compute in
  let _ = C.find_or_compute t ~now:1. ~key:"k" compute in
  Alcotest.(check int) "computed once" 1 !calls

let test_cache_expiry () =
  let t = C.create ~max_entries:8 ~ttl:10. in
  let calls = ref 0 in
  let compute () =
    incr calls;
    `Int !calls
  in
  let _ = C.find_or_compute t ~now:0. ~key:"k" compute in
  (* Past the TTL: recompute. *)
  let _ = C.find_or_compute t ~now:11. ~key:"k" compute in
  Alcotest.(check int) "recomputed after ttl" 2 !calls

let test_cache_eviction () =
  let t = C.create ~max_entries:2 ~ttl:1000. in
  let stored k = C.find_or_compute t ~now:0. ~key:k (fun () -> `String k) in
  let _ = stored "a" in
  let _ = stored "b" in
  let _ = stored "c" in
  (* "a" (oldest) evicted when "c" pushed the table over the cap; recomputing
     "a" bumps the call count, proving it was dropped. *)
  let recomputed = ref false in
  let _ =
    C.find_or_compute t ~now:0. ~key:"a" (fun () ->
        recomputed := true;
        `String "a")
  in
  Alcotest.(check bool) "oldest evicted" true !recomputed

(* --- Backend SSRF allowlist (Phase 2). --- *)

module B = Ocamlorg_mcp.Backend

let test_backend_allowlist () =
  let t = B.create [ "https://dill.caelum.ci.dev/profiles/full/docs/" ] in
  (match B.check_url t "https://dill.caelum.ci.dev/p/foo/index.html" with
  | Ok _ -> ()
  | Error e -> Alcotest.fail ("expected allow, got: " ^ e));
  (match B.check_url t "https://evil.example.com/x" with
  | Error _ -> ()
  | Ok _ -> Alcotest.fail "off-list host should be rejected");
  match B.check_url t "http://dill.caelum.ci.dev/x" with
  | Error _ -> ()
  | Ok _ -> Alcotest.fail "non-https should be rejected"

(* --- Tool injection (Phase 3): the registry is [ping] plus tools injected by
   the web layer. Here we inject a dummy tool directly, without pulling package
   data into this isolated library's tests. --- *)

let handle_tools ?cache tools body =
  match Lwt_main.run (Ocamlorg_mcp.handle ?cache ~tools body) with
  | Some s -> Yojson.Safe.from_string s
  | None -> `Null

let dummy_tool : Ocamlorg_mcp.Tool.t =
  {
    name = "echo";
    description = "test tool";
    input_schema =
      `Assoc [ ("type", `String "object"); ("properties", `Assoc []) ];
    handler =
      (fun _ -> Lwt.return (Ok [ Ocamlorg_mcp.Tool.text_content "hello" ]));
    cacheable = false;
  }

let tool_names tools =
  List.filter_map
    (fun t -> match member_exn "name" t with `String s -> Some s | _ -> None)
    tools

let test_injected_tools_list () =
  let resp = handle_tools [ dummy_tool ] (req ~id:10 "tools/list" None) in
  let tools =
    match member_exn "result" resp |> member_exn "tools" with
    | `List l -> l
    | _ -> []
  in
  Alcotest.(check int) "ping + injected" 2 (List.length tools);
  let names = tool_names tools in
  Alcotest.(check bool) "has ping" true (List.mem "ping" names);
  Alcotest.(check bool) "has injected echo" true (List.mem "echo" names)

let test_injected_tool_call () =
  let params = `Assoc [ ("name", `String "echo"); ("arguments", `Assoc []) ] in
  let result =
    handle_tools [ dummy_tool ] (req ~id:11 "tools/call" (Some params))
    |> member_exn "result"
  in
  (match member_exn "isError" result with
  | `Bool b -> Alcotest.(check bool) "not error" false b
  | _ -> Alcotest.fail "missing isError");
  let text =
    match member_exn "content" result with
    | `List (block :: _) -> (
        match member_exn "text" block with `String s -> s | _ -> "")
    | _ -> ""
  in
  check_string "echo text" "hello" text

(* --- Async handlers + cache-only-on-success (Block B). A cacheable tool's
   handler may be asynchronous and may fail transiently; a successful result is
   served from the cache on the next identical call, but an in-band error is
   never cached. --- *)

let is_error result =
  match member_exn "isError" result with `Bool b -> b | _ -> false

(* A cacheable tool whose async handler fails the first time then succeeds,
   counting its invocations so the test can prove errors are not cached. *)
let flaky_tool calls : Ocamlorg_mcp.Tool.t =
  {
    name = "flaky";
    description = "fails once, then succeeds";
    input_schema =
      `Assoc [ ("type", `String "object"); ("properties", `Assoc []) ];
    handler =
      (fun _ ->
        incr calls;
        Lwt.return
          (if !calls = 1 then Error "transient"
           else Ok [ Ocamlorg_mcp.Tool.text_content "ok" ]));
    cacheable = true;
  }

let call_flaky ?cache calls =
  let params = `Assoc [ ("name", `String "flaky"); ("arguments", `Assoc []) ] in
  handle_tools ?cache
    [ flaky_tool calls ]
    (req ~id:20 "tools/call" (Some params))
  |> member_exn "result"

let test_async_error_not_cached () =
  let cache = C.create ~max_entries:8 ~ttl:1000. in
  let calls = ref 0 in
  let first = call_flaky ~cache calls in
  Alcotest.(check bool) "first call errors" true (is_error first);
  let second = call_flaky ~cache calls in
  (* The error was not cached, so the handler ran again and now succeeds. *)
  Alcotest.(check bool) "second call recomputed" false (is_error second);
  Alcotest.(check int) "handler ran twice" 2 !calls

let test_async_success_cached () =
  let cache = C.create ~max_entries:8 ~ttl:1000. in
  let calls = ref 0 in
  let _ = call_flaky ~cache calls in
  (* calls = 1 (error). Succeed and cache on the second call... *)
  let _ = call_flaky ~cache calls in
  (* calls = 2 (success, cached). A third identical call is served from
     cache. *)
  let _ = call_flaky ~cache calls in
  Alcotest.(check int) "success served from cache" 2 !calls

let () =
  Alcotest.run "ocamlorg_mcp"
    [
      ( "dispatch",
        [
          Alcotest.test_case "initialize" `Quick test_initialize;
          Alcotest.test_case "tools/list" `Quick test_tools_list;
          Alcotest.test_case "tools/call ping" `Quick test_tools_call;
          Alcotest.test_case "unknown tool" `Quick test_unknown_tool;
          Alcotest.test_case "unknown method" `Quick test_unknown_method;
          Alcotest.test_case "notification" `Quick test_notification_no_reply;
          Alcotest.test_case "invalid json" `Quick test_invalid_json;
        ] );
      ( "rate_limiter",
        [
          Alcotest.test_case "window" `Quick test_rate_limit_window;
          Alcotest.test_case "strip_port" `Quick test_rate_limit_strip_port;
          Alcotest.test_case "reset" `Quick test_rate_limit_reset;
          Alcotest.test_case "bounded" `Quick test_rate_limit_bounded;
        ] );
      ( "cache",
        [
          Alcotest.test_case "hit/miss" `Quick test_cache_hit_miss;
          Alcotest.test_case "expiry" `Quick test_cache_expiry;
          Alcotest.test_case "eviction" `Quick test_cache_eviction;
        ] );
      ( "backend",
        [ Alcotest.test_case "allowlist" `Quick test_backend_allowlist ] );
      ( "injection",
        [
          Alcotest.test_case "tools/list includes injected" `Quick
            test_injected_tools_list;
          Alcotest.test_case "tools/call dispatches to injected" `Quick
            test_injected_tool_call;
        ] );
      ( "async",
        [
          Alcotest.test_case "in-band error is not cached" `Quick
            test_async_error_not_cached;
          Alcotest.test_case "successful result is cached" `Quick
            test_async_success_cached;
        ] );
    ]
