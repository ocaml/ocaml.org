---
title: OCaml Governance
description: The structure of the OCaml projects, the roles involved and the responsibilities.
meta_title: Governance of the OCaml projects and domain
meta_description: Read about the structure of the OCaml projects, the roles involved and the responsibilities.
---

## I. Introduction

### A. Overview and Scope

The OCaml ecosystem is continually expanding, encompassing a growing number of
collective endeavors aimed at supporting, extending, and enriching the language
and its user base. This document provides governance details for:

1. The OCaml.org *domain name* and its associated projects.
2. The OCaml Platform - the recommended set of tools for the OCaml programming
   language.

The document outlines the reporting structure, details the roles involved, and
delineates the responsibilities of each project that falls under this
governance. The goal is to balance efficient operation with comprehensive
transparency, eschewing needless complexity while upholding a clear, effective
governance model.

### B. Purpose - A Document That Represents Reality

At any given time, this document must reflect the *current reality*. It is *not*
intended to be aspirational nor reflect the kind of structures that people may
expect to see. This is an important point because the utility of this document
is limited to the extent that it represents how things *really* are, as opposed
to how people may *desire* them to be in the future. As the environment changes,
this document should also be updated such that it consistently reflects how
things are.

### D. Guiding Principles

The OCaml governance, inclusive of OCaml.org and the OCaml Platform, is guided
by key principles such as openness, community focus, and compatibility. Each
project that falls under the OCaml governance should align with these
principles, fostering a community that is open, collaborative, and dedicated to
the continued development and advancement of the OCaml language and its
applications.

## II. Roles and responsibilities

### A. Owner and Delegates

The Owner of the OCaml.org domain and the OCaml Platform is Xavier Leroy, the
lead developer of the OCaml language. Projects under OCaml.org sub-domains and
within the OCaml Platform are managed by the community, meaning that it is the
community that actively contributes to the day-to-day maintenance of these
initiatives, but the general strategic direction is drawn by the Owner.

It is the role of the Owner to resolve disputes that may arise in relation to
OCaml.org or the OCaml Platform, specifically to ensure that the projects within
these domains are able to progress in a coordinated way. It is the community's
role to guide the decisions of the Owner through active engagement,
contributions, and discussions. To foster a healthy and growing community, the
Owner will make the goals and decisions clear and public.

It is anticipated that the Projects themselves will be self-managing and will
resolve issues within their communities, without recourse to the Owner. Where
the Owner needs to become involved, he/she will act as arbitrator.

### B. Delegates

The Owner may choose to delegate authority to others to manage the domain and
act in the Owner's name, though ownership remains with the Owner. Those
Delegates are free to choose how they arrange themselves, in agreement with the
Owner. In the specific case of disputes, the Delegate(s) will consult with the
Owner, who will act as arbitrator if required.

*Currently, Xavier Leroy has delegated responsibility for OCaml.org and the
OCaml Platform to Anil Madhavapeddy, who has accepted this Role.*

### C. Maintainers

Projects under OCaml governance will have their own Maintainers, who have commit
access to relevant repositories and are responsible for:

- Managing the specific project.
- Writing code directly to repositories.
- Eliciting and screening the contributions of others.
- Ensuring that the Owners/Delegates are aware of community needs.

Generally, Maintainers only have authority over the specific Projects they are
responsible for though it is expected that Maintainers of different Projects
will collaborate frequently, especially in the case of major changes or
announcements. Typically, individuals who have made substantive contributions to
a Project will be invited to become Maintainers.

### D. Contributors

Contributors are wider members of the OCaml community who make valuable
contributions to projects under OCaml governance, but generally do not have
authority to make direct changes to a Project's codebase or documentation.
Anyone can become a Contributor and there is no expectation of commitment, no
specific skill requirement, and no selection process. The only necessary step is
to make or suggest some improvement or change to the Project.

Contributors can interact with a Project via tools such as email lists, issue
trackers, and wiki pages, for example. Maintainers are free to direct discussion
to their own dedicated mailing lists or preferred communication platform, as
they feel appropriate. Those whose contributions become part of a public Git
repository will be recognised in some form on a public website as thanks.

It is expected that regular Contributors to specific Projects may be asked if
they wish to become Maintainers, as described above. There is no obligation to
accept such an offer.

### E. Users

Users are the most important group and it includes the much wider community of
anyone who interacts with OCaml Projects in any way. This covers all
web-visitors, users of the Platform tools, package users and members of mailing
lists. Without Users, the Projects serve no purpose, so the impact of any major
decisions on this group should be assessed.

Wherever practicable, Users should be encouraged to provide feedback and
participate in the Projects as much as possible. Users who engage a lot with a
Project will likely go on to become Contributors.

It should be noted that these Roles are not mutually exclusive, for example
Maintainers and Contributors are necessarily also Users.

## III. OCaml.org

**Definition** - A Project within OCaml.org is characterised by its subdomain.
It is expected that the majority of new work will fall under an existing
subdomain and will therefore already have a set of Maintainers and Contributors
(as described above).

**Communication** - All Maintainers of Projects must monitor the
[`ocaml/infrastructure`](https://github.com/ocaml/infrastructure/) GitHub issue
tracker. The issue tracker is the primary mode of exchanging information and
decisions concerning OCaml.org Projects. In case Projects wish to establish
their own issue trackers, they are free to do so on GitHub (see below).

**Governance** - Projects are free to choose their mode of governance provided
it is compatible with the governance and guiding principles of OCaml governance.

### A. Disambiguation - The Meaning of OCaml.org

When using the term 'OCaml.org', there is the potential for a number of
different interpretations. To reduce confusion, these are described below, and
the meaning of the term *for this document* is also explained.

*Second-level domain name* - This is the domain name we are familiar with,
'OCaml.org', which has associated sub-domains and records (NB: Just for clarity
and edification, the top-level domain here is '.org').

*Community website* - This is the community-facing website, which can be found
at [ocaml.org](//ocaml.org) and is often referred to as simply 'OCaml.org'.

*Infrastructure* - This may refer to virtual machines (VMs), services, or
other things that are somehow routed via the second-level domain name itself. An
obvious example is the VM that hosts the community website, but another would be
the VMs and systems that host the tarballs and files used by the Opam package
manager tool.

For the purposes of this document, we take the first meaning — that this
document relates to the governance of the second-level domain, 'OCaml.org'.
Therefore, anything that involves use of the domain name in some form is
affected by the governance of the domain name itself. That includes any public
facing webpages, URLs, and other resources. This is important because, in a way,
OCaml.org is the sum of the Projects it hosts.

To avoid confusion between the domain name itself and the community website
Project, the term 'OCaml.org' in this document refers *only* to the second-level
domain name itself. Any references to the domain of the community website
project will include the sub-domain 'www.ocaml.org', even though this is set to
redirect to [ocaml.org](//ocaml.org).

### B. Initiating a Project

Any proposal for new work should be raised and discussed on the
[`ocaml/infrastructure`](https://github.com/ocaml/infrastructure/) GitHub issue
tracker. If there is consensus among Maintainers that the work fits within an
existing Project, then the Maintainers of that Project can proceed with it.

If a new subdomain is required, then a brief proposal should be made on the
Infrastructure list that covers:

- The aims and purpose of the Project (inc name of the subdomain required)
- Specific resources required and for how long (e.g., VMs)
- Any impact on or relation to existing Projects
- Information about the initial Maintainers
- Details of proposed licensing arrangements for code/content

The above information is intended to stimulate discussion, so brevity is
preferred. Following discussion, and if the Owner/Delegate agrees, the resources
can be provisioned. There is no obligation for the Owner/Delegate to provide any
resources beyond the subdomain.

### C. Closing a Project

A Project can be closed:

- If it has completed its aims and the Maintainers request it be closed down
- If there are no Maintainers left to continue supporting it and no one willing
  to take on the role
- By the Owner/Delegate for any reason

In all cases, prior notice must be sent to the Infrastructure list including a
reasonable time frame and reasons for closure. Closure simply implies revocation
or redirection of the subdomain and/or shutting down or reclaiming any resources
provided (e.g., VMs).

### D. Existing Projects

Projects are referred to by their **subdomain**, and summaries of the current
Projects are maintained on the Infrastructure wiki page:
<https://github.com/ocaml/infrastructure/wiki>

## IV. OCaml Platform

The OCaml Platform is the recommended set of tools for the OCaml programming
language. It is designed to provide a stable and consistent environment for
OCaml developers, allowing them to focus on building high-quality software. The
tools in The OCaml Platform each have their independent lifecycle.

The purpose of this section is to outline the process and criteria for
incubating, promoting, and deprecating tools within the OCaml Platform. It
provides guidelines for the lifecycle of tools.

### A. General requirements for OCaml Platform tools

In addition to the requirements for each stage of the tool lifecycle, some
general requirements must be met by all tools in the OCaml Platform. These
requirements ensure that the tools are consistent with the quality and standards
of the Platform.

- The OCaml Platform only contains tools. Libraries that these tools use will be
  supported by their transitive dependencies. Each tool takes its own decision
  about what libraries they use. By doing so, it commits to supporting these
  libraries for as long as necessary.
- Tools must be well-documented, including clear installation instructions and
  usage examples.
- Tools must have a permissive open-source license that is compatible with the
  OCaml Platform. Compatible licenses include licenses that allow modifications
  to be distributed under different terms and without source code. In
  particular, licenses that enforce that the complete source code of the
  modified version must be made available are incompatible with the OCaml
  Platform. Examples of compatible licenses include MIT, ISC, Apache License.
  Licenses that are incompatible with the OCaml Platform include GPL v2 and v3.
- Platform tools must adopt the OCaml Code of Conduct and strictly abide by its
  guidelines.
- Tools must be tested and compatible with the latest version of OCaml and
  commit to following the OCaml release readiness process, which includes
  releasing compatible or preview versions of Platform tools during the alpha
  releases of new compiler releases.
- The tools must have backward compatibility in mind and be fully
  backwards-compatible after their first stable release.

### B. Tool Lifecycle Stages

#### 1. Incubate

**Definition:**

The Incubate stage is the first stage of the tool lifecycle in the OCaml
Platform. New tools that fill a gap in the OCaml ecosystem but are not yet ready
for wide-scale release and adoption are incubated in this stage. The tools in
this stage have a quick iterative development cycle and may have unreliable
backward compatibility, before their first major release.

**Requirements for incubation:**

Tools must meet the following requirements to be considered for incubation in
the OCaml Platform:

- At least two maintainers who are committed to long-term maintenance of the
  tool
- A well-defined purpose and scope - the tool must fill a gap in the OCaml
  developer workflows or provide a different way of doing an existing workflow.
  In the case of duplication with an Active tool, the maintainers of both tools
  should talk and resolve the duplication
- A clear plan for future development and maintenance, including the
  establishment of a migration path and a clear community need to get promoted
  to Active
- A functioning implementation and adequate documentation and testing

**Removing a Tool from Incubate:**

In the event that the criteria for incubation are no longer met, a tool may be
removed from the Incubate stage. Note that not all Incubate tools will be
promoted to Active, but the community will still have learned something useful
about the features that are needed or useful.

#### 2. Active

**Definition:**

The Active stage is the second stage of the tool lifecycle in the OCaml
Platform, and it's the home for workhorse tools that are used daily by the OCaml
community. These tools are the cornerstone projects that are heavily relied upon
and recommended for new projects and newcomers alike. Active tools are known for
their strong backwards compatibility guarantees and minimal disruption to users'
workflow.

Any changes to Active tools will come with complete update instructions, and
their metadata files are versioned reliably to allow users to control when they
upgrade to new versions. The development community for Active tools is always
open, and anyone is encouraged to become a maintainer.

Active tools maintainers run regular developer meetings. Anyone from the
community who is interested in contributing to a project is welcome to join the
developer meetings. Meeting notes for these developer meetings are recorded and
available on GitHub.

Tools that enter the Active stage can be hosted on the OCaml GitHub organization
and permissions are managed through GitHub teams which only lead maintainers of
the projects and OCaml GitHub organization administrators can update.

**Requirements for promotion from Incubate to Active:**

To be promoted from the Incubate stage to the Active stage, a tool must meet the
following requirements:

- The tool must not duplicate any functionality that is already provided by
  another Active tool in the Platform. Any duplication and overlap with other
  tools in the Platform must have been resolved during the Incubate stage.
- The tool must have reached a stable release as signaled by a version above 1.0
  and strong backward compatibility enforcements.
- The tool must be well-documented and have a clear roadmap for future
  development.
- The tool must have a strong and active development community.

The decision to promote a tool is ultimately made by the Owner and Delegate(s),
in consultation with the development community, based on the tool's overall
stability, adoption by the OCaml community, and adherence to the principles of
the Platform.

#### 3. Sustain

**Definition:**

Sustain tools are projects that have been in use for many years and are
considered to be extremely stable. They provide essential functionality to the
OCaml community, and while they are not actively developed, they can continue to
be used reliably for a long time.

Sustain tools are an important part of the OCaml Platform ecosystem as they
serve their purpose exceptionally well. Although newer alternatives might exist,
Sustain tools are maintained to support newer compiler releases. If
functionality provided by a Sustain tool has an alternative in the Active stage,
it is recommended to use the Active alternative as it might offer performance or
usability benefits.

**Requirements for promotion from Active to Sustain:**

To be promoted from the Active stage to the Sustain stage, a tool must meet the
following requirements:

- The tool has been in the Active stage for a significant amount of time,
  typically several years.
- The tool entered a maintenance stage where no new features are being
  developed.

#### 4. Deprecated

**Definition:**

The Deprecated stage is a phase in the OCaml Platform where tools are gradually
being phased out, with clear paths to better workflows. These tools are no
longer actively maintained within the Platform but might still be maintained by
community maintainers.

**Requirements for promotion from Sustain to Deprecated:**

To be considered for deprecation, a tool must meet the following requirements:

- The tool has been replaced by an Active alternative with clear migration
  paths.
- The tool must have been in the Sustain stage for a sufficient amount of time
  and adequate notice has been given to users to allow for migration at their
  own pace.

## V. Processes

### A. Decision Making and Communication

The preferred approach for most discussions is through
[rough consensus and running code](http://en.wikipedia.org/wiki/Rough_consensus).
Discussions should be public and take place on either the OCaml Discuss forum,
the relevant Project mailing-list, or on relevant issue trackers. Users and
Contributors are encouraged to take part and voice their opinions. Typically,
the Maintainers of a Project will make the final decision, having accounted for
wider views.

All Projects under the OCaml governance are to be documented such that Users can
find out about them and understand both the purpose and how they can contribute.

### B. Contribution Process and Licensing

Each Project under the OCaml governance needs to define a clear contribution
process and licensing agreement so that Contributors understand how to engage
with the Maintainers. Typically, this will cover where communication occurs and
the process for submitting patches. Contributions from the community are
encouraged and can take many forms including, bug fixes, new features, content,  
or documentation.

All Projects under the OCaml governance are expected to be open source, and the
licensing arrangements should reflect this.

### C. Dispute Resolution

Maintainers are expected to make decisions regarding their Projects. The intent
is for any Maintainers to resolve disagreements, through a consensus process
within each Project.

On the rare occasions, where Maintainers of a Project cannot agree on a way
forward, the following approach is suggested:

- The specific issue(s) will need to be articulated, so it is clear what needs
  to be discussed.
- Other Maintainers of OCaml Projects will be asked for their views.
- If the discussion still cannot be resolved, the Owner (or their Delegate) will
  act as arbitrator.

During the above, it is expected that all people will be reasonable and be
respectful of each other's efforts and viewpoints. In general, we expect to
generate consensus among the community to resolve conflicts.  

****

<!--
The version number should be changed for *any* edits that are made to this
document, even typos. Otherwise disambiguating between versions is awkward. 

Best wishes,
Amir
-->

## Version 1.0.0 - September 2015

This first version of the document was agreed upon by the incumbent set of
Maintainers in September 2015. You can look back at the
[discussion](https://lists.ocaml.org/pipermail/infrastructure/2015-August/000518.html)
or see the [related issue](https://github.com/ocaml/v2.ocaml.org/issues/700).

***Version 1.0.1 — March 2022***

- Addressed consistency in title case and grammar.

***Version 2.0.0 — June 2023***

- Include the OCaml Platform governance.
- Rename the document "OCaml Governance" to reflect the inclusion of the OCaml
  Platform.
- Update the governance of OCaml.org to reflect the use of the
  `ocaml/infrastructure` GitHub issue tracker in place of the infrastructure
  mailing list.

***Version 2.0.1 — October 2023***

- Remove requirement of Active tools to be hosted on the OCaml GitHub organisation.
