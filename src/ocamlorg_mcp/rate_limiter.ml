(* Per-origin rate limiting for the MCP endpoint (issue #3775, Phase 2). A
   fixed-window in-memory counter keyed on client IP: at most [max_requests]
   requests per rolling [window_seconds] window per IP. The endpoint is public
   and no-auth, so this is the abuse guard that keeps agent fan-out from
   starving the shared service until an isolated deployment lands.

   Why in-app, and how this differs from the in-app response cache ({!Cache}):

   Caching is *forced* in-app. MCP is JSON-RPC over HTTP POST, and stock Varnish
   passes POST uncached (confirmed live in Phase 1). That is a method property —
   the edge cache cannot help a POST without custom VCL — so an in-app cache is
   the only lever we have.

   Rate limiting is *not* forced in-app by that same argument: a proxy sees
   POSTs fine, so an edge rate limiter (Caddy/Varnish) would happily throttle
   MCP traffic. It lives in-app because there is nothing at the edge to fall
   back on today — no VCL/Caddy config in this repo, stock Varnish 6.0 has no
   built-in throttle (it needs a vmod), and standard Caddy has no rate_limit
   directive — and because MCP wants its *own* bucket, independent of website
   traffic (the "isolated deployment" checklist item on #3775).

   End state is defense-in-depth: this MCP-scoped in-app bucket, backstopped by
   a coarse edge limit added later in the external ocurrent-deployer config.

   Dream/Lwt is cooperatively scheduled and [check] is fully synchronous (no
   promise is awaited between the read and the mutation), so the plain [Hashtbl]
   needs no mutex. *)

type window = { start : float; mutable count : int }

type t = {
  max_requests : int;
  window_seconds : float;
  max_entries : int; (* cap on distinct IPs tracked, to bound memory *)
  table : (string, window) Hashtbl.t;
}

let create ?(max_entries = 100_000) ~max_requests ~window_seconds () =
  { max_requests; window_seconds; max_entries; table = Hashtbl.create 1024 }

(* Number of distinct IPs currently tracked (exposed for tests). *)
let entries t = Hashtbl.length t.table

(* Drop every window that has fully expired at [now]. Called when the table hits
   its cap so IP churn cannot grow it without bound. *)
let sweep_expired t ~now =
  let expired =
    Hashtbl.fold
      (fun ip w acc ->
        if now -. w.start >= t.window_seconds then ip :: acc else acc)
      t.table []
  in
  List.iter (Hashtbl.remove t.table) expired

(* [`Ok] if the request is within budget; [`Limited retry_after] with the
   seconds until the current window resets otherwise. Time is injected so the
   core is testable without a clock. *)
let check t ~now ~ip : [ `Ok | `Limited of float ] =
  match Hashtbl.find_opt t.table ip with
  | Some w when now -. w.start < t.window_seconds ->
      if w.count < t.max_requests then (
        w.count <- w.count + 1;
        `Ok)
      else `Limited (w.start +. t.window_seconds -. now)
  | _ ->
      (* No window, or the previous one has expired: start a fresh one. *)
      if Hashtbl.length t.table >= t.max_entries then sweep_expired t ~now;
      Hashtbl.replace t.table ip { start = now; count = 1 };
      `Ok

(* Strip a trailing [:port] so requests from the same host share a bucket.
   [Dream.client] returns ["ip:port"] ([Dream.client] uses ["[v6]:port"] for
   IPv6), and a fresh source port per connection would otherwise make every
   request look like a new client. A bare IPv6 (multiple colons, no port) is
   left untouched. *)
let strip_port s =
  if String.length s > 0 && s.[0] = '[' then
    match String.index_opt s ']' with
    | Some j -> String.sub s 1 (j - 1)
    | None -> s
  else
    match String.rindex_opt s ':' with
    | Some i when not (String.contains (String.sub s 0 i) ':') ->
        String.sub s 0 i (* ipv4:port *)
    | _ -> s

(* Client IP behind the Caddy -> Varnish -> app proxy chain. Those proxies
   append to [X-Forwarded-For], so the leftmost entry is the original client; we
   fall back to the immediate peer. This is best-effort: [X-Forwarded-For] is
   client-spoofable, but Caddy rewrites it at the edge, which is adequate for
   abuse throttling. *)
let client_ip request =
  let peer =
    match Dream.header request "X-Forwarded-For" with
    | Some xff -> (
        match String.split_on_char ',' xff with
        | first :: _ when String.trim first <> "" -> String.trim first
        | _ -> Dream.client request)
    | None -> Dream.client request
  in
  strip_port peer

let too_many_requests ~retry_after =
  Dream.respond ~status:`Too_Many_Requests
    ~headers:
      [
        ("Content-Type", "application/json");
        (* Retry-After is an integer number of seconds; round up. *)
        ("Retry-After", string_of_int (int_of_float (Float.ceil retry_after)));
      ]
    {|{"error":"rate limit exceeded"}|}

let middleware t handler request =
  let now = Unix.gettimeofday () in
  match check t ~now ~ip:(client_ip request) with
  | `Ok -> handler request
  | `Limited retry_after -> too_many_requests ~retry_after
