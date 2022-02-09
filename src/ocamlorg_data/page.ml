

type t =
  { title : string
  ; description : string
  ; meta_title : string
  ; meta_description : string
  ; body_md : string
  ; body_html : string
  }
  

let carbon_footprint = 
  { title = {js|Carbon Footprint|js}
  ; description = {js|Our engagement to reducing our carbon footprint.|js}
  ; meta_title = {js|Carbon Footprint|js}
  ; meta_description = {js|Our engagement to reducing our carbon footprint.|js}
  ; body_md = {js|
A recent study from Lancaster University shows that greenhouse gas (GHG) emissions from global computing might be higher than previously thought. The Information and Communication Technology (ICT) sector produces as much as 3.9% of overall GHG, when taking into account the complete
lifecycle from manufacturing through computations. If correct, this is higher than even the aviation industry, which is [around 2%](https://www.sciencedaily.com/releases/2021/09/210910121715.htm).

OCaml maintainers are quite aware of its infrastructure’s environmental impact, especially the machines that build Docker base images, run Continuous Integration (CI) checks, and build and deploy this very website. Nearly 1000 CPU cores hosted in various data centres around the world run
these tasks. While OCaml is open-source, these machines don’t run for free. The cost to manufacture and maintain these machines, not to mention the considerable energy used to power them, is significant.

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

Another way to address OCaml’s carbon footprint is to choose “green” data centres with their own progressive carbon neutrality policy, assemble data and ensure the power usage is as healthy as possible, and renewable energy is used whenever possible.|js}
  ; body_html = {js|<p>A recent study from Lancaster University shows that greenhouse gas (GHG) emissions from global computing might be higher than previously thought. The Information and Communication Technology (ICT) sector produces as much as 3.9% of overall GHG, when taking into account the complete
lifecycle from manufacturing through computations. If correct, this is higher than even the aviation industry, which is <a href="https://www.sciencedaily.com/releases/2021/09/210910121715.htm">around 2%</a>.</p>
<p>OCaml maintainers are quite aware of its infrastructure’s environmental impact, especially the machines that build Docker base images, run Continuous Integration (CI) checks, and build and deploy this very website. Nearly 1000 CPU cores hosted in various data centres around the world run
these tasks. While OCaml is open-source, these machines don’t run for free. The cost to manufacture and maintain these machines, not to mention the considerable energy used to power them, is significant.</p>
<p>The maintainers are exploring ways to reduce OCaml’s carbon footprint, with the ultimate goal of being carbon neutral. Carbon neutrality refers to the practice of offsetting one’s carbon footprint. For example, after calculating the amount of emissions produced, one offsets the same amount
by investing in projects that aim to reduce emissions. Renewable energy and other similar initiatives show promise toward meeting this goal. Before they can make any hard decisions, they must first better understand OCaml’s environmental impact. This work is already underway. By using
<a href="https://github.com/ocurrent/ocluster">OCluster</a>, a cluster-management tool, they will receive more complete reports, and with this information, they can make decisions that will produce measurable impact.</p>
<p>Some possibilities:</p>
<ul>
<li>Better caching and sharing of artefacts, to reduce multiple runs on overlapping jobs. Currently, the OCaml infrastructure tries to re-run jobs on the same machine, which makes hitting caches more likely.
</li>
<li>Although, sometimes jobs are re-run unnecessarily, so there’s talk about inserting an opt-in for a rerun rather than automatically rebuilding.
</li>
<li>Surface the reporting. Since there are multiple jobs running constantly, the more users can get out of the vast amount of data the infrastructure produces, the better.
</li>
<li>Surfacing the environmental metrics to OCaml users
</li>
</ul>
<p>Continuous Integration (CI) is an automated process that checks code as it’s written or revised to ensure things still run smoothly. This takes up a lot of computational power, and therefore energy. OCaml’s “health checks” are a type of CI that rebuilds hundreds of packages against
multiple compilers each time the code is altered. While these tests are useful and somewhat necessary, having better metrics and reports will help the maintainers know how to best manage and conserve the energy usage.</p>
<p>While these solutions are evolving to improve our carbon footprint, the OCaml maintainers are paying for reliable carbon offsets to help mitigate this in the meantime.</p>
<p>In addition to the above solutions, it’s helpful to classify emissions that are essential and nonessential, and ultimately offset or eliminate the latter. Computations necessary for website features and Opam package builds produce essential emissions; however, if architecturally it's doing
something wasteful, like repeatedly building packages and then discarding the results, these tasks create nonessential emissions, which should be modified if not completely discontinued. Unnecessary emissions can be eliminated by unifying and normalising data schema for various services,
adding caches to avoid repeated computations, and ensuring effective HTTP cache control headers for immutable content, which will reduce server load.</p>
<p>Another way to address OCaml’s carbon footprint is to choose “green” data centres with their own progressive carbon neutrality policy, assemble data and ensure the power usage is as healthy as possible, and renewable energy is used whenever possible.</p>
|js}
  }


let governance = 
  { title = {js|OCaml.org Governance|js}
  ; description = {js|The structure of the OCaml.org project, the roles involved and the responsibilities.|js}
  ; meta_title = {js|OCaml.org Governance|js}
  ; meta_description = {js|The structure of the OCaml.org project, the roles involved and the responsibilities.|js}
  ; body_md = {js|
## Overview and Scope

As the OCaml community continues to grow, more collaborative work is being
undertaken to support and extend the needs of the language and
its users. This document focuses specifically on the
OCaml.org *domain name* and the Projects that make use of that domain name.
It describes the reporting structure, roles involved and the responsibilities.
The aim is to avoid introducing cumbersome processes while still providing a
high degree of transparency.

### Purpose - a document that represents reality

At any given time, this document must reflect the *current reality*.
It is *not* intended to be aspirational nor reflect the kind of structures
that people may expect to see. This is an important point because the utility
of this document is limited to the extent that it represents how things
*really* are, as opposed to how people may *desire* them to be in the future.
As the environment changes, this document should also be updated such that it
consistently reflects how things are.

### Disambiguation - the meaning of OCaml.org

When using the term 'OCaml.org', there is the potential for a number of
different interpretations.  To reduce confusion, these are described below and
the meaning of the term *for this document* is explained.

*Second-level domain name* - This is the domain name we are familiar with,
'OCaml.org', which has associated sub-domains and records (NB: Just for
clarity and edification, the top-level domain here is '.org').

*Community website* - This is the community facing website, which can be found
at [ocaml.org](//ocaml.org) and is often referred to as simply 'OCaml.org'.

*Infrastructure* - This may refer to the virtual machines (VMs), services or
other things that are somehow routed via the second-level domain name itself.
An obvious example is the VM that hosts the community website but another would
be the VMs and systems that host the tarballs and files used by the OPAM
package manager tool.

For the purposes of this document, we take the first meaning — that
this document relates to the governance of the second-level domain,
'OCaml.org'. Therefore, anything that involves use of the domain name in some
form is affected by the governance of the domain name itself. That includes
any public facing webpages, URLs and other resources.
This is important because, in a way, OCaml.org is the sum of the Projects
it hosts.

To avoid confusion between the domain name itself and the community website
Project, the term 'OCaml.org' in this document refers *only* to
the second-level domain name itself. Any references to the domain of the
community website project will include the sub-domain 'www.ocaml.org',
even though this is set to redirect to [ocaml.org](//ocaml.org).

### Guiding principles of OCaml.org

There are certain guiding principles for OCaml.org, which include openness and
a community-focus, that Projects need to be compatible with. These principles
extend to all of the Projects that use the domain OCaml.org.


## Roles

### Owner and Delegates

The Owner of OCaml.org is Xavier Leroy, the lead developer of the OCaml
language. Projects under OCaml.org sub-domains are managed by the
community, meaning that it is the community that actively contributes to the
day-to-day maintenance of any OCaml.org Project, but the general strategic
direction is drawn by the Owner.

It is the role of the Owner to resolve disputes that may arise
in relation to OCaml.org itself, specifically to ensure that the Projects under
OCaml.org are able to progress in a coordinated way.
It is the community's role to guide the decisions of the Owner
through active engagement, contributions and discussions.  To foster a healthy
and growing community, the Owner will make the
goals and decisions clear and public.

It is anticipated that the Projects themselves will be self-managing and will
resolve issues within their communities, without recourse to the Owner.
Where the Owner needs to become involved, he/she will act as arbitrator.

#### Delegates

The Owner may choose to delegate authority to others to manage the domain and
act in the Owner's name, though ownership remains with the Owner.
Those Delegates are free to choose how they arrange themselves, in agreement
with the Owner. In the specific case of disputes, the Delegate(s) will consult
with the Owner, who will act as arbitrator if required.

*Currently, Xavier Leroy has delegated responsibility for OCaml.org to
Anil Madhavapeddy, who has accepted this Role.*

### Maintainers

Projects under OCaml.org will have their own Maintainers, who have commit
access to relevant repositories and are responsible for:
- Managing the specific project.
- Writing code directly to repositories.
- Eliciting and screening the contributions of others.
- Ensuring that the Owners/Delegates are aware of community needs.

Generally, Maintainers only have authority over the specific Projects they are
responsible for though it is expected that Maintainers of different Projects
will collaborate frequently, especially in the case of major changes or
announcements.  Typically, individuals who have made substantive contributions
to a Project will be invited to become Maintainers.

### Contributors

Contributors are wider members of the OCaml community who make valuable
contributions, but generally do not have authority to make direct changes to a
Project's code-base or documentation. Anyone can become a Contributor and there
is no expectation of commitment, no specific skill requirement and no
selection process. The only necessary step is to make or suggest some
improvement or change to the Project.

Contributors can interact with a Project via tools such as email lists, issue
trackers and wiki pages, for example.  The main email list for OCaml.org is
infrastructure@lists.ocaml.org and is open to all. Maintainers are
free to direct discussion to their own dedicated mailing lists, as they feel
appropriate. Those whose contributions become part of a public git repository
will be recognised in some form on a public website as thanks.

It is expected that regular Contributors to specific Projects may be asked if
they wish to become Maintainers, as described above. There is no obligation to
accept such an offer.

### Users

Users are the most important group and it includes the much wider community of
anyone who interacts with OCaml.org in any way.  This covers all web-visitors,
package users, and members of mailing lists. Without Users, the Projects serve
no purpose so the impact of any major decisions on this group should be
assessed.

Wherever practicable, Users should be encouraged to provide feedback and
participate in the Projects as much as possible. Users who engage a lot with a
Project will likely go on to become Contributors. 

It should be noted that these Roles are not mutually exclusive, for example
Maintainers and Contributors are necessarily also Users. 

## Projects

**Definition** - A Project within OCaml.org is characterised by its sub-domain.
It is expected that the majority of new work will fall under an existing
sub-domain and will therefore already have a set of Maintainers and
Contributors (as described above).

**Communication** - All Maintainers of Projects must join the Infrastructure
mailing list (infrastructure@lists.ocaml.org). This list is the primary way
that information and decisions surrounding OCaml.org will be discussed and
disseminated. If Projects wish to set up their own lists, they may do so on
lists.ocaml.org (see below).

**Governance** - Projects are free to choose their mode of governance provided
it is compatible with the governance and guiding principles of OCaml.org.


### Initiating a Project 

Any proposal for new work should be raised and discussed on the Infrastructure
mailing list. If there is consensus among Maintainers that the work fits
within an existing Project, then the Maintainers of that Project can take it
forward. 

If a new sub-domain is required, then a brief proposal
should be made on the Infrastructure list that covers:

- The aims and purpose of the Project (inc name of the sub-domain required).
- Specific resources required and for how long (e.g VMs).
- Any impact on or relation to existing Projects.
- Information about the initial Maintainers.
- Details of proposed licensing arrangements for code/content.

The above information is intended to stimulate discussion so brevity is
preferred. Following discussion, and if the Owner/Delegate agrees, the
resources can be provisioned. There is no obligation for the Owner/Delegate to
provide any resources beyond the sub-domain.

### Closing a Project

A Project can be closed:

- If it has completed its aims and the Maintainers request it be closed down.
- If there are no Maintainers left to continue supporting it and no-one willing
to take on the role.
- By the Owner/Delegate for any reason.

In all cases, prior notice must be sent to the Infrastructure list including a
reasonable time-frame and reasons for closure.
Closure simply implies revocation or redirection of the sub-domain and/or
shutting down or reclaiming any resources provided (e.g VMs). 


## Processes

### Decision Making and Communication

The preferred approach for most discussions is through
[rough consensus and running code](http://en.wikipedia.org/wiki/Rough_consensus).
Discussions should be public and take place on either the Infrastructure
mailing list, the relevant Project mailing-list or on relevant issue trackers.
Users and Contributors are encouraged to take part and voice their opinions.
Typically, the Maintainers of a Project will make the final decision, having
accounted for wider views.

All Projects under OCaml.org are to be documented such that Users can find out
about them and understand both the purpose and how they can contribute.


### Contribution Process and Licensing

Contributions to OCaml.org will primarily be to one or more of its Projects.
Each Project under OCaml.org needs to define a clear contribution process and
licensing agreement so
that Contributors understand how to engage with the Maintainers. Typically,
this will cover where communication occurs and the process for submitting
patches. Contributions from the community are encouraged and can take many
forms including, bug fixes, new features, content or documentation.  

All Projects under OCaml.org are expected to be open-source and the licensing
arrangements should reflect this.

Contributions to OCaml.org itself may be in the form of resources that can be
shared by Projects and can be discussed with Owner/Delegate and Project
Maintainers on the Infrastructure mailing list.

### Dispute resolution

Maintainers are expected to make decisions regarding their Projects.
The intent is for any Maintainers to resolve disagreements, through
a consensus process within each Project.  

On the rare occasions, where Maintainers of a Project cannot agree
on a way forward the following approach is suggested:

- The specific issue(s) will need to be articulated so it is clear what needs
to be discussed.
- Other Maintainers of OCaml.org projects will be asked for their views.
- If the discussion still cannot be resolved, the Owner (or their Delegate)
will act as arbitrator.

During the above, it is expected that all people will be reasonable and be
respectful of each other's efforts and viewpoints.  In general, we expect to
generate consensus among the community to resolve conflicts.  

## Existing Projects

Projects are referred to by their **sub-domain** and summaries of the
current Projects are maintained on the Infrastructure
wiki page: <https://github.com/ocaml/infrastructure/wiki>

****

**Adoption of this document**

This version of the document was agreed upon by the incumbent set
of Maintainers in September 2015. You can look back at the
[discussion](http://lists.ocaml.org/pipermail/infrastructure/2015-August/000518.html)
or see the [related issue](https://github.com/ocaml/ocaml.org/issues/700).

***Version 1.0.0 — September 2015***
<!--
The version number should be changed for *any* edits that are made to this
document, even typos. Otherwise disambiguating between versions is awkward. 

Best wishes,
Amir

Sep 2015
-->|js}
  ; body_html = {js|<h2>Overview and Scope</h2>
<p>As the OCaml community continues to grow, more collaborative work is being
undertaken to support and extend the needs of the language and
its users. This document focuses specifically on the
OCaml.org <em>domain name</em> and the Projects that make use of that domain name.
It describes the reporting structure, roles involved and the responsibilities.
The aim is to avoid introducing cumbersome processes while still providing a
high degree of transparency.</p>
<h3>Purpose - a document that represents reality</h3>
<p>At any given time, this document must reflect the <em>current reality</em>.
It is <em>not</em> intended to be aspirational nor reflect the kind of structures
that people may expect to see. This is an important point because the utility
of this document is limited to the extent that it represents how things
<em>really</em> are, as opposed to how people may <em>desire</em> them to be in the future.
As the environment changes, this document should also be updated such that it
consistently reflects how things are.</p>
<h3>Disambiguation - the meaning of OCaml.org</h3>
<p>When using the term 'OCaml.org', there is the potential for a number of
different interpretations.  To reduce confusion, these are described below and
the meaning of the term <em>for this document</em> is explained.</p>
<p><em>Second-level domain name</em> - This is the domain name we are familiar with,
'OCaml.org', which has associated sub-domains and records (NB: Just for
clarity and edification, the top-level domain here is '.org').</p>
<p><em>Community website</em> - This is the community facing website, which can be found
at <a href="//ocaml.org">ocaml.org</a> and is often referred to as simply 'OCaml.org'.</p>
<p><em>Infrastructure</em> - This may refer to the virtual machines (VMs), services or
other things that are somehow routed via the second-level domain name itself.
An obvious example is the VM that hosts the community website but another would
be the VMs and systems that host the tarballs and files used by the OPAM
package manager tool.</p>
<p>For the purposes of this document, we take the first meaning — that
this document relates to the governance of the second-level domain,
'OCaml.org'. Therefore, anything that involves use of the domain name in some
form is affected by the governance of the domain name itself. That includes
any public facing webpages, URLs and other resources.
This is important because, in a way, OCaml.org is the sum of the Projects
it hosts.</p>
<p>To avoid confusion between the domain name itself and the community website
Project, the term 'OCaml.org' in this document refers <em>only</em> to
the second-level domain name itself. Any references to the domain of the
community website project will include the sub-domain 'www.ocaml.org',
even though this is set to redirect to <a href="//ocaml.org">ocaml.org</a>.</p>
<h3>Guiding principles of OCaml.org</h3>
<p>There are certain guiding principles for OCaml.org, which include openness and
a community-focus, that Projects need to be compatible with. These principles
extend to all of the Projects that use the domain OCaml.org.</p>
<h2>Roles</h2>
<h3>Owner and Delegates</h3>
<p>The Owner of OCaml.org is Xavier Leroy, the lead developer of the OCaml
language. Projects under OCaml.org sub-domains are managed by the
community, meaning that it is the community that actively contributes to the
day-to-day maintenance of any OCaml.org Project, but the general strategic
direction is drawn by the Owner.</p>
<p>It is the role of the Owner to resolve disputes that may arise
in relation to OCaml.org itself, specifically to ensure that the Projects under
OCaml.org are able to progress in a coordinated way.
It is the community's role to guide the decisions of the Owner
through active engagement, contributions and discussions.  To foster a healthy
and growing community, the Owner will make the
goals and decisions clear and public.</p>
<p>It is anticipated that the Projects themselves will be self-managing and will
resolve issues within their communities, without recourse to the Owner.
Where the Owner needs to become involved, he/she will act as arbitrator.</p>
<h4>Delegates</h4>
<p>The Owner may choose to delegate authority to others to manage the domain and
act in the Owner's name, though ownership remains with the Owner.
Those Delegates are free to choose how they arrange themselves, in agreement
with the Owner. In the specific case of disputes, the Delegate(s) will consult
with the Owner, who will act as arbitrator if required.</p>
<p><em>Currently, Xavier Leroy has delegated responsibility for OCaml.org to
Anil Madhavapeddy, who has accepted this Role.</em></p>
<h3>Maintainers</h3>
<p>Projects under OCaml.org will have their own Maintainers, who have commit
access to relevant repositories and are responsible for:</p>
<ul>
<li>Managing the specific project.
</li>
<li>Writing code directly to repositories.
</li>
<li>Eliciting and screening the contributions of others.
</li>
<li>Ensuring that the Owners/Delegates are aware of community needs.
</li>
</ul>
<p>Generally, Maintainers only have authority over the specific Projects they are
responsible for though it is expected that Maintainers of different Projects
will collaborate frequently, especially in the case of major changes or
announcements.  Typically, individuals who have made substantive contributions
to a Project will be invited to become Maintainers.</p>
<h3>Contributors</h3>
<p>Contributors are wider members of the OCaml community who make valuable
contributions, but generally do not have authority to make direct changes to a
Project's code-base or documentation. Anyone can become a Contributor and there
is no expectation of commitment, no specific skill requirement and no
selection process. The only necessary step is to make or suggest some
improvement or change to the Project.</p>
<p>Contributors can interact with a Project via tools such as email lists, issue
trackers and wiki pages, for example.  The main email list for OCaml.org is
infrastructure@lists.ocaml.org and is open to all. Maintainers are
free to direct discussion to their own dedicated mailing lists, as they feel
appropriate. Those whose contributions become part of a public git repository
will be recognised in some form on a public website as thanks.</p>
<p>It is expected that regular Contributors to specific Projects may be asked if
they wish to become Maintainers, as described above. There is no obligation to
accept such an offer.</p>
<h3>Users</h3>
<p>Users are the most important group and it includes the much wider community of
anyone who interacts with OCaml.org in any way.  This covers all web-visitors,
package users, and members of mailing lists. Without Users, the Projects serve
no purpose so the impact of any major decisions on this group should be
assessed.</p>
<p>Wherever practicable, Users should be encouraged to provide feedback and
participate in the Projects as much as possible. Users who engage a lot with a
Project will likely go on to become Contributors.</p>
<p>It should be noted that these Roles are not mutually exclusive, for example
Maintainers and Contributors are necessarily also Users.</p>
<h2>Projects</h2>
<p><strong>Definition</strong> - A Project within OCaml.org is characterised by its sub-domain.
It is expected that the majority of new work will fall under an existing
sub-domain and will therefore already have a set of Maintainers and
Contributors (as described above).</p>
<p><strong>Communication</strong> - All Maintainers of Projects must join the Infrastructure
mailing list (infrastructure@lists.ocaml.org). This list is the primary way
that information and decisions surrounding OCaml.org will be discussed and
disseminated. If Projects wish to set up their own lists, they may do so on
lists.ocaml.org (see below).</p>
<p><strong>Governance</strong> - Projects are free to choose their mode of governance provided
it is compatible with the governance and guiding principles of OCaml.org.</p>
<h3>Initiating a Project</h3>
<p>Any proposal for new work should be raised and discussed on the Infrastructure
mailing list. If there is consensus among Maintainers that the work fits
within an existing Project, then the Maintainers of that Project can take it
forward.</p>
<p>If a new sub-domain is required, then a brief proposal
should be made on the Infrastructure list that covers:</p>
<ul>
<li>The aims and purpose of the Project (inc name of the sub-domain required).
</li>
<li>Specific resources required and for how long (e.g VMs).
</li>
<li>Any impact on or relation to existing Projects.
</li>
<li>Information about the initial Maintainers.
</li>
<li>Details of proposed licensing arrangements for code/content.
</li>
</ul>
<p>The above information is intended to stimulate discussion so brevity is
preferred. Following discussion, and if the Owner/Delegate agrees, the
resources can be provisioned. There is no obligation for the Owner/Delegate to
provide any resources beyond the sub-domain.</p>
<h3>Closing a Project</h3>
<p>A Project can be closed:</p>
<ul>
<li>If it has completed its aims and the Maintainers request it be closed down.
</li>
<li>If there are no Maintainers left to continue supporting it and no-one willing
to take on the role.
</li>
<li>By the Owner/Delegate for any reason.
</li>
</ul>
<p>In all cases, prior notice must be sent to the Infrastructure list including a
reasonable time-frame and reasons for closure.
Closure simply implies revocation or redirection of the sub-domain and/or
shutting down or reclaiming any resources provided (e.g VMs).</p>
<h2>Processes</h2>
<h3>Decision Making and Communication</h3>
<p>The preferred approach for most discussions is through
<a href="http://en.wikipedia.org/wiki/Rough_consensus">rough consensus and running code</a>.
Discussions should be public and take place on either the Infrastructure
mailing list, the relevant Project mailing-list or on relevant issue trackers.
Users and Contributors are encouraged to take part and voice their opinions.
Typically, the Maintainers of a Project will make the final decision, having
accounted for wider views.</p>
<p>All Projects under OCaml.org are to be documented such that Users can find out
about them and understand both the purpose and how they can contribute.</p>
<h3>Contribution Process and Licensing</h3>
<p>Contributions to OCaml.org will primarily be to one or more of its Projects.
Each Project under OCaml.org needs to define a clear contribution process and
licensing agreement so
that Contributors understand how to engage with the Maintainers. Typically,
this will cover where communication occurs and the process for submitting
patches. Contributions from the community are encouraged and can take many
forms including, bug fixes, new features, content or documentation.</p>
<p>All Projects under OCaml.org are expected to be open-source and the licensing
arrangements should reflect this.</p>
<p>Contributions to OCaml.org itself may be in the form of resources that can be
shared by Projects and can be discussed with Owner/Delegate and Project
Maintainers on the Infrastructure mailing list.</p>
<h3>Dispute resolution</h3>
<p>Maintainers are expected to make decisions regarding their Projects.
The intent is for any Maintainers to resolve disagreements, through
a consensus process within each Project.</p>
<p>On the rare occasions, where Maintainers of a Project cannot agree
on a way forward the following approach is suggested:</p>
<ul>
<li>The specific issue(s) will need to be articulated so it is clear what needs
to be discussed.
</li>
<li>Other Maintainers of OCaml.org projects will be asked for their views.
</li>
<li>If the discussion still cannot be resolved, the Owner (or their Delegate)
will act as arbitrator.
</li>
</ul>
<p>During the above, it is expected that all people will be reasonable and be
respectful of each other's efforts and viewpoints.  In general, we expect to
generate consensus among the community to resolve conflicts.</p>
<h2>Existing Projects</h2>
<p>Projects are referred to by their <strong>sub-domain</strong> and summaries of the
current Projects are maintained on the Infrastructure
wiki page: <a href="https://github.com/ocaml/infrastructure/wiki">https://github.com/ocaml/infrastructure/wiki</a></p>
<hr />
<p><strong>Adoption of this document</strong></p>
<p>This version of the document was agreed upon by the incumbent set
of Maintainers in September 2015. You can look back at the
<a href="http://lists.ocaml.org/pipermail/infrastructure/2015-August/000518.html">discussion</a>
or see the <a href="https://github.com/ocaml/ocaml.org/issues/700">related issue</a>.</p>
<p><em><strong>Version 1.0.0 — September 2015</strong></em></p>
<!--
The version number should be changed for *any* edits that are made to this
document, even typos. Otherwise disambiguating between versions is awkward. 

Best wishes,
Amir

Sep 2015
-->
|js}
  }


let privacy_policy = 
  { title = {js|OCaml Privacy Policy|js}
  ; description = {js|<b>TL;DR:</b> We do not use cookies and we do not collect any personal data. We also don't use any third party service.|js}
  ; meta_title = {js|OCaml Privacy Policy|js}
  ; meta_description = {js|<b>TL;DR:</b> We do not use cookies and we do not collect any personal data. We also don't use any third party service.|js}
  ; body_md = {js|
The OCaml.org committee is committed to complying with GDPR, CCPA, PECR and other privacy regulations on this website.

## What we collect?

The privacy of your data is very important to us, and so we go to great length to not collect any personal data, and protect you from third party services that may track you.

As a visitor to the OCaml.org website:

- No personal information is collected
- No information such as cookies is stored in the browser
- No information is shared with, sent to or sold to third-parties
- No information is shared with advertising companies
- No information is mined and harvested for personal and behavioral trends
- No information is monetized

## Changes and questions

We may update this policy as needed to comply with relevant regulations and reflect any new practices. Whenever we make a significant change to our policies, we will also announce them on our company blog or social media profiles.

Contact us if you have any questions, comments, or concerns about this privacy policy, your data, or your rights with respect to your information.

Last updated: February 9th, 2022
|js}
  ; body_html = {js|<p>The OCaml.org committee is committed to complying with GDPR, CCPA, PECR and other privacy regulations on this website.</p>
<h2>What we collect?</h2>
<p>The privacy of your data is very important to us, and so we go to great length to not collect any personal data, and protect you from third party services that may track you.</p>
<p>As a visitor to the OCaml.org website:</p>
<ul>
<li>No personal information is collected
</li>
<li>No information such as cookies is stored in the browser
</li>
<li>No information is shared with, sent to or sold to third-parties
</li>
<li>No information is shared with advertising companies
</li>
<li>No information is mined and harvested for personal and behavioral trends
</li>
<li>No information is monetized
</li>
</ul>
<h2>Changes and questions</h2>
<p>We may update this policy as needed to comply with relevant regulations and reflect any new practices. Whenever we make a significant change to our policies, we will also announce them on our company blog or social media profiles.</p>
<p>Contact us if you have any questions, comments, or concerns about this privacy policy, your data, or your rights with respect to your information.</p>
<p>Last updated: February 9th, 2022</p>
|js}
  }


