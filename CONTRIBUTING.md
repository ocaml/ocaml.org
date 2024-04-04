# How to Contribute

Welcome to OCaml.org's contributing guide. Thank you for taking the time to read it! Your help with OCaml.org is extremely welcome. We are particularly motivated to support new contributors and people who are looking to learn and develop their skills. If you get stuck, please don’t hesitate to [ask questions on discuss](https://discuss.ocaml.org/) or [raise an issue](https://github.com/ocaml/ocaml.org/issues/new).

This guide documents the best way to contribute to the project when adding things listed below in Contributing Content. If you're looking for a guide on how to setup the project and suggest a change to the code, you can refer to our [HACKING](./HACKING.md) guide, which will also give instructions on how to rebuild the website, if necessary, when making changes.

- **Good First Issues**: if you are either new to the repository or still getting started with OCaml in general, issues marked as a `good first issue` are ideal.
- **Suggesting Changes**: most of the site content is stored in the `data` directory as Markdown or YAML. To suggest a change or update this content, you can edit those files directly and rebuild the website, detailed in the [HACKING](./HACKING.md) guide. This will promote the content into their `.ml` counterparts. If you would like to suggest entirely new website content or code, please [open an issue](https://github.com/ocaml/ocaml.org/issues) to discuss it first.
- **Implementing Pages**: most pages are implemented in `src/ocamlorg_frontend/pages` using the [.eml templating preprocessor](https://aantron.github.io/dream/#templates). This is mixture or OCaml and HTML.

## Reporting Bugs

We use GitHub issues to track all bugs and feature requests. Feel free to open an issue over [here](https://github.com/ocaml/ocaml.org/issues/new) if you have found a bug or wish to see a feature implemented.

Please include images and browser-specific information if the bug is related to some visual aspect of the site. This tends to make it easier to reproduce and fix.

## Contributing Content

We've provided a list of community-driven content below. When adding content to any of these sections, it's best to fork the repo, add your file, and open a pull request (PR).

- [Images](#images)
- [The OCaml Planet Blog](#content-blog)
- [Job Board](#content-job)
- [Success Stories](#content-success-story)
- [Academic and Industrial Users](#content-user)
- [OCaml Books](#content-book)
- [OCaml Cookbook Recipes](#content-cookbook)
- [Recurring Events](#content-recurring-event)
- [Upcoming Events](#content-upcoming_event)
- [The OCaml Changelog](#content-changelog)

The following sections give more details on how to contribute to each.

### <a name="images"></a>Adding Images

Some of the data that can be contributed by users may include images or other media, for example, success stories, academic and industrial users, or books.

Images can be added to the corresponding subfolder in the `data/media/` folder.

E.g. for adding a university logo associated with an academic institution, you have to add the image file to the `data/media/academic_institution/` folder.

Videos or other media should not be added to the ocaml.org GitHub repository.

### <a name="content-blog"></a>Add an RSS Feed to the Blog

Anyone can contribute to the [OCaml Blog](https://ocaml.org/blog), which is composed of two types of content:

- Community blog posts fetched from RSS feeds
- Original blog posts linked from original source

#### Fetched from RSS Feed

If you write about OCaml and have an RSS or Atom feed, you can add your feed to [`data/planet-sources.yml`](data/planet-sources.yml).

When compiling, the feed entries will be downloaded, and Markdown files for each item will be created in [`data/rss`](data/rss/). For instance: [building-ahrefs-codebase-with-melange.md`](data/rss/ahrefs/building-ahrefs-codebase-with-melange.md).

Please, make sure your feed only contains articles about OCaml.

#### Link Original Blog Post

To contribute a link to your original blog post (under [OCaml Community Blog](https://ocaml.org/blog)), you can add a new Markdown file in [`data/planet/-individual_external_links/`](data/planet/-individual_external_links/).

Create an `.md` file with the following header:

```
---
title: title of your self-hosted post here
description: one-sentence description
url: direct URL to your original blog post
date: 2023-06-13  (this format)
preview_image: direct link to preview image
---
```

### <a name="content-job"></a>Add an Entry to the Job Board

> Contribute to the [Job Board](https://ocaml.org/jobs).

The job board displays OCaml job opportunities.

To add a new entry to the job board, you can add it to [`data/jobs.yml`](data/jobs.yml).

Please make sure that the job involves mostly writing OCaml. Contributions to add jobs unrelated to OCaml, or where OCaml is a negligible part of the job, won't be accepted.

If you notice that a job opportunity is outdated (e.g., already fulfilled or not open anymore), PRs to remove it are welcome as well.

### <a name="content-success-story"></a>Add a Success Story

> Contribute to the [Success Stories](https://ocaml.org/success-stories).

You can contribute a new success story by adding a Markdown file in [data/success_stories/](data/success_stories/). For instance: [janestreet.md](data/success_stories/janestreet.md).

The success stories should be structured in the following way:

- An overview of your company
- The challenge you faced and solved
- The solution you implemented, which should describe the role OCaml played in solving the challenge
- A post-mortem describing the results you had after implementing the solution

You can read [Ahref's success story](https://ocaml.org/success-stories/peta-byte-scale-web-crawler) for an examplary success story.

### <a name="content-user"></a>Add an Academic or Industrial User

> Contribute to the [Academic Users](https://ocaml.org/academic-users) and [Industrial Users](https://ocaml.org/industrial-users).

You can add a new academic user by creating a new Markdown file in [data/industrial_users/](data/industrial_users/). For instance: [cryptosense.md](data/industrial_users/cryptosense.md).

You can add a new industrial user by creating a new Markdown file in [data/academic_institutions/](data/academic_institutions). For instance: [cornell.md](data/academic_institutions/cornell.md).

### <a name="content-book"></a>Add a Book

> Contribute to the [OCaml Books](https://ocaml.org/books).

You can add a new OCaml book by creating a new Markdown file in [data/books/](data/books/). For instance: [ocaml-from-the-very-beginning.md](data/books/ocaml-from-the-very-beginning.md).

### <a name="content-cookbook"></a>Add a Recipe to the OCaml Cookbook

The OCaml cookbook is a place where OCaml developers share how to solve common
tasks in OCaml using packages from the OCaml ecosystem.

Here are the steps to contribute a recipe for an existing task:
* Find the task in the [data/cookbook/tasks.yml](data/cookbook/tasks.yml) file
* Go to the task folder inside [data/cookbook/](data/cookbook/) which has the
  same name as the task's `slug`
* Create a Caml file containing the recipe and a Yaml header with metadata about
  the recipe.

If the recipe does not fit into any existing task, you also need to create a
task. Add a `task:` entry in [data/cookbook/tasks.yml](data/cookbook/tasks.yml)
file. Fields `title`, `description` and `slug` are mandatory. The task must be
located under a relevant `category:` field.

Finally, it is also possible to create and organize groups of tasks by creating
new categories. Categories are recursive and may have subcategories, which are
full categories too. A task listed in
[data/cookbook/tasks.yml](data/cookbook/tasks.yml) may have no recipes yet. The
other way, it is not allowed to have a task folder in
[data/cookbook/](data/cookbook/) which does not correspond to a task from the
[data/cookbook/tasks.yml](data/cookbook/tasks.yml) file, it triggers a
compilation error.

Each recipe is a way to perform a task using a combination of open-source
libraries. Writing a recipe as simple as using a single function call from a
package that does the job is acceptable. That does not apply to the standard
library.

### <a name="content-recurring-event"></a>Add A Recurring Event

> Contribute a [Recurring Event](https://ocaml.org/community).

You can add a new recurring event by adding it to the YAML file [data/events/recurring.yml](data/events/recurring.yml).

### <a name="content-upcoming_event"></a> Add an Upcoming Event

> Contribute to the [Upcoming Event](https://ocaml.org/community).

You can add a new upcoming event by creating a new Markdown file in [data/events/](data/events/).

### <a name="content-changelog"></a>OCaml Changelog

The [OCaml Changelog](https://ocaml.org/changelog) is a feed of the latest releases and feature highlights for official OCaml projects. As of today, it features the following projects:

- [The OCaml Compiler](https://github.com/ocaml/ocaml)
- [OCaml Platform Tools](https://ocaml.org/docs/platform)

Before a release of the above tools land on the `opam-repository`, the release manager of the project opens a pull request (PR) on OCaml.org with an announcement for the release.

The announcement is proofread by the OCaml.org team, who will also suggest highlighting release features.

To contribute to a new release announcement or feature highlight, add a Markdown file in `data/changelog/`.

## Git and GitHub Workflow

The preferred workflow for contributing to a repository is to fork the main repository on GitHub, clone, and develop on a new branch.

If you aren't familiar with how to work with Github or would like to learn it, here is [a great tutorial](https://app.egghead.io/playlists/how-to-contribute-to-an-open-source-project-on-github).

Feel free to use any approach while creating a PR. Here are a few suggestions from the dev team:

- If you are not sure whether your changes will be accepted or want to discuss the method before delving into it, please create an issue and ask.
- Clone the repo locally (or continue editing directly in GitHub if the change is small). Checkout
  out the branch that you created.
- Create a draft PR with a small initial commit. Here's how you can [create a draft pull request.](https://github.blog/2019-02-14-introducing-draft-pull-requests/).
- Continue developing and feel free to ask questions in the PR if you run into obstacles or uncertainty as you make changes
- Review your implementation according to the checks noted in the PR template.
- Once you feel your branch is ready, change the PR status to "ready to review."
- Consult the tasks noted in the PR template.
- When merging, consider cleaning up the commit body.
- Close any issues that were addressed by this PR.
