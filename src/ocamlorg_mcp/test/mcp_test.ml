(* Protocol-level tests for the MCP dispatch (Ocamlorg_mcp.handle). These
   exercise the JSON-RPC handshake and error handling without a running
   server. *)

let handle body =
  match Ocamlorg_mcp.handle body with
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
    (Ocamlorg_mcp.handle
       (Yojson.Safe.to_string
          (`Assoc
            [
              ("jsonrpc", `String "2.0");
              ("method", `String "notifications/initialized");
            ]))
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
    ]
