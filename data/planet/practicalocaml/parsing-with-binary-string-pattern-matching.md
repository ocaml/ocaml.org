---
title: Parsing with Binary String Pattern Matching
description: If you've ever had to parse anything, (anything really), I want to show
  you a glimpse of what it could look like when you parse it binary string pattern
  matching in OCaml like you'd do on Erlang, Elixir, or Gleam.
url: https://practicalocaml.com/parsing-with-binary-string-pattern-matching/
date: 2023-12-31T21:01:50-00:00
preview_image: https://practicalocaml.com/content/images/size/w1200/2023/12/DALL-E-2023-12-31-21.53.55---A-wide--horizontal-header-image-for-a-blog-post-titled--Parsing-with-Binary-String-Pattern-Matching--Part-1-.-The-image-captures-the-spirit-of-a-deser.png
featured:
authors:
- Practical OCaml
source:
---

<img src="https://practicalocaml.com/content/images/2023/12/DALL-E-2023-12-31-21.53.55---A-wide--horizontal-header-image-for-a-blog-post-titled--Parsing-with-Binary-String-Pattern-Matching--Part-1-.-The-image-captures-the-spirit-of-a-deser.png" alt="Parsing with Binary String Pattern Matching"/><p>If you've ever had to parse anything, (anything really), I want to show you a glimpse of what it could look like when you parse it binary string pattern matching, like you'd do on Erlang, Elixir, or Gleam.</p><p>In OCaml, we can do this with the <code>bitstring</code> package.</p><p>To do this we'll use a small example of something I've had to parse recently: WebSocket Frames.</p><p>A WebSocket frame looks like this:</p><figure class="kg-card kg-code-card"><pre><code>
      0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
     +-+-+-+-+-------+-+-------------+-------------------------------+
     |F|R|R|R| opcode|M| Payload len |    Extended payload length    |
     |I|S|S|S|  (4)  |A|     (7)     |             (16/64)           |
     |N|V|V|V|       |S|             |   (if payload len==126/127)   |
     | |1|2|3|       |K|             |                               |
     +-+-+-+-+-------+-+-------------+ - - - - - - - - - - - - - - - +
     |     Extended payload length continued, if payload len == 127  |
     + - - - - - - - - - - - - - - - +-------------------------------+
     |                               |Masking-key, if MASK set to 1  |
     +-------------------------------+-------------------------------+
     | Masking-key (continued)       |          Payload Data         |
     +-------------------------------- - - - - - - - - - - - - - - - +
     :                     Payload Data continued ...                :
     + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +
     |                     Payload Data continued ...                |
     +---------------------------------------------------------------+

</code></pre><figcaption><p><span style="white-space: pre-wrap;">pretty ascii art for a websocket frame from </span><a href="https://datatracker.ietf.org/doc/html/rfc6455?ref=practicalocaml.com#section-5.2"><span style="white-space: pre-wrap;">rfc6455</span></a></p></figcaption></figure><p>This roughly means:</p><ul><li>1st byte includes the <code>fin</code>, <code>rsv1,2,3</code> and <code>opcode</code> headers</li><li>2nd byte includes a <code>mask</code> and a <code>payload_length</code></li><li>3rd-7th byte includes an extended payload (can be shorter too)</li><li>the byte after that is going to be a masking key</li><li>and then the rest is the actual data you packed in the WebSocket frame</li></ul><p>The way you'd parse this with parse combinators looks a lot like the <a href="https://datatracker.ietf.org/doc/html/rfc6455?ref=practicalocaml.com#page-31">BNF grammar</a> used to describe this packet. Let's look at some code, shall we?</p><p>We'll assume we have a function <code>Frame.make ~fin ~compressed ~rsv ~opcode ~mask ~payload</code> that will create a record of type <code>Frame.t</code>. That part is the least interesting. The interesting thing is how do we get those values.</p><p>Here's how the <code>websocketaf</code> parses this frame using :</p><pre><code class="language-ocaml">(* this example code taken almost verbatim from the `websocketaf`
   opam package.

   I've only amended the last `parse` function to make it more obvious how 
   the parsing is becoming a frame. In practice they do something 
   different after parsing.
*)

(* a Bigstringaf.t (i know, i giggle too) is an efficient type
   for a large string that doesn't have to be copied over and over.

   If you need something similar in your code, consider using Cstruct.t
*)
type t = Bigstringaf.t

(* this function takes a bigstring and checks if the first bit, which
   corresponds to the FIN bit is set *)
let is_fin t =
  let bits = Bigstringaf.unsafe_get t 0 |&gt; Char.code in
  bits land (1 lsl 8) = 1 lsl 8
;;

(* this function extracts the reserverd bits from the bigstring *)
let rsv t =
  let bits = Bigstringaf.unsafe_get t 0 |&gt; Char.code in
  (bits lsr 4) land 0b0111
;;

(* this function creates an int representation for an opcode *)
let opcode t =
  let bits = Bigstringaf.unsafe_get t 0 |&gt; Char.code in
  bits land 0b1111 |&gt; Opcode.unsafe_of_code
;;

(* this function gets the length of the payload.
   and yes that comment was already there.
*)
let payload_length_of_offset t off =
  let bits = Bigstringaf.unsafe_get t (off + 1) |&gt; Char.code in
  let length = bits land 0b01111111 in
  if length = 126 then Bigstringaf.unsafe_get_int16_be t (off + 2)                 else
  (* This is technically unsafe, but if somebody's asking us to read 2^63
   * bytes, then we're already screwd. *)
  if length = 127 then Bigstringaf.unsafe_get_int64_be t (off + 2) |&gt; Int64.to_int else
  length
;;

let payload_length t =
  payload_length_of_offset t 0
;;

(* this function checks if the bigstring has a specific mask set *)
let has_mask t =
  let bits = Bigstringaf.unsafe_get t 1 |&gt; Char.code in
  bits land (1 lsl 7) = 1 lsl 7

(* and this one checks if the mask exists and if so, gets the value *)
let mask t =
  if not (has_mask t) 
  then None
  else
    Some (
      let bits = Bigstringaf.unsafe_get t 1 |&gt; Char.code in
      if bits  = 254 then Bigstringaf.unsafe_get_int32_be t 4  else
      if bits  = 255 then Bigstringaf.unsafe_get_int32_be t 10 else
      Bigstringaf.unsafe_get_int32_be t 2)
;;

(* this computes the offset of the payload in bits *)
let payload_offset_of_bits bits =
  let initial_offset = 2 in
  let mask_offset    = (bits land (1 lsl 7)) lsr (7 - 2) in
  let length_offset  =
    let length = bits land 0b01111111 in
    if length &lt; 126
    then 0
    else 2 lsl ((length land 0b1) lsl 2)
  in
  initial_offset + mask_offset + length_offset
;;

let payload_offset t =
  let bits = Bigstringaf.unsafe_get t 1 |&gt; Char.code in
  payload_offset_of_bits bits
;;


let length_of_offset t off =
  let bits           = Bigstringaf.unsafe_get t (off + 1) |&gt; Char.code in
  let payload_offset = payload_offset_of_bits bits in
  let payload_length = payload_length_of_offset t off in
  payload_offset + payload_length
;;

let length t =
      length_of_offset t 0
  ;;

let apply_mask mask bs ~off ~len =
  for i = off to off + len - 1 do
    let j = (i - off) mod 4 in
    let c = Bigstringaf.unsafe_get bs i |&gt; Char.code in
    let c = c lxor Int32.(logand (shift_right mask (8 * (3 - j))) 0xffl |&gt; to_int) in
    Bigstringaf.unsafe_set bs i (Char.unsafe_chr c)
  done
;;

let unmask_inplace t =
  if has_mask t then begin
    let mask = mask_exn t in
    let len = payload_length t in
    let off = payload_offset t in
    apply_mask mask t ~off ~len
  end
;;

(* this was confusing to me too *)
let mask_inplace = unmask_inplace

let parse =
  let open Angstrom in
  Unsafe.peek 2 (fun bs ~off ~len:_ -&gt; length_of_offset bs off)
  &gt;&gt;= fun len -&gt; Unsafe.take len Bigstringaf.sub
  &gt;&gt;| fun frame -&gt;
      let fin = Websocket.Frame.is_fin frame in
      let opcode = Websocket.Frame.opcode frame in
      unmask_inplace frame;
      let len = payload_length t in
      let off = payload_offset t in
      Frame.make ~fin ~opcode ~payload:(len, off, frame)
;;</code></pre><p>This process begins by defining from the bottom up all the smallest parts we need to use in our final combinator. Only at the very end do we stitch everything together. It also requires us to keep track of several small numbers in different positions to understand what is being read from where.</p><p>If you wanted to run this parser incrementally, you now need an external loop that would normally read something like this:</p><pre><code class="language-ocaml">let parse ?(parser = Frame.parse) data =
  match parser with
  (* check if the parser is currently in a partial state *)
  | Angstrom.Buffered.Partial continue -&gt; (
      (* continue by with the next piece of data *)
      match continue (`Bigstring data) with
      (* if we're done, return our frame *)
      | Angstrom.Buffered.Done (_unconsumed, frame) -&gt; Ok (`frame frame)
      (* handle any parsing errors *)
      | Angstrom.Buffered.Fail (_, _, _) -&gt; Error `bad_frame
      (* otherwise return that we need more data to continue *)
      | parser -&gt; Ok (`more parser))
  | Angstrom.Buffered.Done (_unconsumed, frame) -&gt; Ok (`frame frame)
  | Angstrom.Buffered.Fail (_, _, _) -&gt; Error `bad_frame

(* helper function to read data and continue parsing until we are done
   or until the parser errors *)
let rec read_all_and_parse ?(parser=Frame.parse) () =
  let data = read_data () in
  match parse ~parser data with
  | Ok (`more parser) -&gt; read_all_and_parse ~parser ()
  | Ok (`frame frame) -&gt; Ok frame
  | Error reason -&gt; Error reason
</code></pre><p>Not bad! I kinda like being able to control the parsing incrementally like this. It can make for really efficient code.</p><p>And here's how it can look when pattern matching on binary strings:</p><pre><code class="language-ocaml">let deserialize ?(max_frame_size = 0) data =
  match%bitstring Bitstring.bitstring_of_string data with
  | {| fin : 1;
       compressed : 1;
       rsv : 2;
       opcode : 4;
       pad1 : 1 : check( pad1 = true );
       pad2 : 7 : check( pad2 = 127 );
       length : 64;
       mask : 32;
       payload : Int64.(mul length 8L |&gt; to_int) : string;
       rest : -1 : string |}
    when max_frame_size = 0 || Int64.(length &lt;= of_int max_frame_size) -&gt;
      Some (Frame.make ~fin ~compressed ~rsv ~opcode ~mask ~payload, rest)
      
  | {| fin : 1;
       compressed : 1;
       rsv : 2;
       opcode : 4;
       pad1 : 1 : check( pad1 = true );
       pad2 : 7 : check( pad2 = 126 );
       length : 16 : int;
       mask : 32 : int;
       payload : (length * 8) : string;
       rest : -1 : string |}
    when max_frame_size = 0 || length &lt;= max_frame_size -&gt;
      Some (Frame.make ~fin ~compressed ~rsv ~opcode ~mask ~payload, rest)
      
  | {| fin : 1;
       compressed : 1;
       rsv : 2;
       opcode : 4;
       x : 1 : check( x = true );
       length : 7 : int;
       mask : 32 : int;
       payload : (length * 8) : string;
       rest : -1 : string |}
    when length &lt;= 125 &amp;&amp; (max_frame_size == 0 || length &lt;= max_frame_size) -&gt;
      Some (Frame.make ~fin ~compressed ~rsv ~opcode ~mask ~payload, rest)
      
  | {| data : -1 : string  |} -&gt; Some (`more data, &quot;&quot;)</code></pre><p>This function also takes in a string as data, but it does a much clearer job of outlining what are the valid cases for frames on each matching branch. </p><p>Let's break this down.</p><p>A binary pattern match starts with <code>match%bitstring data with</code> and includes several cases. Every case is a regular OCaml string with the delimiters <code>{| ... |}</code> . The <code>bitstring</code> package will translate this string into a series of operations over the string data. This is why this is more declarative.</p><p>Okay but what goes inside each pattern? </p><p>Roughly every binary pattern follows this format: <code>{| variable : size : type |}</code> and they are all separated by semicolons.</p><p>For example, let's grab the first branch of the match:</p><pre><code class="language-ocaml">{| fin : 1;
   compressed : 1;
   rsv : 2;
   opcode : 4;
   pad1 : 1 : check( pad1 = true );
   pad2 : 7 : check( pad2 = 127 );
   length : 64;
   mask : 32;
   payload : Int64.(mul length 8L |&gt; to_int) : string;
   rest : -1 : string |}</code></pre><p>In here we are saying that:</p><ul><li>the first bit will be captured by the variable <code>fin</code>, </li><li>the second one by the variable <code>compressed</code>, </li><li>the next 2 bits by the variable <code>rsv</code></li><li>the next 4 bits by the variable <code>opcode</code></li><li>the next 1 bit by the variable <code>pad1</code> , and we will check that the variable <code>pad1</code> is true &ndash; since it is a single bit, the library maps this to a <code>bool</code></li><li>the next 7 bits by the variable <code>pad2</code>, and we will check that it is the number 127</li><li>the next 64 bits by the variable <code>length</code></li><li>the next 32 bits by the variable <code>mask</code></li><li>and next <code>length * 8</code> bits by the variable payload &ndash; and we specifically want this to be captured as a string</li><li>the rest of the bits (<code>-1</code>) as a string</li></ul><p>Now compare that to our little diagram and tell me if this, while packed with info, is not easier to double-check that you are in fact parsing the right thing.</p><figure class="kg-card kg-code-card"><pre><code>
      0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
     +-+-+-+-+-------+-+-------------+-------------------------------+
     |F|R|R|R| opcode|M| Payload len |    Extended payload length    |
     |I|S|S|S|  (4)  |A|     (7)     |             (16/64)           |
     |N|V|V|V|       |S|             |   (if payload len==126/127)   |
     | |1|2|3|       |K|             |                               |
     +-+-+-+-+-------+-+-------------+ - - - - - - - - - - - - - - - +
     |     Extended payload length continued, if payload len == 127  |
     + - - - - - - - - - - - - - - - +-------------------------------+
     |                               |Masking-key, if MASK set to 1  |
     +-------------------------------+-------------------------------+
     | Masking-key (continued)       |          Payload Data         |
     +-------------------------------- - - - - - - - - - - - - - - - +
     :                     Payload Data continued ...                :
     + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +
     |                     Payload Data continued ...                |
     +---------------------------------------------------------------+

</code></pre><figcaption><p><span style="white-space: pre-wrap;">pretty ascii art for a websocket frame from </span><a href="https://datatracker.ietf.org/doc/html/rfc6455?ref=practicalocaml.com#section-5.2"><span style="white-space: pre-wrap;">rfc6455</span></a></p></figcaption></figure><p></p><p>With that explained, we can go back to calling our function.</p><p>Since we control the returning values in this function, it is straightforward to fit it into other abstractions that we may be using. For example, we can use it with <code>Seq.unfold</code> to generate a sequence of frames:</p><pre><code class="language-ocaml">Seq.unfold deserialize data
(* `ok frame
   `ok frame
   `more rest *)</code></pre><p>And with a little combinator for sequences, we can make it quite pleasant to incrementally parse over streams of data:</p><pre><code class="language-ocaml">(* reduce a value until we explicitly halt or the sequence is finished *)
let rec reduce_while init fn t =
  match t () with
  | Seq.Nil -&gt; init
  | Seq.Cons (v, t') -&gt; (
      match fn v init with
      | `continue acc -&gt; reduce_while acc fn t'
      | `halt acc -&gt; acc)

(* do an incremental read/parse/handle_frame loop *)
let rec parse data =
  let next =
    Seq.unfold Frame.deserialize data
    |&gt; reduce_while `ok (fun frame state -&gt;
           match (state, frame) with
           | `ok, `more buf -&gt; `halt (`more buf)
           | `ok, `ok frame -&gt; `continue (handle_frame frame)
           | `ok, `error reason -&gt; `halt (`error reason)
           | `error reason, _ -&gt; `halt (`error reason)
           | `more buf, _ -&gt; `halt (`more buf))
  in
  match next with
  | `ok -&gt; Ok ()
  | `error reason -&gt; Error reason
  | `more buffer -&gt;
      let more_data = read_data () in
      parse (buffer ^ more_data)
</code></pre><p>Just to clarify, I'm sure you can fit Angstrom into a <code>Seq.t</code> as well. So this last <code>reduce_while</code> trick isn't a win specifically for binary pattern matching, but having full control over how the parser executes sure helps us build parsers that fit exactly where we need them to.</p><p></p><h2>Conclusion</h2><p>I like binary pattern matching better, it has way less cognitive overhead, it helps me parse instantly what a sequence of bits/bytes would look like, and its recursive descent approach helps me write parsers that fit exactly into the code around them.</p><p>They're not for everything, and some things can be rather painful to parse where you end up using tiny combinators anyway (like &quot;parse all until new line&quot;), but overall I think they're a major improvement in readability and declarativeness over parser combinators.</p><p>If you find this interesting, have a look at <a href="https://bitstring.software/?ref=practicalocaml.com">bitstring</a>. I'll be writing more about this package soon.</p><hr/><p>That's all I've got for today folks, it's the last day of the year and I figured we should end it with one last 2023 issue.</p><p>If you liked what I've written you can support me on <a href="https://github.com/sponsors/leostera?ref=practicalocaml.com">Github Sponsors</a> &#10024;</p><p>Here's to more Practical OCaml in 2024 &#129346; </p><p>Thanks to <a href="https://twitter.com/dillon_mulroy?ref=practicalocaml.com" rel="noreferrer">@dillon_mulroy</a> for reviewing a draft of this post.</p>
