---
title: How MirageOS Powers Docker Desktop
description:
url: https://mirage.io/blog/2022-04-06.vpnkit
date: 2022-04-06T00:00:00-00:00
preview_image:
featured:
authors:
- Dave Scott
---


        <p><a href="https://www.docker.com/blog/how-docker-desktop-networking-works-under-the-hood/">Recently, I posted</a> about how <a href="https://github.com/moby/vpnkit">vpnkit</a>, built with MirageOS libraries, powers <a href="https://www.docker.com/products/docker-desktop">Docker Desktop</a>. Docker Desktop enables users to build, share and run isolated, <em>containerised</em> applications on either a Mac or Windows environment.
With <a href="https://www.docker.com/blog/docker-raises-series-c-build-share-run/">millions of users</a>, it's the most popular developer tool
on the planet. Hence, <strong>MirageOS networking libraries transparently handle the traffic of millions of containers</strong>, simplifying many developers' experience every day.</p>
<p>Docker initially started as an easy-to-use packaging of the Linux kernel's isolation primitives, such as
<a href="https://en.wikipedia.org/wiki/Linux_namespaces">namespaces</a> and <a href="https://en.wikipedia.org/wiki/Cgroups">cgroups</a>.
Docker made it convenient for developers to encapsulate applications inside containers, protecting the rest of the system from potential bugs, moving them more easily between machines, and sharing them with other developers. Unfortunately, one of the challenges of running Docker on macOS or Windows is that these Linux primitives are unavailable. Docker Desktop goes to great lengths to emulate them without modifying the user experience of running containers. It runs a (light) Linux VM to host the Docker daemon with additional &quot;glue&quot; helpers to connect the Docker client, running on the host, to that VM. While the Linux VM can run Linux
containers, there is often a problem accessing internal company resources. VPN clients are usually configured to allow only
&quot;local&quot; traffic from the host, to prevent the host accidentally routing traffic from the Internet to the internal network, compromising network security. Unfortunately network packets from the Linux VM need to be routed, and so are dropped by default. This
would prevent Linux containers from being able to access resources like internal company registries.</p>
<p>Vpnkit bridges that gap and circumvents these issues by reversing the MirageOS network stack. It reads raw ethernet frames coming out of the Linux VM and translates them into macOS or Windows high-level (socket) syscalls: it keeps the connection states for every running Docker container in the Linux VMs and converts all their network traffic transparently into host traffic. This is possible because the MirageOS stack is highly modular, feature-rich and very flexible with full implementations of:
an <a href="https://github.com/mirage/ethernet">ethernet layer</a>,
<a href="https://github.com/mirage/mirage-vnetif">ethernet switching</a>,
a <a href="https://github.com/mirage/mirage-tcpip">TCP/IP stack</a>,
<a href="https://github.com/mirage/ocaml-dns">DNS</a>,
<a href="https://github.com/mirage/charrua">DHCP</a>,
<a href="https://github.com/mirage/ocaml-cohttp">HTTP</a> etc. The following diagram shows how the Mirage components are connected together:</p>
<p><img src="https://mirage.io/img/blog-VPNKit.png" alt="Image showing the modular structure of vpnkit"/></p>
<p>For a more detailed explanation on how vpnkit works with Docker Desktop, read &ldquo;<a href="https://www.docker.com/blog/how-docker-desktop-networking-works-under-the-hood/">How Docker Desktop Networking Works Under the Hood</a>.&rdquo;</p>

      
