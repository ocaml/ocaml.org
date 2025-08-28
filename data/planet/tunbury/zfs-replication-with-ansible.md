---
title: ZFS Replication with Ansible
description: "Rather than using the agent-based approach proposed yesterday, it\u2019s
  worth considering an Ansible-based solution instead."
url: https://www.tunbury.org/2025/05/16/zfs-replcation-ansible/
date: 2025-05-16T00:00:00-00:00
preview_image: https://www.tunbury.org/images/openzfs.png
authors:
- Mark Elvers
source:
ignore:
---

<p>Rather than using the agent-based approach proposed yesterday, it’s worth considering an Ansible-based solution instead.</p>

<p>Given a set of YAML files on a one-per-dataset basis containing any metadata we would like for administrative purposes, and with required fields such as those below. We can also override any default snapshot and replication frequencies by adding those parameters to the file.</p>

<div class="language-yaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="na">dataset_path</span><span class="pi">:</span> <span class="s2">"</span><span class="s">tank/dataset-02"</span>
<span class="na">source_host</span><span class="pi">:</span> <span class="s2">"</span><span class="s">x86-bm-c1.sw.ocaml.org"</span>
<span class="na">target_host</span><span class="pi">:</span> <span class="s2">"</span><span class="s">x86-bm-c3.sw.ocaml.org”</span>
</code></pre></div></div>

<p>The YAML files would be aggregated to create an overall picture of which datasets must be replicated between hosts. Ansible templates would then generate the necessary configuration files for <code class="language-plaintext highlighter-rouge">synoid</code> and <code class="language-plaintext highlighter-rouge">sanoid</code>, and register the cron jobs on each machine.</p>

<p>Sanoid uses SSH authentication, so the keys must be generated on the source machines, and the public keys must be deployed on the replication targets. Ansible can be used to manage the configuration of the keys.</p>

<p>Given the overall picture, we can automatically generate a markdown document describing the current setup and use Mermaid to include a visual representation.</p>

<p><img src="https://www.tunbury.org/images/zfs-replication-graphic.png" alt=""></p>

<p>I have published a working version of this concept on <a href="https://github.com/mtelvers/zfs-replication-ansible">GitHub</a>. The <a href="https://github.com/mtelvers/zfs-replication-ansible/blob/master/README.md">README.md</a> contains additional information.</p>

<p>The replication set defined in the repository, <a href="https://github.com/mtelvers/zfs-replication-ansible/blob/master/docs/replication_topology.md">ZFS Replication Topology</a>, is currently running for testing.</p>
