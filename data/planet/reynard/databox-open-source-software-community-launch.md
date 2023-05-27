---
title: Databox Open-Source Software Community Launch
description:
url: http://reynard.io/events/2017/03/27/DataboxLaunchMarch2017.html
date: 2017-03-27T00:00:00-00:00
preview_image:
featured:
authors:
- reynard
---

<p>The team working on the <a href="http://www.databoxproject.uk/">Databox Project</a> hosted their Cambridge open-source community launch on Friday 24th March at <a href="https://www.darwin.cam.ac.uk/">Darwin College</a>, Cambridge.</p>

<p><strong>UPDATE: <a href="https://www.databoxproject.uk/2017/03/28/databox-open-source-software-community-launch-2/">Slides and notes</a> from the event are now available</strong></p>

<p>The event served to introduce the motives behind Databox, the structure of the project and to gauge use cases within the community and potential application developers. The team presented the initial release of a working open source Databox platform, which includes basic data collection support through mobile sensing libraries and selected APIs, provides basic data flow policing and privacy policy enforcement, and supports installation and operation of simple personal data processing apps.</p>

<p>
<img src="http://reynard.io/images/databox.jpg" alt="Stage 1" width="200"/>
<img src="http://reynard.io/images/databox2.jpg" alt="Stage 1" width="200"/>
<img src="http://reynard.io/images/databox3.jpg" alt="Stage 1" width="200"/>
</p>

<p><em>Photos courtesy of <a href="https://twitter.com/realhamed">Hamed Haddadi</a>.</em></p>

<p><strong>&ldquo;Can we do detailed, user-centric, contextual analytics at a scalable rate without privacy disasters and legal challenges?&rdquo;</strong></p>

<p>The morning session began with a formal introduction by <a href="https://twitter.com/realhamed">Hamed Haddadi</a> into the research project itself, explaining the high-level goals of the project: &ldquo;Can we do detailed, user-centric, contextual analytics at a scalable rate without privacy disasters and legal challenges?&rdquo; <a href="https://github.com/mor1">Richard Mortier</a> followed with a summary of the technical architecture of the Databox and described the driving motive as an open-source, personal networked system, <strong>NOT</strong> another data silo that acts as a honey pot - the focus being to move computation to where the data is, thus reducing the movement of data itself. <a href="https://github.com/Toshbrown">Tosh Brown</a> and <a href="https://github.com/yousefamar">Yousef Amar</a> then followed with (working!) demonstrations of the Databox SDK and UI, and development of drivers and applications at the container level.</p>

<p>The afternoon session was driven by the attendees, who were all asked to propose applications for and uses of the Databox, with small focus groups facilitating this development.</p>

<p>See my raw notes from the event below.</p>

<p>Thank you to all those who attended, the Databox Project team, and to the staff at Darwin College.</p>

<p><strong>Contribute to the open-source software Databox project</strong></p>

<p>You can contribute to the open-source Databox prototype by visiting the <a href="https://github.com/me-box">repository</a> and checking out the:</p>

<ul>
  <li><a href="https://github.com/me-box/databox">code</a></li>
  <li><a href="https://github.com/me-box/documents">docs</a></li>
  <li><a href="https://github.com/me-box/databox-app-template-node">application</a> templates</li>
  <li><a href="https://github.com/me-box/databox-driver-template-node">driver</a> templates</li>
</ul>

<p>Join the community discussion in the <a href="https://forum.databoxproject.uk/">Databox Discourse</a> forum.</p>

<hr/>

<h2>Motivations</h2>

<p>The Databox seeks to collate, curate and mediate third-party access to your personal data, whilst creating a user-friendly environment to effectively manage your data. We are generating data more than ever in the form of wearables, social media etc, and our digital footprint can be used by third parties to infer a wealth of information about us. Currently the user has little choice about which data is shared and with whom it is shared - we need a privacy-aware data analytics platform.</p>

<h2>Technical Architecture and Design Principles</h2>

<p>Performing local data processing and moving data as little as possible has benefits including:</p>

<ul>
  <li>context retention</li>
  <li>reduction of honey pot effects</li>
  <li>efficiency, and latency reduction</li>
  <li>more varied sources of accessible data: Twitter, home IoT devices, smartphone sensing etc</li>
</ul>

<h3>Design principles:</h3>

<ul>
  <li>clear separation of components
    <ul>
      <li>intercommunication via specified applications</li>
      <li>use of containers e.g. docker</li>
    </ul>
  </li>
  <li>distinct data sources represented by distinct data stores - if one is leaked, only that data is exposed, not all data</li>
  <li>components are disconnected by default - reduces the attack surface - containers cannot talk to arbitrary cloud services - they will have to go through an export service</li>
  <li>data flow logged for audit - log store for audit with tools to process logging information
    <ul>
      <li>how is data being used and moved/exported</li>
      <li>data processing is transparent to users to allow better control and understanding</li>
    </ul>
  </li>
</ul>

<p>Platform components that form the core:</p>

<ul>
  <li>container manager: managing apps, starting/stopping containers - UI/dashboard</li>
  <li>log store (separate container currently) to log all actions</li>
  <li>arbiter: minting tokens, permissions (separate container atm), root level catalogue uses hypercat with nested catalogues</li>
  <li>export service: data is taken off the box and sent elsewhere - specific set of requirements meaning that no data can leave the box without being permitted to do so by the user</li>
</ul>

<p>Dynamic components that you may install to interact with services and data:</p>

<ul>
  <li>drivers - interact with services e.g. Hue, Twitter - drivers are containers. Interaction via RestAPI with a data store attached for those logs</li>
  <li>apps process the data, where the computation is. Apps installed as containers with explicit permissions upon installation and provided by the arbiter to allow them to access specific data.</li>
</ul>

<h2>UI and SDK</h2>

<p>The <a href="https://sdk.iotdatabox.com/login">SDK</a> provides a user-friendly cloud environment for building Databox applications quickly, and finding approved applications to use on your own Databox - you simply require a GitHub login to access it. The graphical programming environment allows you drag in and connect nodes, view the function output, and debug if needed. There are other useful details such as built-in virtualisations that allow you to view your data as graphs, lists etc, and application manifests which include any resources your app needs and different levels of functionality to correspond with existing devices. Current applications include Hue lights, a mobile sensing driver and Twitter.</p>

<p>
<img src="http://reynard.io/images/DataboxSDK.png" alt="Stage 1" width="200"/>
</p>

<h2>Apps and Drivers</h2>

<p>In the Databox, an application can talk interact with 3 areas:</p>

<ul>
  <li>stores (both data and driver)</li>
  <li>arbiter</li>
  <li>export service</li>
</ul>

<p>An application includes:</p>

<ul>
  <li>app manifests: description, resources required, metadata, textual representation of permissions that the app might request, standard dockerfile (+ databox label, and UI port exposure details) to build app</li>
  <li>environment variables: urls for containers to connect to, data source metadata in <a href="http://www.hypercat.io/">Hypercat</a> format, url for data source store, CA root certificate for the container for use over https (and a private key if you want to host on https server)</li>
</ul>

