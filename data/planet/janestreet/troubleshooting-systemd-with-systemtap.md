---
title: Troubleshooting systemd with SystemTap
description: When we set up a schedule on a computer, such as a list of commands torun
  every day at particular times via Linux cronjobs, weexpect that schedule to execute...
url: https://blog.janestreet.com/troubleshooting-systemd-with-systemtap/
date: 2020-02-03T00:00:00-00:00
preview_image: https://blog.janestreet.com/troubleshooting-systemd-with-systemtap/data-taps.jpg
featured:
---

<p>When we set up a schedule on a computer, such as a list of commands to
run every day at particular times via Linux <a href="https://www.ostechnix.com/a-beginners-guide-to-cron-jobs">cron
jobs</a>, we
expect that schedule to execute reliably.  Of course we&rsquo;ll check the
logs to see whether the job has failed, but we never question whether
the cron daemon itself will function.  We always assume that it will,
as it always has done; we are not expecting mutiny in the ranks of the
operating system.</p>


