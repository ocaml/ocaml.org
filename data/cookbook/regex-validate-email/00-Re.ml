---
packages:
  - name: "re"
    tested_version: "1.11.0"
    used_libraries:
      - re
discussion: |
  - **Example:** `re` supports a variety of regex flavors and can be used to create a regular expression to validate email addresses. 
  - **Advantages of `re`:** Re provides better support for regex syntax encountered in other languages such as python.
---

(* an array of sample data for testing *)
let emails =
  [| "oscar.0camel@ocaml.org"
   ; "notAnEmail@jkorg"
   ; "PrivacyFirst@proton.me"
   ; "tommy_trojan@usc.edu"
   ; "emailScammer@evil.lol"
  |]
;;

(* Using the `Re` package create a `Perl` flavor
   regular expression with `re` and `compile` it.*)
let validation_pattern_re = Re.Perl.re "[a-zA-Z0-9.$_!]+@[a-zA-Z0-9]+\\.[a-z]{2,3}"
let email_re = Re.compile validation_pattern_re

(* `validate_email` accepts a regex `pattern` 
    and a string `email` to validate against*)
let validate_email pattern email =
  if Re.execp pattern email
  then Printf.printf "%s has a valid email format\n" email
  else Printf.printf "%s has an invalid email format\n" email
;;

(* map the `validate_email` function to each email in the array `emails`*)
print_endline "Email Verification Results:";
Array.map (fun x -> validate_email email_re x) emails

(* Using `Re` create an `re` pattern to validate for specific top-level domains in an email.
   Notice the `|` opertor at the end of the pattern*)
let validation_domain_pattern_re =
  Re.compile (Re.Perl.re "[a-zA-Z0-9.$_!]+@[a-zA-Z0-9]+\\.[com|org|edu|io|gov|me]")
;;

(* map `validate_email` with the new domain pattern to each email in emails array *)
print_endline "Email Verification Results:";
Array.map (fun x -> validate_email validation_domain_pattern_re x) emails
