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
    ]
