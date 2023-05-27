---
title: Oh! Pascal!
description: I can't help but want to share my joy at coming across this pearl of
  a program from the "Pascal User Manual and Report" - Jensen and Wirth ...
url: http://blog.shaynefletcher.org/2016/04/oh-pascal.html
date: 2016-04-21T15:31:00-00:00
preview_image:
featured:
authors:
- Shayne Fletcher
---

<p>
I can't help but want to share my joy at coming across this pearl of a program from the &quot;Pascal User Manual and Report&quot; - Jensen and Wirth (circa 1974). In my edition, it's program 4.7 (graph1.pas).
</p>
<p>
This is it, rephrased in OCaml.
</p><pre class="prettyprint ml">
(* Graph of f x = exp (-x) * sin (2 * pi * x)

  Program 4.7, Pascal User Manual and Report, Jensen &amp; Wirth
*)

let round (x : float) : int =
  let f, i = 
    let t = modf x in 
    (fst t, int_of_float@@ snd t) in
  if f = 0.0 then i
  else if i &gt;= 0 then
    if f &gt;= 0.5 then i + 1 else i
  else if -.f &gt;= 0.5 then i - 1 else i

let graph (oc : out_channel) : unit =
  (*The x-axis runs vertically...*)
  let s = 32. in (*32 char widths for [y, y + 1]*)
  let h = 34 in (*char position of x-axis*)
  let d = 0.0625 in (*1/16, 16 lines for [x, x + 1]*)
  let c = 6.28318 in (* 2pi *)
  let lim = 32 in
  for i = 0 to lim do
    let x = d *. (float_of_int i) in
    let y = exp (-.x) *. sin (c *. x) in
    let n = round (s *. y) + h in
    for _ = n downto 0 do output_char oc ' '; done;
    output_string oc &quot;*\n&quot;
  done

let () = print_newline (); graph stdout; print_newline ()
</pre>

<p>The output from the above is wonderful :)
</p><pre>
                                   *
                                               *
                                                       *
                                                            *
                                                            *
                                                         *
                                                   *
                                           *
                                   *
                            *
                       *
                    *
                    *
                      *
                          *
                              *
                                   *
                                       *
                                          *
                                            *
                                            *
                                           *
                                         *
                                      *
                                   *
                                *
                               *
                              *
                             *
                              *
                                *
                                 *
                                   *
</pre>

