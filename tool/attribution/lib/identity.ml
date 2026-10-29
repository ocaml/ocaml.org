(* Classify a credited identity (a commit author or a Co-authored-by trailer) as
   a human contributor, an AI tool, or an automation bot.

   The attribution feature exists to disclose authorship honestly: AI assistance
   must surface in the dedicated AI facet rather than masquerade as a human
   author, and mechanical bots are not authors at all. In this repository AI
   help is recorded with the standard "Co-authored-by: Claude <noreply@…>"
   trailer rather than the issue's hypothetical Assisted-by trailer, so both are
   folded into the same AI bucket. *)

type t = Human | Ai | Bot

let ends_with suffix s =
  let ls = String.length s and lsuf = String.length suffix in
  ls >= lsuf && String.sub s (ls - lsuf) lsuf = suffix

let classify ~name ~email =
  let email = String.lowercase_ascii (String.trim email) in
  if
    email = "noreply@anthropic.com" || String.starts_with ~prefix:"Claude " name
  then Ai
  else if
    ends_with "[bot]" name || ends_with " Bot" name
    || ends_with "[bot]@users.noreply.github.com" email
  then Bot
  else Human
