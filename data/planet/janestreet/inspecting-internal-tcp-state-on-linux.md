---
title: Inspecting Internal TCP State on Linux
description: Sometimes it can be useful to inspect the state of a TCP endpoint. Things
  suchas the current congestion window, the retransmission timeout (RTO), duplicateac...
url: https://blog.janestreet.com/inspecting-internal-tcp-state-on-linux/
date: 2014-07-09T00:00:00-00:00
preview_image: https://blog.janestreet.com/static/img/header.png
featured:
---

<p>Sometimes it can be useful to inspect the state of a TCP endpoint. Things such
as the current congestion window, the retransmission timeout (RTO), duplicate
ack threshold, etc. are not reflected in the segments that flow over the wire.
Therefore, just looking at packet captures can leave you scratching your head as
to why a TCP connection is behaving a certain way.</p>


