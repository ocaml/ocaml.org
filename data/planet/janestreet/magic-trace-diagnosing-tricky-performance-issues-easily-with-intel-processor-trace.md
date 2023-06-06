---
title: 'Magic-trace: Diagnosing tricky performance issues easily with Intel Processor
  Trace'
description: Intel Processor Trace is a hardware technology that can record allprogram
  execution flow along with timing information accurate toaround 30ns. As far as I
  ca...
url: https://blog.janestreet.com/magic-trace/
date: 2022-01-11T00:00:00-00:00
preview_image: https://blog.janestreet.com/magic-trace/magic-trace-blog-image.jpg
featured:
---

<p>Intel Processor Trace is a hardware technology that can record all
program execution flow along with timing information accurate to
around 30ns. As far as I can tell <a href="https://engineering.fb.com/2021/04/27/developer-tools/reverse-debugging/">a</a><a href="https://easyperf.net/blog/2019/08/23/Intel-Processor-Trace">l</a><a href="https://github.com/nyx-fuzz/libxdc">m</a><a href="https://blog.trailofbits.com/2021/03/19/un-bee-lievable-performance-fast-coverage-guided-fuzzing-with-honeybee-and-intel-processor-trace/">o</a><a href="http://halobates.de/blog/p/410">s</a><a href="https://dl.acm.org/doi/10.1145/3029806.3029830">t</a>
nobody uses it, seemingly because capturing the data is tricky and,
without any visualization tools, you&rsquo;re forced to read enormous text
dumps.</p>


