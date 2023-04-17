---
title: Ocamlformat 0.23.0
date: "2022-07-07"
tags: [ocamlformat, platform]
changelog: |
  ### Removed

  - `bench` binary is not distributed anymore to avoid name collisions (#2104, @gpetiot)

  ### Bug fixes

  - Preserve comments around object open/close flag (#2097, @trefis, @gpetiot)
  - Preserve comments around private/mutable/virtual keywords (#2098, @trefis, @gpetiot)
  - Closing parentheses of local open now comply with `indicate-multiline-delimiters` (#2116, @gpetiot)
  - emacs: fix byte-compile warnings (#2119, @syohex)

  ### Changes

  - Use the API of ocp-indent to parse the `.ocp-indent` files (#2103, @gpetiot)
  - JaneStreet profile: set `max-indent = 2` (#2099, @gpetiot)
  - JaneStreet profile: align pattern-matching bar `|` under keyword instead of parenthesis (#2102, @gpetiot)
---

