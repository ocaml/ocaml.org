---
title: Box Diff Tool
description: Over the weekend, I extended mtelvers/ocaml-box-diff to include the ability
  to upload files over 50MB. This is a more complex API which requires a call to https://upload.box.com/api/2.0/files/upload_sessions
  by posting JSON containing the name of the file, the folder ID and the file size.
  Box replies with various session endpoints which give the URIs to use to upload
  the parts and to commit the the file. Box also specifies the size of each part.
url: https://www.tunbury.org/2025/04/12/box-diff/
date: 2025-04-12T00:00:00-00:00
preview_image: https://www.tunbury.org/images/box-logo.png
authors:
- Mark Elvers
source:
ignore:
---

<p>Over the weekend, I extended <a href="https://github.com/mtelvers/ocaml-box-diff">mtelvers/ocaml-box-diff</a> to include the ability to upload files over 50MB. This is a more complex API which requires a call to <a href="https://upload.box.com/api/2.0/files/upload_sessions">https://upload.box.com/api/2.0/files/upload_sessions</a> by posting JSON containing the name of the file, the folder ID and the file size. Box replies with various <em>session endpoints</em> which give the URIs to use to upload the parts and to commit the the file. Box also specifies the size of each part.</p>

<p>Each part is uploaded with an HTTP PUT of the binary data, with header fields giving the byte range within the overall file along with the SHA for this chunk. Box replies with a part identifier. Once all the parts have been uploaded, an HTTP POST is required to the commit URI, passing a JSON array of all the parts as well as the overall SHA for the file.</p>

<p>I was pleased to be able to reuse <code class="language-plaintext highlighter-rouge">stream_of_file</code>, which was written for the small file upload. Additionally, I was able to keep a running total SHA for the data uploaded so far using <code class="language-plaintext highlighter-rouge">Sha1.update_string ctx chunk</code>, meaning that I did not need to recompute the overall file SHA at the end.</p>
