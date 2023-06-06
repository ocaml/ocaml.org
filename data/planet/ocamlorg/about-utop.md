---
title: "UTop: a much improved interface to the OCaml toplevel"
description: This is a post about the utop toplevel provided in the OPAM repository as an alternative to the standard OCaml one.
date: "2014-08-26"
authors: [ "Jérémie Dimino" ]
---

*This is a post about the `utop` toplevel provided in the OPAM
repository as an alternative to the standard OCaml one.*

OCaml comes with an interactive toplevel. If you type `ocaml` in a
shell you will get a prompt where you can type OCaml code that is
compiled and executed on the fly.

    $ ocaml
        OCaml version 4.02.0+dev12-2014-07-30

    # 1 + 1;;
    - : int = 2

You can load libraries and your own modules in the toplevel, and it is
great for playing with your code. You'll quickly notice that
the user experience is not ideal, as there is no editing support:
you cannot conveniently change what you type nor can you rewind to
previously typed phrases.

This can be improved by using tools such as
[ledit](http://pauillac.inria.fr/~ddr/ledit/) or
[rlwrap](http://freecode.com/projects/rlwrap) which adds line editing
support for any program: `rlwrap ocaml`. This is better but still
doesn't provide fancy features such as context sensitive completion.

That's why [UTop](https://github.com/diml/utop) was started. UTop is a
shiny frontend to the OCaml interactive toplevel, which tries to focus
on the user experience and features:

- interactive line editing
- real-time tab completion of functions and values
- syntax highlighting

And many other things which make life easier for users that have been
added over time.

What does UTop stand for?
--------------------------

UTop stands for `Universal Toplevel`. Universal because it can be used
in a terminal or in Emacs (I originally planned to add a windowed
version using GTK but unfortunately never completed it).

The UTop prompt
---------------

The utop prompt looks much more 'blinky' than the one of the default
toplevel. Install it using OPAM very simply:

    opam install utop
    eval `opam config env`  # may not be needed
    utop

This is typically what you see when you start utop:

    ─( 16:36:52 )─< command 0 >───────────────────────{ counter: 0 }─
    utop #
    ┌───┬────────────┬─────┬───────────┬──────────────┬───────┬─────┐
    │Arg│Arith_status│Array│ArrayLabels│Assert_failure│Big_int│Bigar│
    └───┴────────────┴─────┴───────────┴──────────────┴───────┴─────┘

It displays:

- the time
- the command number
- the macro counter (for Emacs style macros)

The box at the bottom is for completion, which is described in the
next section.

If the colors seem too bright you can type `#utop_prompt_fancy_light`,
which is better for light backgrounds. This can be set permanently by
adding the line to `~/.ocamlinit` or by adding `profile: light` to
`~/.utoprc`.

The prompt can be customized by the user, by setting the reference
`UTop.prompt`:

    utop # UTop.prompt;;
    - : LTerm_text.t React.signal ref = {contents = <abstr>}

`LTerm_text.t` is for styled text while `React.signal` means that it
is a reactive signal, from the
[react](http://erratique.ch/software/react) library. This makes it very
easy to create a prompt where the time is updated every second for
instance.

Real-time completion
--------------------

This is the main feature that motivated the creation of UTop. UTop makes use
of the compiler internals to find possible completions on:

- function names
- function argument names
- constructor names
- record fields
- method names

Instead of the classic way of displaying a list of words when the user
press TAB, I chose to dynamically display the different
possibilities as the user types. This idea comes from the dmenu tool
from the [dwm](http://dwm.suckless.org/) window manager.

The possible completions are displayed in the completion bar below the
prompt. It is possible to navigate in the list by using the meta key
(`Alt` by default most of the time) and the left and right arrows. A
word can be selected by pressing the meta key and `TAB`. Also pressing
just `TAB` will insert the longest common prefix of all possibilities.

Syntax highlighting
-------------------

UTop can do basic syntax highlighting. This is disabled by default but
can be enabled by writing a `~/.utoprc` file. You can copy one from
the repository, either for
[dark background](https://github.com/diml/utop/blob/master/utoprc-dark)
or
[light background](https://github.com/diml/utop/blob/master/utoprc-light).

Emacs integration
-----------------

As said earlier UTop can be run in Emacs. Instructions to set this up
can be found in [UTop's readme](https://github.com/diml/utop). The
default toplevel can also be run this way but UTop is better in the
following respects:

1. it provides context-sensitive completion
2. it behaves like a real shell, i.e. you cannot delete the prompt

They are several Emacs libraries for writing shell-like modes but I
wrote my own because with all of the ones I found it is possible to
insert or remove characters from the prompt, which I found frustrating
Even with the mode used by the Emacs Shell mode it is
possible. AFAIK at the time I wrote it the UTop mode was the only one
where it was really impossible to edit the something in the _frozen_
part of the buffer.

Other features
--------------

This is a non-exhaustive list of features that have been added over
time to enhance the user experience. Some of them might be
controversial, so I tried to choose what was the most requested most of
the time.

- when using the [lwt](http://ocsigen.org/lwt/) or
  [async](https://github.com/janestreet/async) libraries, UTop will
  automatically wait for ['a Lwt.t] or ['a Deferred.t] values and
  return the ['a] instead
- made `-short-paths` the default. This option allow to display
  shorter types when using packed libraries such as
  [core](https://github.com/janestreet/core)
- hide identifiers starting with `_` to the user. This is for hiding
  the churn generated by syntax extensions. This can be disabled with
  `UTop.set_hide_reserved` or with the command line argument
  `-show-reserved`.
- automatically load `camlp4` when the user requests a syntax
  extension. In the default toplevel one has to type `#camlp4` first.
- hide verbose messages from the `findlib` library manager.
- add a `typeof` directive to show the type of modules and values.
- automatically load files from `$OCAML_TOPLEVEL_PATH/autoload` at
  startup.
- allow to specify libraries to be loaded on the command line.

Libraries developed to support UTop
-----------------------------------

For the needs of UTop I wrote
[lambda-term](https://github.com/diml/lambda-term), which is kind of
an equivalent of ncurses+readline, but written in OCaml. It was
written because I wasn't happy with the ncurses API and I wanted something more
fancy than readline, especially for completion. In the end I believe
that it is much more fun to write terminal applications in OCaml using
lambda-term.

The pure editing part is managed by the
[zed](https://github.com/diml/zed) library, which is independent from
the user interface.


UTop development
----------------

Utop is fairly feature-complete, and so I don't spend much time on it
these days. It became the recommended toplevel to use with the 
[Real World OCaml](https://realworldocaml.org) book, and most users
are happier with the interactive interface than using the traditional
toplevel.

Many thanks to [Peter Zotov](https://github.com/whitequark) who recently joined
the project to keep it up-to-date and add new features such as extension point
support. Contributions from others (particularly around editor integration) are
very welcome, so if you are interested on hacking on it get in touch via the
[GitHub issue tracker](https://github.com/diml/utop) or via the [OCaml Platform
mailing list](https://lists.ocaml.org/listinfo/platform).
