(* The simulated opam-repository upstream.

   The server image already holds a full clone of opam-repository at
   [/var/opam-repository]. The sim entrypoint ([entrypoint.sh]) makes a bare,
   object-sharing clone of it at [/tmp/upstream.git], points the server's
   [origin] there and rewinds both to a start commit. The feeder then replays
   [master]'s real first-parent history into [/tmp/upstream.git] by moving its
   [master] ref forward, compressed in time, and the server's own polling ([git
   pull --ff-only origin master]) picks it up exactly as it would in
   production. *)

open Lwt.Syntax

type commit = { sha : string; time : float  (** committer date, Unix time *) }

let clone_path = "/var/opam-repository"
let upstream_path = "/tmp/upstream.git"

let parse_log out =
  Proc.lines out
  |> List.filter_map (fun line ->
         match String.split_on_char ' ' line with
         | [ sha; time ] -> (
             match float_of_string_opt time with
             | Some time -> Some { sha; time }
             | None -> None)
         | _ -> None)
  |> List.rev |> Array.of_list

(* First-parent history of [master] in [image]'s clone, oldest first, restricted
   to the [days] before its tip. The first element is the last commit made
   before the window opens, so the replay starts from a commit that was really
   [master] at that time. *)
let history ~image ~days =
  let+ out =
    Proc.read
      [
        "docker";
        "run";
        "--rm";
        "--entrypoint";
        "git";
        image;
        "-C";
        clone_path;
        "log";
        "--first-parent";
        "--format=%H %ct";
        "master";
      ]
  in
  let all = parse_log out in
  let n = Array.length all in
  if n = 0 then failwith "empty opam-repository history in the image";
  let tip = all.(n - 1).time in
  let since = tip -. (days *. 86400.) in
  let first =
    let rec go i =
      if i + 1 < n && all.(i + 1).time <= since then go (i + 1) else i
    in
    go 0
  in
  Array.sub all first (n - first)

(* Index of the last commit of [h] (sorted oldest first) whose date is at most
   [t], or 0 if they are all later. *)
let select h t =
  let rec go lo hi =
    (* invariant: h.(lo).time <= t or lo = 0, and every index > hi is > t *)
    if lo >= hi then lo
    else
      let mid = (lo + hi + 1) / 2 in
      if h.(mid).time <= t then go mid hi else go lo (mid - 1)
  in
  if Array.length h = 0 then invalid_arg "Upstream.select"
  else go 0 (Array.length h - 1)

(* Feed [h] into the running container: commit [i] becomes upstream's [master]
   at [origin + (time_i - time_0) / speedup], one commit at a time. The schedule
   depends only on the history and the speedup, so every run with the same
   options sees the same upstream states at the same offsets from [origin].
   Moves go through one long-lived shell in the container, so a move costs a
   [git update-ref], not a [docker exec]. *)
let feed_header = [ "t"; "sha"; "commits"; "commit_time"; "planned_t" ]

(* Planned offset of commit [i] from the origin, in seconds. *)
let offset ~h ~speedup i = (h.(i).time -. h.(0).time) /. speedup

let feed ~container ~h ~speedup ~t0 ~origin ~until csv =
  let cmd = ("", [| "docker"; "exec"; "-i"; container; "sh" |]) in
  Lwt_process.with_process_out cmd (fun p ->
      let rec go i =
        if i >= Array.length h then Lwt.return_unit
        else
          let planned = origin +. offset ~h ~speedup i in
          if planned >= until then Lwt.return_unit
          else
            let wait = planned -. Unix.gettimeofday () in
            let* () =
              if wait > 0. then Lwt_unix.sleep wait else Lwt.return_unit
            in
            let* () =
              Lwt_io.write p#stdin
                (Printf.sprintf "git -C %s update-ref refs/heads/master %s\n"
                   upstream_path h.(i).sha)
            in
            let* () = Lwt_io.flush p#stdin in
            Csv.row csv
              [
                Csv.float (Unix.gettimeofday () -. t0);
                h.(i).sha;
                "1";
                Csv.float h.(i).time;
                Csv.float (planned -. t0);
              ];
            go (i + 1)
      in
      go 1)

(* The replayed (compressed) clock: the history date that corresponds to
   wall-clock time [now]. *)
let replay_time ~h ~speedup ~t0 now = h.(0).time +. ((now -. t0) *. speedup)
