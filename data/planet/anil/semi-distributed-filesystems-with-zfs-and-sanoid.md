---
title: Semi distributed filesystems with ZFS and Sanoid
description:
url: https://anil.recoil.org/notes/syncoid-sanoid-zfs
date: 2025-04-05T00:00:00-00:00
preview_image:
authors:
- Anil Madhavapeddy
source:
ignore: true
---

<p>Over in my <a href="https://www.cst.cam.ac.uk/research/eeg">EEG</a> group, we have a <em>lot</em> of primary and secondary datasets lying around: 100s of terabytes of <a href="https://anil.recoil.org/projects/rsn">satellite imagery</a>, <a href="https://anil.recoil.org/projects/life">biodiversity data</a>, <a href="https://anil.recoil.org/projects/ce">academic literature</a>, and the intermediate computations that go along with them. Our trusty central shared storage server running <a href="https://www.truenas.com">TrueNAS</a> stores data in <a href="https://en.wikipedia.org/wiki/ZFS">ZFS</a> and serves it over <a href="https://en.wikipedia.org/wiki/Network_File_System">NFSv4</a> to a bunch of hosts. This is rapidly becoming a bottleneck as our group and datasets grow, and <a href="https://tarides.com/blog/author/mark-elvers/" class="contact">Mark Elvers</a> has been steadily adding <a href="https://www.tunbury.org/kingston-drives/">lots more raw capacity</a>.  The question now is how to configure this raw SSD capacity into a more nimble storage setup.  If anyone's seen any systems similar to the one sketched out below, I'd love to hear from you.</p>
<h2>Why get rid of NFS?</h2>
<p>The first design constraint is to get rid of centralised network storage. This is both slow when compared to a modern NVMEs, and also hard to extend beyond the <a href="https://anil.recoil.org/papers/2015-sosp-sibylfs">POSIX-ish</a> API to take advantage of filesystem-specific features like snapshots or <a href="https://docs.rs/reflink/latest/reflink/">reflink clones</a>. We also don't take much advantage of the simultaneous use of the network storage. Instead, we'd like to just make every host materialise the portion of storage it needs locally by cloning it from the remote server.</p>
<p>The alternative I'm considering here is to use ZFS filesystems on the nodes themselves rather than NFS. This has the upside of having the cloned data be directly available on the local disk of the host that's using it, meaning that there's no performance impact as with networked storage.  ZFS also scales fairly enormous sizes, and so it seems likely that we won't run into an upper bound due to this choice of filesystem in the medium term.</p>
<p>ZFS operates through the creation of a <a href="https://wiki.ubuntu.com/ZFS/ZPool">zpool</a> across a block of disks, over which <a href="https://blog.victormendonca.com/2020/11/03/zfs-for-dummies/">datasets</a> can be created in a tree. One of our typical research servers looks like this:</p>
<pre><code>$ zfs list
NAME               USED  AVAIL  REFER  MOUNTPOINT
eeg               20.4T  7.37T  7.84T  /eeg
eeg/gbif          8.55T  7.37T  8.55T  /eeg/gbif
eeg/logs/fetcher  11.3G  7.37T  8.41G  /eeg/logs/fetcher
eeg/logs/zotero   12.2G  7.37T  8.29G  /eeg/logs/zotero
eeg/papers/doi    3.11T  7.37T  3.11T  /eeg/papers/doi
eeg/papers/pmc     843G  7.37T   843G  /eeg/papers/pmc
eeg/papers/tei    87.4G  7.37T  85.8G  /eeg/papers/tei
eeg/repology      5.92G  7.37T  5.92G  /eeg/repolo
</code></pre>
<p>Inside the <code>eeg</code> zpool, each of the sub-datasets can themselves be arranged in a hierarchy. Each of them can also have key-value labels and separate properties attached to them, and inherit their parent datasets properties. There are a <a href="https://openzfs.github.io/openzfs-docs/man/master/7/zfsprops.7.html">vast number of ZFS properties</a> that can be tuned.</p>
<h2>Snapshots and replication with Sanoid</h2>
<p>Once a single host has some important data in a local ZFS dataset, I've started using <a href="https://github.com/jimsalterjrs/sanoid">Sanoid</a> for the snapshot management:</p>
<blockquote>
<p>Sanoid is a policy-driven snapshot management tool for ZFS filesystems [...] you can use it to make your systems functionally immortal via automated snapshot management and over-the-air replication.</p>
</blockquote>
<p>The first use of Sanoid is to regularly take ZFS snapshots of important filesystems. These snapshots will be rotated regularly at different intervals, and subsequently replicated off-host.  Here's an example <code>/etc/sanoid/sanoid.conf</code> from the machine above.</p>
<pre><code>[eeg/papers/doi]
        use_template = production
[eeg/papers/pmc]
        use_template = production
[eeg/papers/tei]
        use_template = production

[template_production]
        frequently = 0
        hourly = 24
        daily = 30
        monthly = 3
        yearly = 0
        autosnap = yes
        autoprune = yes
</code></pre>
<p>This <code>sanoid.conf</code> establishes a "production" template that keeps 24 hourly snapshots, 30 daily ones and 3 monthly ones. After some time passes, I can verify this by checking the local filesystem snapshots.</p>
<pre><code>$ zfs list -t snapshot
NAME                                            USED  AVAIL  REFER  MOUNTPOINT
eeg/p/doi@2024122101                            134M      -  1.19T  -
eeg/p/doi@2024122102                            45.3M     -  1.19T  -
eeg/p/doi@autosnap_2025-02-01_00:00:02_monthly  224M      -  2.84T  -
eeg/p/doi@autosnap_2025-03-01_00:00:02_monthly  173M      -  3.11T  -
eeg/p/doi@autosnap_2025-03-08_00:00:03_daily    173M      -  3.11T  -
eeg/p/doi@autosnap_2025-03-09_00:00:01_daily    0B        -  3.11T  -
eeg/p/doi@autosnap_2025-03-10_00:00:02_daily    0B        -  3.11T  -
eeg/p/doi@autosnap_2025-03-11_00:00:02_daily    0B        -  3.11T  -
&lt;...etc&gt;
</code></pre>
<p>These snapshots are incremental, and each subsequent one uses only the differential space taken up by the earlier ones. See this <a href="https://zedfs.com/all-you-have-to-know-about-reading-zfs-disk-usage/">handy guide</a> for the meaning of the different space accounting terms above.</p>
<p>Once happy with the production template, I then automate it within cron:</p>
<pre><code>* * * * * TZ=Europe/London /usr/bin/sanoid --cron
</code></pre>
<p>This currently runs every minute (a little wasteful), in order to quickly check if any snapshots are required. Once happy with the hourly cadence working as expected, I'll drop this back to an <code>@hourly</code> job.</p>
<h2>Replicating the ZFS snapshots</h2>
<p>Once Sanoid is merrily making snapshots on the active host, it's also necessary to replicate this off the host for robustness. Since we're not using a networked store, I'd like to replicate the snapshots onto two other hosts, one of which is offsite.
Crucially, these backup hosts can have their <em>own</em> sanoid configuration with a longer-term horizon of backups (e.g. keeping some yearly snapshots). To make this work, we first use a sister tool <a href="https://github.com/jimsalterjrs/sanoid?tab=readme-ov-file#syncoid"><code>syncoid</code></a> that is included in the Sanoid distribution.</p>
<p>I run <code>syncoid</code> in 'pull mode', which means that the backup server is configured to be able to SSH into the production server(s) in order to fetch the datasets.  Under the hood, syncoid uses a combination of ZFS <a href="https://forums.truenas.com/t/zfs-bookmarks-and-why-you-dont-use-them-but-should/5578">bookmarks</a> and <a href="https://xai.sh/2018/08/27/zfs-incremental-backups.html">send/recv</a> to incrementally and efficiently transmit the snapshots over the network and reconstruct the filesystems locally.</p>
<p>Once the SSH host keys are configured in the usual way, a series of crontab entries like this is sufficient to fetch all the remote snapshots to the local host. The backup host that's doing the pulling just needs to run <code>syncoid</code> regularly:</p>
<pre><code>@daily /usr/sbin/syncoid backup@marpe:eeg/papers/doi eeg/papers/doi
@daily /usr/sbin/syncoid backup@marpe:eeg/papers/tei eeg/papers/tei
</code></pre>
<p>At this point, the backup host now has all the snapshots from the live host (including hourly ones), and can then run Sanoid again in order to decide which ones it wants to keep locally. I haven't put too much effort into optimising these yet, but you can see they're different from the ones above.</p>
<pre><code>[eeg/papers]
        use_template = backup
        recursive = yes

[template_backup]
        autoprune = yes
        frequently = 0
        hourly = 30
        daily = 90
        monthly = 12
        yearly = 0
        autosnap = no
</code></pre>
<p>These will keep a few more hourly snapshots, and three times the number of daily snapshots available on the backup servers, in case a rollback is needed. Since the backup server typically has a lot more raw capacity than the live server, it's practical to do this there rather than on the production hosts.</p>
<p>Finally, we can also hook this up to our monitoring scripts with a handy <a href="https://www.nagios.org/">Nagios</a>-compatible interface.</p>
<pre><code># sanoid --monitor-health
OK ZPOOL eeg : ONLINE {Size:30.6T Free:2.44T Cap:92%}
</code></pre>
<h2>Should we use ZFS root volumes?</h2>
<p>It's a bit trickier to figure out if the root volume of the hosts should be ZFS. This requires that the boot initrd always has a working ZFS kernel module, which sometimes goes wrong on updates if the DKMS shim falters for some reason. In terms of specific distributions:</p>
<ul>
<li>Ubuntu in theory supports ZFS with all its kernels, but <a href="https://discourse.ubuntu.com/t/future-of-zfs-on-ubuntu-desktop/33001/19?u=d0od">the long term future</a> of ZFS root on Ubuntu is in <a href="https://www.omgubuntu.co.uk/2023/01/ubuntu-zfs-support-status">question</a>. <a href="https://tarides.com/blog/author/mark-elvers/" class="contact">Mark Elvers</a> has got <a href="https://www.tunbury.org/ubuntu-with-zfs-root/">detailed instructions</a> on how to automate this with an <a href="https://gist.github.com/mtelvers/2cbeb5e35f43f5e461aa0c14c4a0a6b8">Ansible playbook</a>.</li>
<li>Debian only packages <a href="https://wiki.debian.org/ZFS">ZFS via DKMS</a> due to the CDDL <a href="https://sfconservancy.org/blog/2016/feb/25/zfs-and-linux/">licensing concerns</a>.</li>
<li>Alpine also has good <a href="https://wiki.alpinelinux.org/wiki/ZFS">ZFS support</a>, including <a href="https://wiki.alpinelinux.org/wiki/Root_on_ZFS_with_native_encryption">encrypted root</a>.</li>
</ul>
<p>For my own personal servers, I've been using a normal ext4 root volume, and creating a ZFS for the remainder of the disk, without using LVM underneath it. It's a bit less flexible, but strikes a balance between performance and flexibility.</p>
<h2>Next steps</h2>
<p>This basic setup is sufficient to have pull-based ZFS snapshot and replication across multiple hosts, and making it easy to quickly materialise a ZFS dataset onto a given host for use in data processing.  It still needs a bunch of development to turn this into a properly robust system though:</p>
<ul>
<li><strong>Dynamic dataset construction:</strong> One downside is that you must create the right ZFS dataset structure ahead of time, since you can't send/receive arbitary filesystem subtrees. I'm not sure if it's easy to <code>zfs create</code> into an existing subdirectory of a dataset and have it copy the files within there semi-automatically into the new sub-dataset.</li>
<li><strong>Backing up into encrypted volumes:</strong> One of the coolest features of ZFS is that it can maintain <em>unmounted</em> and <em>encrypted at rest</em> datasets. It's therefore possible to have unencrypted data on the production servers (so no performance hit), with more secure-at-rest encryption on the backup servers. However, <a href="https://mtlynch.io/zfs-encrypted-backups/">it requires some messing around</a> to figure out the right runes.</li>
<li><strong>Discovery of datasets in a cluster:</strong> We also need a way of knowing which datasets have been backed up to which hosts. This way, if a host in a cluster needs a particular dataset, it can request it from the other host. Given we probably have 1000s of datasets (as opposed to potentially millions of snapshotS), this doesn't seem like too difficult a problem. We may even be able to use a <a href="https://irmin.org">Irmin</a> database or a DNS-based broadcast mechanism to do this easily within a cluster.</li>
<li><strong>Switching from ZFS to XFS locally:</strong> While ZFS seems like the ideal replication filesystem, it still lacks some of the cooler local features like <a href="https://github.com/openzfs/zfs/issues/405#issuecomment-1880208374">XFS reflinks</a>. It would be nice to find an efficient way to materialise an XFS filesystem from a ZFS base, but without copying absolutely everything. This is either impossibly difficult or really easy via some cunning use of <a href="https://en.wikipedia.org/wiki/OverlayFS">overlayfs</a>. Probably impossible though, given how much block-level information is needed to do deduplication.</li>
<li><strong>ZFS labels for policy:</strong> Most ZFS tools use custom key/value labels on datasets to implement policies. For example, a <code>syncoid:sync</code> label can be used to tell syncoid to include a particular recursive dataset in its replication. There are some scalability limits in just how many labels you can add before slowing a machine down a crawl (though not as bad as how many live mounts). <a href="https://patrick.sirref.org" class="contact">Patrick Ferris</a> started some WIP <a href="https://github.com/quantifyearth/ocaml-zfs">ocaml-zfs</a> bindings to <a href="https://github.com/openzfs/zfs/blob/master/include/libzfs.h">libzfs</a> to help explore this question.</li>
</ul>
<p>So lots of work left to do here, but quite good fun as systems hacking goes! When <a href="https://tarides.com/blog/author/mark-elvers/" class="contact">Mark Elvers</a> is <a href="https://www.tunbury.org/kingston-drives/">done installing</a> our new drives, we'll have a few petabytes of raw capacity to implement this system over...</p>

