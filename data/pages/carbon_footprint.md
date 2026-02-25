---
title: Carbon Footprint
description: Our engagement to reducing our carbon footprint.
meta_title: OCaml Carbon Footprint Statement
meta_description: OCaml.org engagement to reducing its carbon footprint
---

A recent study from Lancaster University shows that greenhouse gas (GHG) emissions from global computing might be higher than previously thought. The Information and Communication Technology (ICT) sector produces as much as 3.9% of overall GHG, when taking into account the complete
lifecycle from manufacturing through computations. If correct, this is higher than even the aviation industry, which is [around 2%](https://www.sciencedaily.com/releases/2021/09/210910121715.htm).

OCaml maintainers are quite aware of its infrastructure’s environmental impact, especially the machines that build Docker base images, run Continuous Integration (CI) checks, and build and deploy this very website. Nearly 1000 CPU cores hosted in various data centres around the world run
these tasks. While OCaml is open source, these machines don’t run for free. The cost to manufacture and maintain these machines, not to mention the considerable energy used to power them, is significant.

The maintainers are exploring ways to reduce OCaml’s carbon footprint, with the ultimate goal of being carbon neutral. Carbon neutrality refers to the practice of offsetting one’s carbon footprint. For example, after calculating the amount of emissions produced, one offsets the same amount
by investing in projects that aim to reduce emissions. Renewable energy and other similar initiatives show promise toward meeting this goal. Before they can make any hard decisions, they must first better understand OCaml’s environmental impact. This work is already underway. By using
[OCluster](https://github.com/ocurrent/ocluster), a cluster-management tool, they will receive more complete reports, and with this information, they can make decisions that will produce measurable impact.

Some possibilities:

- Better caching and sharing of artefacts, to reduce multiple runs on overlapping jobs. Currently, the OCaml infrastructure tries to re-run jobs on the same machine, which makes hitting caches more likely.
- Although, sometimes jobs are re-run unnecessarily, so there’s talk about inserting an opt-in for a rerun rather than automatically rebuilding.
- Surface the reporting. Since there are multiple jobs running constantly, the more users can get out of the vast amount of data the infrastructure produces, the better.
- Surfacing the environmental metrics to OCaml users

Continuous Integration (CI) is an automated process that checks code as it’s written or revised to ensure things still run smoothly. This takes up a lot of computational power, and therefore energy. OCaml’s “health checks” are a type of CI that rebuilds hundreds of packages against
multiple compilers each time the code is altered. While these tests are useful and somewhat necessary, having better metrics and reports will help the maintainers know how to best manage and conserve the energy usage.

While these solutions are evolving to improve our carbon footprint, the OCaml maintainers are paying for reliable carbon offsets to help mitigate this in the meantime.

In addition to the above solutions, it’s helpful to classify emissions that are essential and nonessential, and ultimately offset or eliminate the latter. Computations necessary for website features and Opam package builds produce essential emissions; however, if architecturally it's doing
something wasteful, like repeatedly building packages and then discarding the results, these tasks create nonessential emissions, which should be modified if not completely discontinued. Unnecessary emissions can be eliminated by unifying and normalising data schema for various services,
adding caches to avoid repeated computations, and ensuring effective HTTP cache control headers for immutable content, which will reduce server load.

Another way to address OCaml’s carbon footprint is to choose “green” data centres with their own progressive carbon neutrality policy, assemble data and ensure the power usage is as healthy as possible, and renewable energy is used whenever possible.

![image info](../media/pages/green-web-foundation-badge.png)
