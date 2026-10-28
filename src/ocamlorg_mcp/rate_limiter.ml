(* Per-origin rate limiting for the MCP endpoint (issue #3775, Phase 2). A
   fixed-window in-memory counter keyed on client IP: at most [max_requests]
   requests per [window_seconds] window per IP. The endpoint is public and
   no-auth, so this is the abuse guard that keeps agent fan-out from starving
   the shared service until an isolated deployment lands.

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
  max_entries : int; (* hard cap on distinct IPs tracked, to bound memory *)
  trust_xff : bool;
      (* Honour [X-Forwarded-For] for the bucket key. Only safe when a trusted
         edge proxy sets or sanitises the header; off by default. *)
  table : (string, window) Hashtbl.t;
  mutable last_sweep : float; (* last time [sweep_expired] ran, to amortise it *)
}

let create ?(max_entries = 100_000) ?(trust_xff = false) ~max_requests
    ~window_seconds () =
  {
    max_requests;
    window_seconds;
    max_entries;
    trust_xff;
    table = Hashtbl.create 1024;
    last_sweep = neg_infinity;
  }

(* Number of distinct IPs currently tracked (exposed for tests). *)
let entries t = Hashtbl.length t.table

(* Drop every window that has fully expired at [now]. Called when the table hits
   its cap so IP churn cannot grow it without bound. The full [Hashtbl.fold] is
   O(n), so it is amortised to at most once per second: under sustained
   distinct-key churn at the cap, an attacker would otherwise force a full scan
   per request (a CPU amplifier). [last_sweep] gates the scan; between scans the
   hard-cap eviction in [check] keeps the table bounded. *)
let sweep_min_interval = 1.0

let sweep_expired t ~now =
  if now -. t.last_sweep >= sweep_min_interval then (
    t.last_sweep <- now;
    let expired =
      Hashtbl.fold
        (fun ip w acc ->
          if now -. w.start >= t.window_seconds then ip :: acc else acc)
        t.table []
    in
    List.iter (Hashtbl.remove t.table) expired)

(* Evict one arbitrary tracked window. Used to keep [max_entries] a *hard* cap
   when a sweep frees nothing (all windows still fresh): without this the table
   would grow past the cap for the rest of the window under spoofed-key
   churn. *)
let evict_one t =
  match Hashtbl.to_seq_keys t.table () with
  | Seq.Cons (ip, _) -> Hashtbl.remove t.table ip
  | Seq.Nil -> ()

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
      (* No window, or the previous one has expired: start a fresh one. At the
         cap, sweep expired windows; if that frees nothing (all still fresh),
         evict one so [max_entries] stays a hard bound rather than a soft
         one. *)
      if Hashtbl.length t.table >= t.max_entries then (
        sweep_expired t ~now;
        if Hashtbl.length t.table >= t.max_entries then evict_one t);
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

(* Client IP for rate-limit bucketing. Defaults to the immediate peer
   ([Dream.client]): [X-Forwarded-For] is client-spoofable, so trusting it lets
   a client mint a fresh bucket per request by varying the header, bypassing the
   limiter entirely.

   When [trust_xff] is set — only safe behind an edge proxy that itself sets or
   sanitises the header — we read [X-Forwarded-For] but take the *rightmost*
   entry, i.e. the hop our own proxy appended. Proxies append the peer they saw,
   so the rightmost entry is the one address the client cannot forge; the
   leftmost is fully client-controlled. *)
let client_ip ~trust_xff request =
  let peer =
    if trust_xff then
      match Dream.header request "X-Forwarded-For" with
      | Some xff -> (
          match List.rev (String.split_on_char ',' xff) with
          | last :: _ when String.trim last <> "" -> String.trim last
          | _ -> Dream.client request)
      | None -> Dream.client request
    else Dream.client request
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
  match check t ~now ~ip:(client_ip ~trust_xff:t.trust_xff request) with
  | `Ok -> handler request
  | `Limited retry_after -> too_many_requests ~retry_after
