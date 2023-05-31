---
title: OSS Repository Maintenance and Management
description:
url: http://reynard.io/2016/12/13/OSSWorkflow.html
date: 2016-12-13T00:00:00-00:00
preview_image:
featured:
authors:
- reynard
---

<p><strong>TL;DR</strong></p>

<ul>
  <li>We are experimenting with using GitHub Issues, Labels and Milestones to manage our distributed open source projects</li>
  <li>Utilising tools that your team already uses is beneficial</li>
  <li>Good for collaborative workflows with many contributors and interested parties</li>
  <li>Requires consistent input and tweaking</li>
</ul>

<hr/>

<h2>My Role</h2>

<p>I am new to open source maintenance and management, and my position at OCaml Labs is operational rather than technical. It&rsquo;s important for me to grasp the general idea of a project enough to see how it fits within our larger goals, and then help it move forward without administrative blockers. Figuring out how I can fit in this highly technical environment has been interesting and challenging (that&rsquo;s a whole other post!), but I&rsquo;ve recently implemented a few changes that (I hope) will start to positively impact our projects and our research.</p>

<h2>Motivation</h2>

<p>Keeping track of administrative details and the ~40 projects our distributed team is working on requires a consistent approach to reduce the likelihood of tasks being dropped, stuck in a bottleneck, or lost in the noise. Our projects are highly collaborative and receive input from developers, students, researchers and support staff - we need a method of maintenance that promotes this direct interaction and goal-oriented development.</p>

<h2>My Workflow</h2>

<p>I started by looking at my own daily tasklists to explore how I might manage them more efficiently, then chose one of our internal projects that might be applicable for a similar process.</p>

<p>I&rsquo;ve tried many methods of to-do list management, including:</p>

<h3>Ye Olde Paper &amp; Pen</h3>
<p>I can write pages and pages of lists, but there is little organisation to it and my scrawlings are not always legible to others. I still use a scribble pad to jot down the individual tasks I need to complete that day - physically crossing off items on a list is always satisfying! - but carting around a messy, poorly organised notebook to and from meetings is not especially helpful for sharing progress and interacting with colleagues.</p>

<p><em><strong>UPDATE: I have succumbed to maintaining a bullet journal! It is no longer a messy, poorly organised notebook, and is the perfect complement to my online workflow</strong></em></p>

<h3>Inbox To Do List</h3>
<p>I must confess that my inbox was managed rather appallingly until recently. Although I dealt with important or time-sensitive emails quickly I seemed unable to decide on a strategy for managing emails that were a collection of useful details, or decisions that I would need to make at some point in the future - all of the non-immediate tasks. I tried using my inbox as a todo list by using Gmail labels, but that quickly got out of hand and I ended up just avoiding looking at my email, missing the entire point! It&rsquo;s also very easy to unintentionally filter out important conversations, especially if every query or pending decision is part of a long, in-depth thread.</p>

<h3><a href="http://kanbanblog.com/explained/">Kanban</a></h3>
<p>Hello <a href="https://trello.com/">Trello</a>! I found this idea worked for the most part, but I couldn&rsquo;t get everyone to join Trello and interact with my board, which meant overall it was not useful and got abandoned. I liked the idea of having a process that individual tasks pass through - the standard set-up is &ldquo;Todo&rdquo;, &ldquo;Doing&rdquo;, &ldquo;Done&rdquo;, or similar variations - and clicking and dragging cards between columns is helpful. Perhaps I could apply this principle elsewhere?</p>

<h3><a href="https://github.com/">GitHub</a></h3>
<p>The majority of developers on our team use GitHub to release code and maintain our open source repositories, so this seemed like a useful place to start. I wanted to try implementing a management workflow within an existing structure to increase the likelihood of long term adoption and success. Initially I looked at the myriad of project management extensions and apps that have been developed as plugins for GitHub, but I was keen to avoid the Trello problem we faced when using another external application. Fortunately GitHub released their Projects feature around this time, and this together with using Labels and Milestones addresses most of my needs directly.</p>

<h3>GitHub Issues, Labels, Milestones and Projects</h3>

<p><a href="https://guides.github.com/features/issues/">Issues</a> are essentially tasks, and can be organised as bugs or todo items depending on the type of project. All members with access to a repository will be able to view, create and comment on Issues. Colour-coded <a href="https://guides.github.com/features/issues/#filtering">Labels and Milestones</a> allow you to further manage your Issues, and assign them to specific individuals and timeframes.</p>

<p>GitHub Projects aim to apply the Trello/Kanban management style to repositories, and I experimented by using them in conjunction with my Issues. Any Issues that are created in a repository are available to use directly within a Project. You can add them to one or more active projects, and progress them through your workflow as you see fit.</p>

<p><em><strong>It is worth noting that in this administrative repository all of the Issues are created as todo items, which is slightly different to a standard repository featuring code - here Issues are added to highlight a problem or bug, and don&rsquo;t necessarily represent a todo list as such.</strong></em></p>

<p>The approach I currently use is also slightly different to the usual Kanban method in that my columns represent tasks I need to complete &ldquo;Today&rdquo;, &ldquo;Tomorrow&rdquo; &ldquo;This Week&rdquo;, in the &ldquo;Future&rdquo; as well as a &ldquo;Completed&rdquo; column on the far side.</p>

<p>This process allows me to prioritise my todo items and for anyone on my immediate core team (those who have access to the repository) to see exactly what I am working on at the moment, the state it is currently in, and what is next on my agenda/workflow. I move issues/cards between the columns and update comments on them to provide incremental updates on the topic itself. I have given permission for my immediate team to also add issues to the workflow management process on the basis that they use it in a similar way - essentially it is a shared todo list that is updated on the fly.</p>

<p><strong>Example process:</strong></p>

<p><strong>1:</strong> I create an Issue for &ldquo;Create a list of internship projects for 2017&rdquo;. Everyone who has access to the repository will be able to see that is a current Issue</p>

<p><strong>2:</strong> Under Projects, I click through to the Project entitled &ldquo;Gemma&rsquo;s Workflow&rdquo; and click &ldquo;+ Add Cards&rdquo; on the top right. A drop down menu of all Issues appear, and I can drag the one I need into the column that is most appropriate, for example &ldquo;This Week&rdquo;</p>

<p><strong>3:</strong> Everyone can see from this overview that I would like to address this task at some point within the next week</p>

<p><strong>4:</strong> I add a description with some details of what we need to do, and @ someone on my team who I want to check it over next</p>

<p><strong>5:</strong> They can see the Issue, add a comment, move the Issue around within the Project workflow, or close it if complete</p>

<p>Everyone can see the current status of the todo task, and it is easily passed between team members whose input is required. The vast majority of my team is on GitHub regularly, so items are addressed in a timely and effective manner - if one person is blocked, it can quickly and easily be redirected.</p>

<p>The combination of Issues, Labels and Milestones together with the prioritisation in the Projects workflow has so far been very useful for my workflow, but I was interested to see how we might apply it to our code-based open source projects.</p>

<h2>Applying this workflow to the Merlin repository</h2>

<p><a href="https://the-lambda-church.github.io/merlin/">Merlin</a> is an editor service that provides modern IDE features for OCaml. It is maintained by <a href="https://github.com/let-def">Frederic Bour</a> and <a href="https://github.com/the-lambda-church/merlin/blob/master/README.md">various contributors</a> and relies on community support.</p>

<p>The workflow application to Merlin is still a work in progress, but Fred and I collectively are looking at the most applicable labels, and looked at how we might use the Projects method in this case.</p>

<h3>Process</h3>

<p>New project features tend to go through the following process:</p>

<ul>
  <li>Idea/discussion</li>
  <li>Build</li>
  <li>Test</li>
  <li>Documentation</li>
  <li>Release</li>
  <li>Manual testing/feedback</li>
</ul>

<p>The Merlin Issue tracker was initially arranged in the basic format that GitHub suggests: Labels such as &ldquo;Bug&rdquo; and &ldquo;Feature request&rdquo; were present, but as time progressed, some issues were pushed to the bottom and left unresolved.
We decided to represent the above stages of development as Labels, and now ensure that each issue goes through this process to avoid losing track. Thanks to the <a href="https://github.com/docker/for-mac/labels">Docker for Mac and Windows</a> repository for inspiration!</p>

<h3>Labels</h3>

<ul>
  <li><a href="https://github.com/the-lambda-church/merlin/labels/Area%2FEmacs">Area/Emacs</a>: Related to Emacs</li>
  <li><a href="https://github.com/the-lambda-church/merlin/labels/Area%2FVim">Area/Vim</a>: Related to Vim</li>
  <li><a href="https://github.com/the-lambda-church/merlin/labels/Kind%2FBug">Kind/Bug</a>: This issue describes a problem</li>
  <li><a href="https://github.com/the-lambda-church/merlin/labels/Kind%2FDocs">Kind/Docs</a>: This issue describes a documentation change</li>
  <li><a href="https://github.com/the-lambda-church/merlin/labels/Kind%2FFeature-request">Kind/Feature-Request</a>: Solving this issue requires implementing a new feature</li>
  <li><a href="https://github.com/the-lambda-church/merlin/labels/Kind%2FTo-discuss">Kind/To-discuss</a>: Discussion needed to converge on a solution; often aesthetic. See mailing list for discussion</li>
  <li><a href="https://github.com/the-lambda-church/merlin/labels/Status%2F0-More-info-needed">Status/0-More-info-needed</a>: More information is needed before this issue can be triaged</li>
  <li><a href="https://github.com/the-lambda-church/merlin/labels/Status%2F0-Triage">Status/0-Triage</a>: This issue needs triaging</li>
  <li><a href="https://github.com/the-lambda-church/merlin/labels/Status%2F1-Acknowledged">Status/1-Acknowledged</a>: This issue has been triaged and is being investigated</li>
  <li><a href="https://github.com/the-lambda-church/merlin/labels/Status%2F2-Regression">Status/2-Regression</a>: Known workaround to be applied and tested</li>
  <li><a href="https://github.com/the-lambda-church/merlin/labels/Status%2F3-Fixed-need-test">Status/3-Fixed-need-test</a>: This issue has been fixed and needs checking</li>
  <li><a href="https://github.com/the-lambda-church/merlin/labels/Status%2F4-Fixed">Status/4-Fixed</a>: This issue has been fixed!</li>
  <li><a href="https://github.com/the-lambda-church/merlin/labels/Status%2F5-Awaiting-feedback">Status/5-Awaiting-feedback</a>: This issue requires feedback on a previous fix</li>
</ul>

<h3>Roadmap</h3>

<p>We are using the <a href="https://github.com/the-lambda-church/merlin/projects/1">Project</a> area as a scratchpad to note future work and 3 month roadmaps, by having a column assigned to each upcoming month in the quarter. It&rsquo;s easier to update than a normal list in the repo Wiki and you can quickly edit and move cards between columns. Currently there is a disparity between the roadmap and the actual issues - it will take some time working with it to see what works best.</p>

<h3>Contribution</h3>

<p>Checking in with the Issue tracker regularly is key, and we have updated the <a href="https://github.com/the-lambda-church/merlin/blob/master/README.md">README</a> to reflect the new management process to provide clarity, and to encourage others to contribute in specific ways to help the project. These changes align the desire to efficiently manage our shared repositories with the aim of encouraging and acknowledging contributions to the projects. We will further test and refine this process with other repositories that we manage and projects to see what works.</p>

<h2>Conclusion</h2>

<p>After some research with different approaches we are experimenting with using a combination of GitHub Issues, Labels, Milestones and Projects to manage our open source project workflow management.</p>

<h3>Benefits</h3>

<ul>
  <li>Collaborative: Use the @ function to directly involve others in the conversation. This is good for specific queries or for when you need to ping that person to engage with the task - they will receive a notification and can respond appropriately.</li>
  <li>Potentially reduces the number of meetings you will need to have: We have been able to reduce the number of admin sync meetings we need to have as incremental updates on the Issues and the overview from the Projects area provides a good snapshot of what is happening currently and what is planned next. We have yet to see if it will do the same for other repositories&hellip;</li>
  <li>Works well with a distributed team: It is utilising a tool already in use in the daily life of our team, and is an effective alternative when you can&rsquo;t have a physical meeting or call.</li>
</ul>

<h3>Some problems</h3>

<ul>
  <li>Difficult to link the larger roadmap plans with individual issues/todo items: Still difficult to assess progress based on goals.</li>
  <li>If you don&rsquo;t have one large mono-repository, you cannot have Labels and Projects linked across repositories: You have to set up a workflow management system on a per-repository basis which does little to improve the organisational overview of ALL projects.</li>
  <li>Assigning Issues to more than one individual at any one time simply creates noise and reduces clarity: Stick with one assignee at a time.</li>
</ul>

