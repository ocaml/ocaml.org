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

(* AI is detected by the committer e-mail domain, never by the display name:
   "Claude" is also a common human given name in this community (e.g. Claude
   Marché), so a name heuristic would mis-file a real contributor into the AI
   facet. The repository's convention is the standard "Co-authored-by: Claude …
   <noreply@anthropic.com>" trailer, so the anthropic domain is the reliable
   signal; any other AI tool is credited through the explicit [Assisted-by]
   trailer, which bypasses this classifier entirely. *)
let classify ~name ~email =
  let email = String.lowercase_ascii (String.trim email) in
  if ends_with "@anthropic.com" email then Ai
  else if
    ends_with "[bot]" name || ends_with " Bot" name
    || ends_with "[bot]@users.noreply.github.com" email
  then Bot
  else Human
