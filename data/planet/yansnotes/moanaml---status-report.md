---
title: MoanaML - status report
description: A little bit about everything, but mostly about fixing annoying tech
  problems, interesting posts I stumbled on.
url: http://yansnotes.blogspot.com/2014/10/moanaml-status-report.html
date: 2014-10-23T11:11:00-00:00
preview_image: http://4.bp.blogspot.com/-G2Jz8HOV2Zk/VEkcgRQC9dI/AAAAAAAAWK4/bcqvVhCB2_I/w1200-h630-p-k-no-nu/MoanaML(1).png
featured:
authors:
- Unknown
---

<div dir="ltr" style="text-align: left;" trbidi="on">
I have started to work on implementing <a href="https://mozillaignite.org/apps/411/" target="_blank">Moana</a> key functional primitives in OCaml.<br/>
<br/>
The code is available on github <a href="https://github.com/yansh/MoanaML/" target="_blank">here</a>.<br/>
<br/>
<br/>
<div class="separator" style="clear: both; text-align: center;">
<a href="http://4.bp.blogspot.com/-G2Jz8HOV2Zk/VEkcgRQC9dI/AAAAAAAAWK4/bcqvVhCB2_I/s1600/MoanaML(1).png" imageanchor="1" style="clear: left; float: left; margin-bottom: 1em; margin-right: 1em;"><img src="http://4.bp.blogspot.com/-G2Jz8HOV2Zk/VEkcgRQC9dI/AAAAAAAAWK4/bcqvVhCB2_I/s1600/MoanaML(1).png" border="0" height="320" width="246"/></a></div>
<a href="http://3.bp.blogspot.com/-2Jns5J3WoAA/VEjmjWLTB1I/AAAAAAAAWKg/BZseBCj3jCE/s1600/MoanaML.png" imageanchor="1" style="clear: left; float: left; margin-bottom: 1em; margin-right: 1em;"></a>My last commit included implementation of the <i>join AM BM&nbsp; </i>function which binds the tuples available in AM with the intermediate &quot;solution&quot; tuples in the BM. The concepts are taken from the<a href="http://en.wikipedia.org/wiki/Rete_algorithm" target="_blank"> RETE</a>&nbsp; algorithm. However, unlike <a href="http://en.wikipedia.org/wiki/Rete_algorithm" target="_blank">RETE</a> this&nbsp; is still a &quot;static system&quot;. By that I mean that join operations are performed on pre-populated AMs.<br/>
<br/>
<a href="http://en.wikipedia.org/wiki/Rete_algorithm" target="_blank">RETE</a>'s left/right activations allow for a more dynamic system. The idea is that each time a new tuple is added to an AM <i>right </i>activation is performed which triggers <i>left </i>activation from the BM, a sequence of these activation will lead to a new result in the newly created final BM.<br/>
<br/>
This is my next step...along with writing more unit tests and fixing existing bugs. If you have any cool ideas on how to take MoanaML further feel free to contribute and Pull Request.<br/>
&nbsp; <br/>
<br/>
<br/></div>

