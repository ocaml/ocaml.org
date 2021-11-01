---
title: Streams
description: >
  Streams offer an abstraction over consuming items from sequences
users:
  - beginner
  - intermediate
tags: [ "stdlib" ]
date: 2021-05-27T21:07:30-00:00
---

Suppose you need to process each line of a text file. One way to do this
is to read the file in as a single large string and use something like
`Str.split` to turn it into a list. This works when the file is small,
but because the entire file is loaded into memory, it does not scale
well when the file is large.

More commonly, the `input_line` function can be used to read one line at
a time from a channel. This typically looks like:

```ocaml
let in_channel = open_in "lines.txt" in
try
  while true do
    let line = input_line in_channel in
    (* do something with line *)
  done
with End_of_file ->
  close_in in_channel
```
```mdx-error
Line 6, characters 5-9:
Error: Syntax error
```

The above code is efficient with memory, but it can be inconvenient in
other ways. Since `input_line` only works with the `in_channel` type, it
cannot be reused in cases where the text is already in memory. The
`End_of_file` exception can be raised at any point during iteration, and
it is the programmer's responsibility to ensure that the file is closed
appropriately. In fact, if there is any other exception in the above
example, the file will not be closed at all. Altogether, there is a lot
going on: channels, I/O, exceptions, and files.

Streams offer an abstraction over one part of this process: reading
items from a sequence. They don't assume anything about files or
channels, and they replace the `End_of_file` exception with a more
structured approach to dealing with the end of input. Here is a function
that builds a stream of lines from an input channel:

```ocaml
# let line_stream_of_channel channel =
  Stream.from
    (fun _ ->
       try Some (input_line channel) with End_of_file -> None);;
val line_stream_of_channel : in_channel -> string Stream.t = <fun>
```
The "Stream.from" function builds a stream from a callback function.
This function is passed the current stream count (starting with 0) as an
argument and is expected to return an `'a option`. If the option has a
value (`Some x`), that value will be the next item in the stream. If it
has no value (`None`), this indicates that the stream is empty and no
further reads will be attempted. Since the option is polymorphic,
`Stream.from` can construct streams of any type. These streams have a
type of `'a Stream.t`.

With this simple function, we can now easily construct line streams from
any input channel:

```ocaml
# let in_channel = open_in "020_streams.md";;
val in_channel : in_channel = <abstr>
# let lines = line_stream_of_channel in_channel;;
val lines : string Stream.t = <abstr>
```

This variable `lines` is a stream of strings, one string per line. We
can now begin reading lines from it by passing it to `Stream.next`:

```ocaml
# Stream.next lines;;
- : string = "---"
# Stream.next lines;;
- : string = "title: Streams"
# Stream.next lines;;
- : string = "description: >"
# Stream.next lines;;
- : string =
"  Streams offer an abstraction over consuming items from sequences"
# while true do ignore(Stream.next lines) done;;
Exception: Stdlib.Stream.Failure.
```

As you can see, `Stream.next` either returns the next item in the stream
or raises a `Stream.Failure` exception indicating that the stream is
empty. Likewise, with a little help from the `Stream.of_list`
constructor and the `Str` regular expression module, we could build a
stream of lines from a string in memory:

```ocaml
# #load "str.cma";;
# let line_stream_of_string string =
  Stream.of_list (Str.split (Str.regexp "\n") string);;
val line_stream_of_string : string -> string Stream.t = <fun>
```
and these streams could be used exactly the same way:

```ocaml
# let lines = line_stream_of_string "hello\nstream\nworld";;
val lines : string Stream.t = <abstr>
# Stream.next lines;;
- : string = "hello"
# Stream.next lines;;
- : string = "stream"
# Stream.next lines;;
- : string = "world"
# Stream.next lines;;
Exception: Stdlib.Stream.Failure.
```

Since both cases raise `Stream.Failure` on an empty stream, there is no
need to worry about catching `End_of_file` in the case of file I/O. This
unified interface makes it much easier to write functions that can
receive data from multiple sources.

The `Stream.iter` function automates the common task of performing an
operation for each item. With it, we can rewrite the original example as
follows:

```ocaml
let in_channel = open_in "020_streams.md" in
try
  Stream.iter
    (fun line ->
       (* do something with line *)
       print_endline line)
    (line_stream_of_channel in_channel);
  close_in in_channel
with e ->
  close_in in_channel;
  raise e
```

Note how much easier it is to handle I/O exceptions properly, since we
can deal with them independently from the end-of-file condition. This
separation of concerns allows us to decompose this into simpler and more
reusable functions:

```ocaml
# let process_line line =
  print_endline line;;
val process_line : string -> unit = <fun>

# let process_lines lines =
  Stream.iter process_line lines;;
val process_lines : string Stream.t -> unit = <fun>

# let process_file filename =
  let in_channel = open_in filename in
  try
    process_lines (line_stream_of_channel in_channel);
    close_in in_channel
  with e ->
    close_in in_channel;
    raise e;;
val process_file : string -> unit = <fun>

# let process_string string =
  process_lines (line_stream_of_string string);;
val process_string : string -> unit = <fun>
```

## Constructing streams
In the above examples, we saw two methods for constructing streams:

* Stream.from, which builds a stream from a callback function
* Stream.of_list, which builds a stream from a list in memory

The `Stream` module provides a few other stream builders:

* Stream.of_string, which builds a character stream from a string
* Stream.of_channel, which builds a character stream from a channel

`Stream.from` is the most general, and it can be used to produce streams
of any type. It is not limited to I/O and can even produce infinite
sequences. Here are a few simple stream builders defined with
`Stream.from`:

```ocaml
# let empty_stream () = Stream.from (fun _ -> None);;
val empty_stream : unit -> 'a Stream.t = <fun>
# let const_stream k = Stream.from (fun _ -> Some k);;
val const_stream : 'a -> 'a Stream.t = <fun>
# let count_stream i = Stream.from (fun j -> Some (i + j));;
val count_stream : int -> int Stream.t = <fun>
```

## Deconstructing streams
We already saw the `Stream.next` function, which retrieves a single item
from a stream. There is another way to work with streams that is often
preferable: `Stream.peek` and `Stream.junk`. When used together, these
functions allow you to see what the next item would be. This feature,
known as "look ahead", is very useful when writing parsers. Even if you
don't need to look ahead, the peek/junk protocol may be nicer to work
with because it uses options instead of exceptions:

```ocaml
# let lines = line_stream_of_string "hello\nworld";;
val lines : string Stream.t = <abstr>
# Stream.peek lines;;
- : string option = Some "hello"
# Stream.peek lines;;
- : string option = Some "hello"
# Stream.junk lines;;
- : unit = ()
# Stream.peek lines;;
- : string option = Some "world"
# Stream.junk lines;;
- : unit = ()
# Stream.peek lines;;
- : string option = None
```

As you can see, it is necessary to call `Stream.junk` to advance to the
next item. `Stream.peek` will always give you either the next item or
`None`, and it will never fail. Likewise, `Stream.junk` always succeeds
(even if the stream is empty).

## A more complex `Stream.from` example
Here is a function that converts a line stream into a paragraph stream.
As such, it is both a stream consumer and a stream producer.

```ocaml
# let paragraphs lines =
  let rec next para_lines i =
    match Stream.peek lines, para_lines with
    | None, [] -> None
    | Some "", [] ->
        Stream.junk lines;
        next para_lines i
    | Some "", _ | None, _ ->
        Some (String.concat "\n" (List.rev para_lines))
    | Some line, _ ->
        Stream.junk lines;
        next (line :: para_lines) i in
  Stream.from (next []);;
val paragraphs : string Stream.t -> string Stream.t = <fun>
```

This function uses an extra parameter to `next` (the `Stream.from`
callback) called `para_lines` in order to collect the lines for each
paragraph. Paragraphs are delimited by any number of blank lines.

Each time `next` is called, a `match` expression tests two values: the
next line in the stream, and the contents of `para_lines`. Four cases
are handled:

1. If the end of the stream is reached and no lines have been
 collected, the paragraph stream ends as well.
1. If the next line is blank and no lines have been collected, the
 blank is ignored and `next` is called recursively to keep looking
 for a non-blank line.
1. If a blank line or end of stream is reached and lines **have** been
 collected, the paragraph is returned by concatenating `para_lines`
 to a single string.
1. Finally, if a non-blank line has been reached, the line is collected
 by recursively calling `para_lines`.

Happily, we can rely on the OCaml compiler's exhaustiveness checking to
ensure that we are handling all possible cases.

With this new tool, we can now work just as easily with paragraphs as we
could before with lines:

```ocaml
(* Print each paragraph, followed by a separator. *)
let lines = line_stream_of_channel in_channel in
Stream.iter
  (fun para ->
     print_endline para;
     print_endline "--")
  (paragraphs lines)
```
Functions like `paragraphs` that produce and consume streams can be
composed together in a manner very similar to UNIX pipes and filters.

## Stream combinators
Just like lists and arrays, common iteration patterns such as `map`,
`filter`, and `fold` can be very useful. The `Stream` module does not
provide such functions, but they can be built easily using
`Stream.from`:

```ocaml
# let stream_map f stream =
  let rec next i =
    try Some (f (Stream.next stream))
    with Stream.Failure -> None in
  Stream.from next;;
val stream_map : ('a -> 'b) -> 'a Stream.t -> 'b Stream.t = <fun>

# let stream_filter p stream =
  let rec next i =
    try
      let value = Stream.next stream in
      if p value then Some value else next i
    with Stream.Failure -> None in
  Stream.from next;;
val stream_filter : ('a -> bool) -> 'a Stream.t -> 'a Stream.t = <fun>

# let stream_fold f stream init =
  let result = ref init in
  Stream.iter
    (fun x -> result := f x !result)
    stream;
  !result;;
val stream_fold : ('a -> 'b -> 'b) -> 'a Stream.t -> 'b -> 'b = <fun>
```
For example, here is a stream of leap years starting with 2000:

```ocaml
# let is_leap year =
  year mod 4 = 0 && (year mod 100 <> 0 || year mod 400 = 0);;
val is_leap : int -> bool = <fun>
# let leap_years = stream_filter is_leap (count_stream 2000);;
val leap_years : int Stream.t = <abstr>
```

We can use the `Stream.npeek` function to look ahead by more than one
item. In this case, we'll peek at the next 30 items to make sure that
the year 2100 is not a leap year (since it's divisible by 100 but not
400!):

```ocaml
# Stream.npeek 30 leap_years;;
- : int list =
[2000; 2004; 2008; 2012; 2016; 2020; 2024; 2028; 2032; 2036; 2040; 2044;
 2048; 2052; 2056; 2060; 2064; 2068; 2072; 2076; 2080; 2084; 2088; 2092;
 2096; 2104; 2108; 2112; 2116; 2120]
```

Note that we must be careful not to use `Stream.iter` on an infinite
stream like `leap_years`. This applies to `stream_fold`, as well as any
function that attempts to consume the entire stream.

```ocaml
# stream_fold (+) (Stream.of_list [1; 2; 3]) 0;;
- : int = 6
```

`stream_fold (+) (count_stream 0) 0` runs forever.

## Other useful stream builders
The previously defined `const_stream` function builds a stream that
repeats a single value. It is also useful to build a stream that repeats
a sequence of values. The following function does just that:

```ocaml
# let cycle items =
  let buf = ref [] in
  let rec next i =
    if !buf = [] then buf := items;
    match !buf with
      | h :: t -> (buf := t; Some h)
      | [] -> None in
  Stream.from next;;
val cycle : 'a list -> 'a Stream.t = <fun>
```

One common task that can benefit from this kind of stream is the
generation of alternating background colors for HTML. By using `cycle`
with `stream_combine`, explained in the next section, an infinite stream
of background colors can be combined with a finite stream of data to
produce a sequence of HTML blocks:

```ocaml
# let stream_combine stream1 stream2 =
  let rec next i =
    try Some (Stream.next stream1, Stream.next stream2)
    with Stream.Failure -> None in
  Stream.from next;;
val stream_combine : 'a Stream.t -> 'b Stream.t -> ('a * 'b) Stream.t = <fun>
# Stream.iter print_endline
  (stream_map
     (fun (bg, s) ->
        Printf.sprintf "<div style='background: %s'>%s</div>" bg s)
     (stream_combine
        (cycle ["#eee"; "#fff"])
        (Stream.of_list ["hello"; "html"; "world"])));;
<div style='background: #eee'>hello</div>
<div style='background: #fff'>html</div>
<div style='background: #eee'>world</div>
- : unit = ()
```
Here is a simple `range` function that produces a sequence of integers:

```ocaml
# let range ?(start=0) ?(stop=0) ?(step=1) () =
  let in_range = if step < 0 then (>) else (<) in
  let current = ref start in
  let rec next i =
    if in_range !current stop
    then let result = !current in (current := !current + step;
                                   Some result)
    else None in
  Stream.from next;;
val range : ?start:int -> ?stop:int -> ?step:int -> unit -> int Stream.t =
  <fun>
```

This works just like Python's `xrange` built-in function, providing an
easy way to produce an assortment of lazy integer sequences by
specifying combinations of `start`, `stop`, or `step` values:

```ocaml
# Stream.npeek 10 (range ~start:5 ~stop:10 ());;
- : int list = [5; 6; 7; 8; 9]
# Stream.npeek 10 (range ~stop:10 ~step:2 ());;
- : int list = [0; 2; 4; 6; 8]
# Stream.npeek 10 (range ~start:10 ~step:(-1) ());;
- : int list = [10; 9; 8; 7; 6; 5; 4; 3; 2; 1]
# Stream.npeek 10 (range ~start:10 ~stop:5 ~step:(-1) ());;
- : int list = [10; 9; 8; 7; 6]
```

## Combining streams
There are several ways to combine streams. One is to produce a stream of
streams and then concatenate them into a single stream. The following
function works just like `List.concat`, but instead of turning a list of
lists into a list, it turns a stream of streams into a stream:

```ocaml
# let stream_concat streams =
  let current_stream = ref None in
  let rec next i =
    try
      let stream =
        match !current_stream with
        | Some stream -> stream
        | None ->
           let stream = Stream.next streams in
           current_stream := Some stream;
           stream in
      try Some (Stream.next stream)
      with Stream.Failure -> (current_stream := None; next i)
    with Stream.Failure -> None in
  Stream.from next;;
val stream_concat : 'a Stream.t Stream.t -> 'a Stream.t = <fun>
```
Here is a sequence of ranges which are themselves derived from a range,
concatenated with `stream_concat` to produce a flattened `int Stream.t`.

```ocaml
# Stream.npeek 10
  (stream_concat
     (stream_map
        (fun i -> range ~stop:i ())
        (range ~stop:5 ())));;
- : int list = [0; 0; 1; 0; 1; 2; 0; 1; 2; 3]
```

Another way to combine streams is to iterate through them in a pairwise
fashion:

```ocaml
# let stream_combine stream1 stream2 =
  let rec next i =
    try Some (Stream.next stream1, Stream.next stream2)
    with Stream.Failure -> None in
  Stream.from next;;
val stream_combine : 'a Stream.t -> 'b Stream.t -> ('a * 'b) Stream.t = <fun>
```
This is useful, for instance, if you have a stream of keys and a stream
of corresponding values. Iterating through key value pairs is then as
simple as:

```ocaml
Stream.iter
  (fun (key, value) ->
     (* do something with 'key' and 'value' *)
     ())
  (stream_combine key_stream value_stream)
```
```mdx-error
Line 5, characters 21-31:
Error: Unbound value key_stream
```
Since `stream_combine` stops as soon as either of its input streams runs
out, it can be used to combine an infinite stream with a finite one.
This provides a neat way to add indexes to a sequence:

```ocaml
# let items = ["this"; "is"; "a"; "test"];;
val items : string list = ["this"; "is"; "a"; "test"]
# Stream.iter
  (fun (index, value) ->
     Printf.printf "%d. %s\n%!" index value)
  (stream_combine (count_stream 1) (Stream.of_list items));;
1. this
2. is
3. a
4. test
- : unit = ()
```

## Copying streams
Streams are destructive; once you discard an item in a stream, it is no
longer available unless you save a copy somewhere. What if you want to
use the same stream more than once? One way is to create a "tee". The
following function creates two output streams from one input stream,
intelligently queueing unseen values until they have been produced by
both streams:

```ocaml
# let stream_tee stream =
  let next self other i =
    try
      if Queue.is_empty self
      then
        let value = Stream.next stream in
        Queue.add value other;
        Some value
      else
        Some (Queue.take self)
    with Stream.Failure -> None in
  let q1 = Queue.create () in
  let q2 = Queue.create () in
  (Stream.from (next q1 q2), Stream.from (next q2 q1));;
val stream_tee : 'a Stream.t -> 'a Stream.t * 'a Stream.t = <fun>
```
Here is an example of a stream tee in action:

```ocaml
# let letters = Stream.of_list ['a'; 'b'; 'c'; 'd'; 'e'];;
val letters : char Stream.t = <abstr>
# let s1, s2 = stream_tee letters;;
val s1 : char Stream.t = <abstr>
val s2 : char Stream.t = <abstr>
# Stream.next s1;;
- : char = 'a'
# Stream.next s1;;
- : char = 'b'
# Stream.next s2;;
- : char = 'a'
# Stream.next s1;;
- : char = 'c'
# Stream.next s2;;
- : char = 'b'
# Stream.next s2;;
- : char = 'c'
```

Again, since streams are destructive, you probably want to leave the
original stream alone or you will lose items from the copied streams:

```ocaml
# Stream.next letters;;
- : char = 'd'
# Stream.next s1;;
- : char = 'e'
# Stream.next s2;;
- : char = 'e'
```

## Converting streams
Here are a few functions for converting between streams and lists,
arrays, and hash tables. These probably belong in the standard library,
but they are simple to define anyhow. Again, beware of infinite streams,
which will cause these functions to hang.

```ocaml
# let stream_of_list = Stream.of_list;;
val stream_of_list : 'a list -> 'a Stream.t = <fun>
# let list_of_stream stream =
  let result = ref [] in
  Stream.iter (fun value -> result := value :: !result) stream;
  List.rev !result;;
val list_of_stream : 'a Stream.t -> 'a list = <fun>
# let stream_of_array array =
  Stream.of_list (Array.to_list array);;
val stream_of_array : 'a array -> 'a Stream.t = <fun>
# let array_of_stream stream =
  Array.of_list (list_of_stream stream);;
val array_of_stream : 'a Stream.t -> 'a array = <fun>
# let stream_of_hash hash =
  let result = ref [] in
  Hashtbl.iter
    (fun key value -> result := (key, value) :: !result)
    hash;
  Stream.of_list !result;;
val stream_of_hash : ('a, 'b) Hashtbl.t -> ('a * 'b) Stream.t = <fun>
# let hash_of_stream stream =
  let result = Hashtbl.create 0 in
  Stream.iter
    (fun (key, value) -> Hashtbl.replace result key value)
    stream;
  result;;
val hash_of_stream : ('a * 'b) Stream.t -> ('a, 'b) Hashtbl.t = <fun>
```

What if you want to convert arbitrary data types to streams? Well, if the
data type defines an `iter` function, and you don't mind using threads,
you can use a producer-consumer arrangement to invert control:

```ocaml
# #directory "+threads";;
# #load "threads.cma";;
# let elements iter coll =
  let channel = Event.new_channel () in
  let producer () =
    let () =
      iter (fun x -> Event.sync (Event.send channel (Some x))) coll in
    Event.sync (Event.send channel None) in
  let consumer i =
    Event.sync (Event.receive channel) in
  ignore (Thread.create producer ());
  Stream.from consumer;;
val elements : (('a -> unit) -> 'b -> unit) -> 'b -> 'a Stream.t = <fun>
```

Now it is possible to build a stream from an `iter` function and a
corresponding value:

```ocaml
# module StringSet = Set.Make(String);;
module StringSet :
  sig
    type elt = string
    type t = Set.Make(String).t
    val empty : t
    val is_empty : t -> bool
    val mem : elt -> t -> bool
    val add : elt -> t -> t
    val singleton : elt -> t
    val remove : elt -> t -> t
    val union : t -> t -> t
    val inter : t -> t -> t
    val disjoint : t -> t -> bool
    val diff : t -> t -> t
    val compare : t -> t -> int
    val equal : t -> t -> bool
    val subset : t -> t -> bool
    val iter : (elt -> unit) -> t -> unit
    val map : (elt -> elt) -> t -> t
    val fold : (elt -> 'a -> 'a) -> t -> 'a -> 'a
    val for_all : (elt -> bool) -> t -> bool
    val exists : (elt -> bool) -> t -> bool
    val filter : (elt -> bool) -> t -> t
    val filter_map : (elt -> elt option) -> t -> t
    val partition : (elt -> bool) -> t -> t * t
    val cardinal : t -> int
    val elements : t -> elt list
    val min_elt : t -> elt
    val min_elt_opt : t -> elt option
    val max_elt : t -> elt
    val max_elt_opt : t -> elt option
    val choose : t -> elt
    val choose_opt : t -> elt option
    val split : elt -> t -> t * bool * t
    val find : elt -> t -> elt
    val find_opt : elt -> t -> elt option
    val find_first : (elt -> bool) -> t -> elt
    val find_first_opt : (elt -> bool) -> t -> elt option
    val find_last : (elt -> bool) -> t -> elt
    val find_last_opt : (elt -> bool) -> t -> elt option
    val of_list : elt list -> t
    val to_seq_from : elt -> t -> elt Seq.t
    val to_seq : t -> elt Seq.t
    val to_rev_seq : t -> elt Seq.t
    val add_seq : elt Seq.t -> t -> t
    val of_seq : elt Seq.t -> t
  end
# let set = StringSet.empty;;
val set : StringSet.t = <abstr>
# let set = StringSet.add "here" set;;
val set : StringSet.t = <abstr>
# let set = StringSet.add "are" set;;
val set : StringSet.t = <abstr>
# let set = StringSet.add "some" set;;
val set : StringSet.t = <abstr>
# let set = StringSet.add "values" set;;
val set : StringSet.t = <abstr>
# let stream = elements StringSet.iter set;;
val stream : string Stream.t = <abstr>
# Stream.iter print_endline stream;;
are
here
some
values
- : unit = ()
```

Some data types, like Hashtbl and Map, provide an `iter` function that
iterates through key-value pairs. Here's a function for those, too:

```ocaml
# let items iter coll =
  let channel = Event.new_channel () in
  let producer () =
    let () =
      iter (fun k v ->
              Event.sync (Event.send channel (Some (k, v)))) coll in
    Event.sync (Event.send channel None) in
  let consumer i =
    Event.sync (Event.receive channel) in
  ignore (Thread.create producer ());
  Stream.from consumer;;
val items : (('a -> 'b -> unit) -> 'c -> unit) -> 'c -> ('a * 'b) Stream.t =
  <fun>
```

If we want just the keys, or just the values, it is simple to transform
the output of `items` using `stream_map`:

```ocaml
# let keys iter coll = stream_map (fun (k, v) -> k) (items iter coll);;
val keys : (('a -> 'b -> unit) -> 'c -> unit) -> 'c -> 'a Stream.t = <fun>
# let values iter coll = stream_map (fun (k, v) -> v) (items iter coll);;
val values : (('a -> 'b -> unit) -> 'c -> unit) -> 'c -> 'b Stream.t = <fun>
```

Keep in mind that these techniques spawn producer threads which carry a
few risks: they only terminate when they have finished iterating, and
any change to the original data structure while iterating may produce
unexpected results.

## Other built-in Stream functions
There are a few other documented methods in the `Stream` module:

* Stream.empty, which raises `Stream.Failure` unless a stream is empty
* Stream.count, which returns the stream count (number of discarded
 elements)

In addition, there are a few undocumented functions: `iapp`, `icons`,
`ising`, `lapp`, `lcons`, `lsing`, `sempty`, `slazy`, and `dump`. They
are visible in the interface with the caveat: "For system use only, not
for the casual user".
