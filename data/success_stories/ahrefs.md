---
title: Peta-Byte Scale Web Crawler
logo: success-stories/white/ahrefs.svg
background: /success-stories/ahrefs-bg.jpg
theme: blue
synopsis: "Ahrefs crawls the entire internet constantly to collect, process, and store data to build an all-in-one SEO toolkit."
url: https://ahrefs.com/
priority: 2
---

Ahrefs develops custom distributed petabyte-scale storage and runs an internet-wide crawler to index the entire Web. The company also builds various analytical services for end users. Ahrefs’s data processing system uses OCaml as its primary language, which currently processes up to 6 billion pages a day, and they also use OCaml for their website’s backend. Ahrefs has a multinational team with roots in the Ukraine, an office in Singapore, and remote collaborators all around the world.

## Challenge

Ahrefs runs with a relatively small team compared to the size of the task at hand. Indexing the web is very expensive and requires considerable resources, both humans and machines. Turning petabytes of data into something intelligible on the fly is also a big challenge. It’s necessary to build processes running fast, 24/7, with as little maintenance as possible and scarce human resources.

## Solution

Ahrefs went with OCaml for data processing at the scale of the Web. The company was in its infancy with a limited number of employees and little financial resources. The language provided a combination of qualities hard to find elsewhere:
- Native compilation
- High-level types for clear expression and compact code
- Solid and stable compiler
- Empathy for industrial users

As the company grew and expanded its service offerings, they took the opportunity to write its website in OCaml (native OCaml for the backend, ReasonML for the frontend). This bold choice gave them a unique advantage. Thanks to the types shared across the entire stack, they can safely reason about data, from creation to final consumption.

## Results

Ahrefs turns billions of websites into data, first stored into over 100PB of storage and then into valuable information for tens of thousands of customers worldwide. As the internet is becoming an increasingly competitive place, Ahrefs provides a vital service for companies running a business on the web. Ahrefs managed to face this challenge while keeping the company lean and efficient.
