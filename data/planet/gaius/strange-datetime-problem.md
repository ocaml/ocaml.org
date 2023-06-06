---
title: Strange Datetime Problem
description: "While working on my unit tests, I came across a sporadic failure in
  inserting and selecting Datetimes to the database, so I wrote a quick test harness
  to see what\u2019s going on: This fails about\u2026"
url: https://gaius.tech/2013/08/17/strange-datetime-problem/
date: 2013-08-17T19:59:55-00:00
preview_image: https://gaiustech.files.wordpress.com/2018/07/cropped-lynx.jpg?w=180
featured:
authors:
- gaius
---

<p>While working on my unit tests, I came across a sporadic failure in inserting and selecting Datetimes to the database, so I wrote a quick test harness to see what&rsquo;s going on:</p>
<pre class="brush: fsharp; title: ; notranslate">
open Ociml
open Printf

let () = 
  let lda =  oralogon &quot;ociml_test/ociml_test&quot; in
  let sth = oraopen lda in
  for i = 0 to 100 do
    orasql sth &quot;truncate table test_date&quot;;
    let d = (Datetime (localtime (Random.float (time() *. 2.)))) in
    oraparse sth &quot;insert into test_date values (:1)&quot;;
    orabind sth (Pos 1) d;
    oraexec sth;
    oracommit lda;
    orasql sth &quot;select * from test_date&quot;;
    let rs = orafetch sth in
    match (rs.(0) = d) with
    |true -&gt; print_endline (sprintf &quot;Inserted %s, got %s, OK&quot; (orastring d) (orastring rs.(0)))
    |false -&gt; print_endline (sprintf &quot;Inserted %s, got %s &lt;-------- FAIL&quot; (orastring d) (orastring rs.(0)))
  done
</pre>
<p>This fails about 3% of the time, for reasons I cannot fathom, there seems to be no correlation with summer time. Here&rsquo;s a set of results incase anyone else can figure it out:</p>
<pre class="brush: plain; collapse: true; gutter: false; light: false; title: Result of running the above script; toolbar: true; notranslate">

gaius@debian7:~/Projects/ociml$ o
        Objective Caml version 3.12.1

	OCI*ML 0.3 built against OCI 11.2

not connected &gt; #use &quot;tests/date_grinder.ml&quot;;;
Inserted 31-Jul-1993 20:21:44, got 31-Jul-1993 20:21:44, OK
Inserted 01-Mar-2022 09:17:53, got 01-Mar-2022 09:17:53, OK
Inserted 18-Jan-1995 05:48:57, got 18-Jan-1995 05:48:57, OK
Inserted 24-Jul-2024 14:10:44, got 24-Jul-2024 14:10:44, OK
Inserted 12-Jan-1991 12:32:01, got 12-Jan-1991 12:32:01, OK
Inserted 03-Nov-2018 18:26:46, got 03-Nov-2018 18:26:46, OK
Inserted 13-Dec-1901 20:45:52, got 13-Dec-1901 20:45:52, OK
Inserted 08-Jan-2036 17:58:34, got 08-Jan-2036 17:58:34, OK
Inserted 31-May-2001 07:29:34, got 31-May-2001 07:29:34, OK
Inserted 13-Dec-1901 20:45:52, got 13-Dec-1901 20:45:52, OK
Inserted 07-Aug-1986 04:59:54, got 07-Aug-1986 04:59:54, OK
Inserted 08-Mar-2036 15:19:15, got 08-Mar-2036 15:19:15, OK
Inserted 23-Mar-1975 09:36:54, got 23-Mar-1975 09:36:54, OK
Inserted 26-Aug-1998 10:39:15, got 26-Aug-1998 10:39:15, OK
Inserted 23-Jan-1985 13:23:09, got 23-Jan-1985 13:23:09, OK
Inserted 13-Dec-1901 20:45:52, got 13-Dec-1901 20:45:52, OK
Inserted 02-Dec-2024 12:06:13, got 02-Dec-2024 12:06:13, OK
Inserted 13-Dec-1901 20:45:52, got 13-Dec-1901 20:45:52, OK
Inserted 20-Mar-1985 11:47:15, got 20-Mar-1985 11:47:15, OK
Inserted 25-Oct-1976 20:16:19, got 25-Oct-1976 20:16:19, OK
Inserted 29-Dec-1972 23:46:42, got 29-Dec-1972 23:46:42, OK
Inserted 17-Aug-1993 06:41:06, got 17-Aug-1993 06:41:06, OK
Inserted 26-Sep-2037 23:58:20, got 26-Sep-2037 23:58:20, OK
Inserted 15-Aug-1994 07:44:57, got 15-Aug-1994 07:44:57, OK
Inserted 13-Dec-1901 20:45:52, got 13-Dec-1901 20:45:52, OK
Inserted 13-Sep-2022 23:14:04, got 13-Sep-2022 23:14:04, OK
Inserted 23-Mar-2031 15:29:59, got 23-Mar-2031 15:29:59, OK
Inserted 27-Dec-1983 21:15:25, got 27-Dec-1983 21:15:25, OK
Inserted 29-Feb-2032 06:55:03, got 29-Feb-2032 06:55:03, OK
Inserted 17-Jan-2019 10:58:15, got 17-Jan-2019 10:58:15, OK
Inserted 13-Dec-1901 20:45:52, got 13-Dec-1901 20:45:52, OK
Inserted 09-Oct-2031 21:33:34, got 09-Oct-2031 21:33:34, OK
Inserted 21-Aug-2023 20:31:46, got 21-Aug-2023 20:31:46, OK
Inserted 20-Sep-1992 16:30:21, got 20-Sep-1992 16:30:21, OK
Inserted 11-Nov-1970 10:00:13, got 11-Nov-1970 09:00:13 &lt;-------- FAIL
Inserted 24-Feb-1984 20:46:46, got 24-Feb-1984 20:46:46, OK
Inserted 19-May-2005 00:45:39, got 19-May-2005 00:45:39, OK
Inserted 22-Apr-1986 05:51:55, got 22-Apr-1986 05:51:55, OK
Inserted 10-Apr-1987 11:32:32, got 10-Apr-1987 11:32:32, OK
Inserted 28-May-2016 15:43:58, got 28-May-2016 15:43:58, OK
Inserted 13-Dec-1901 20:45:52, got 13-Dec-1901 20:45:52, OK
Inserted 11-Feb-2033 01:03:55, got 11-Feb-2033 01:03:55, OK
Inserted 10-Jul-2031 19:50:26, got 10-Jul-2031 19:50:26, OK
Inserted 13-Dec-1901 20:45:52, got 13-Dec-1901 20:45:52, OK
Inserted 23-Nov-1982 04:12:36, got 23-Nov-1982 04:12:36, OK
Inserted 13-Dec-1901 20:45:52, got 13-Dec-1901 20:45:52, OK
Inserted 11-May-2009 21:59:43, got 11-May-2009 21:59:43, OK
Inserted 13-Dec-1901 20:45:52, got 13-Dec-1901 20:45:52, OK
Inserted 07-Jun-2007 01:11:58, got 07-Jun-2007 01:11:58, OK
Inserted 13-Dec-1901 20:45:52, got 13-Dec-1901 20:45:52, OK
Inserted 14-Mar-2002 06:34:51, got 14-Mar-2002 06:34:51, OK
Inserted 09-Nov-2009 06:40:03, got 09-Nov-2009 06:40:03, OK
Inserted 30-Jul-2037 06:55:44, got 30-Jul-2037 06:55:44, OK
Inserted 26-Nov-2030 21:14:53, got 26-Nov-2030 21:14:53, OK
Inserted 05-Sep-1996 15:14:24, got 05-Sep-1996 15:14:24, OK
Inserted 07-Apr-1980 11:34:26, got 07-Apr-1980 11:34:26, OK
Inserted 02-Jan-2037 18:55:00, got 02-Jan-2037 18:55:00, OK
Inserted 14-Mar-1977 15:07:19, got 14-Mar-1977 15:07:19, OK
Inserted 16-Oct-1995 01:51:15, got 16-Oct-1995 01:51:15, OK
Inserted 04-Aug-1990 06:50:10, got 04-Aug-1990 06:50:10, OK
Inserted 13-Dec-1901 20:45:52, got 13-Dec-1901 20:45:52, OK
Inserted 23-May-2021 16:00:23, got 23-May-2021 16:00:23, OK
Inserted 17-Aug-1982 02:21:05, got 17-Aug-1982 02:21:05, OK
Inserted 27-Aug-2013 20:52:49, got 27-Aug-2013 20:52:49, OK
Inserted 13-Dec-2027 14:10:48, got 13-Dec-2027 14:10:48, OK
Inserted 13-Dec-1901 20:45:52, got 13-Dec-1901 20:45:52, OK
Inserted 29-Jun-2025 02:53:11, got 29-Jun-2025 02:53:11, OK
Inserted 24-Jul-2031 23:54:31, got 24-Jul-2031 23:54:31, OK
Inserted 15-Mar-1971 21:08:49, got 15-Mar-1971 20:08:49 &lt;-------- FAIL
Inserted 27-Apr-1981 21:35:54, got 27-Apr-1981 21:35:54, OK
Inserted 22-Dec-2008 19:00:03, got 22-Dec-2008 19:00:03, OK
Inserted 13-Dec-1901 20:45:52, got 13-Dec-1901 20:45:52, OK
Inserted 11-Feb-1986 09:25:28, got 11-Feb-1986 09:25:28, OK
Inserted 24-Mar-1971 12:46:15, got 24-Mar-1971 11:46:15 &lt;-------- FAIL
Inserted 13-Dec-1901 20:45:52, got 13-Dec-1901 20:45:52, OK
Inserted 29-Sep-2016 04:41:02, got 29-Sep-2016 04:41:02, OK
Inserted 03-Dec-2000 09:58:00, got 03-Dec-2000 09:58:00, OK
Inserted 10-Dec-1991 18:08:10, got 10-Dec-1991 18:08:10, OK
Inserted 13-Dec-1901 20:45:52, got 13-Dec-1901 20:45:52, OK
Inserted 13-Dec-1901 20:45:52, got 13-Dec-1901 20:45:52, OK
Inserted 29-Oct-1999 04:17:24, got 29-Oct-1999 04:17:24, OK
Inserted 21-Oct-1988 14:15:16, got 21-Oct-1988 14:15:16, OK
Inserted 27-May-2022 04:21:34, got 27-May-2022 04:21:34, OK
Inserted 16-Oct-1982 05:25:39, got 16-Oct-1982 05:25:39, OK
Inserted 19-Nov-1998 14:57:54, got 19-Nov-1998 14:57:54, OK
Inserted 29-Jun-1975 10:06:11, got 29-Jun-1975 10:06:11, OK
Inserted 13-Dec-1901 20:45:52, got 13-Dec-1901 20:45:52, OK
Inserted 02-Jul-1996 03:08:55, got 02-Jul-1996 03:08:55, OK
Inserted 13-Dec-1901 20:45:52, got 13-Dec-1901 20:45:52, OK
Inserted 17-Jan-2016 17:46:01, got 17-Jan-2016 17:46:01, OK
Inserted 28-Feb-1993 16:57:25, got 28-Feb-1993 16:57:25, OK
Inserted 21-Dec-1977 16:54:30, got 21-Dec-1977 16:54:30, OK
Inserted 05-Mar-2003 12:58:52, got 05-Mar-2003 12:58:52, OK
Inserted 03-Jul-2023 17:06:21, got 03-Jul-2023 17:06:21, OK
Inserted 13-Dec-1901 20:45:52, got 13-Dec-1901 20:45:52, OK
Inserted 06-Aug-1981 02:57:40, got 06-Aug-1981 02:57:40, OK
Inserted 17-Nov-1983 23:55:58, got 17-Nov-1983 23:55:58, OK
Inserted 17-Mar-1999 22:40:16, got 17-Mar-1999 22:40:16, OK
Inserted 04-Oct-2023 18:55:54, got 04-Oct-2023 18:55:54, OK
Inserted 28-Feb-1991 09:52:00, got 28-Feb-1991 09:52:00, OK
Inserted 13-Dec-1901 20:45:52, got 13-Dec-1901 20:45:52, OK
</pre>
<p>The only thing I can see is that they&rsquo;re near the Unix epoch, but why would that cause it to be exactly 1 hour out&hellip;? The latest version of the code is <a href="https://github.com/gaiustech/ociml">up on Github</a>. The underlying C code is in <code>oci_types.c</code>.</p>
<p>Anyway, at least this illustrates the value of soak-testing with randomly generated data &ndash; I had never experienced this issue &ldquo;in the wild&rdquo;, not has it been reported. </p>
<p><strong>Update</strong>: Fixed! Was a double-application of <code>localtime</code>. I never noticed it because at the company I was at when I wrote this, there was a policy of all machines everywhere in the world being in GMT all year round! The epoch thing was a red herring. I suppose the moral of the story is make sure your random data is really random&hellip;</p>

