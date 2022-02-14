# How to contribute

Welcome to Ocaml.org's contributing guide.

This guide documents the best way to contribute to the project. If you're looking for a guide on how to setup the project and submit a contribution, you can refer to our [HACKING](./HACKING.md) guide.

Thank you for taking the time to read the contributing guide. Your help with Ocaml.org is extremely welcome. If you get stuck, please don’t hesitate to [ask questions on discuss](https://discuss.ocaml.org/) or [raise an issue](https://github.com/ocaml/v3.ocaml.org-server/issues/new).

We are particularly motivated to support new contributors and people who are looking to learn and develop their skills.

- **Good First Issues**: issues marked as a `good first issue` are ideal for people who are either new to the repository or still getting started with OCaml in general.
- **Fixing or Suggesting Content**: most of the content for the site is stored in the `data` directory as markdown or yaml. To fix this content you can edit those files directly and rebuild the website. This will promote the content into their `.ml` counterparts. If you would like to suggest entirely new content please open an issue to discuss it first.
- **Implementing pages**: most pages are implemented in `src/ocamlorg_frontend/pages` using the [.eml templating preprocessor](https://aantron.github.io/dream/#templates). This is mixture or OCaml and HTML.
- **Translating content or pages**: for now we are focusing on getting OCaml.org ready for launch and will add more information about translation later.

## Reporting bugs

We use GitHub issues to track all bugs and feature requests; feel free to open an issue over [here](https://github.com/ocaml/v3.ocaml.org/issues/new) if you have found a bug or wish to see a feature implemented.

Please include images and browser-specific information if the bug is related to some visual aspect of the site. This tends to make it easier to reproduce and fix.

## Contributing content

Here's a list of the content that is community driven and how you can contribute to it:

- [The blog](#content-blog)
- [The job board](#content-job)
- [The success stories](#content-success-story)
- [The academic and industrial users](#content-user)
- [The OCaml books](#content-book)
- [The community events](#content-event)
- [The featured packages](#content-package)

### <a name="content-blog"></a> Add an RSS feed to the blog

> Contribute to the [OCaml Blog](https://v3.ocaml.org/blog).

The blog is composed of two type of content:

- Community blog posts fetched from RSS feeds.
- Original blog posts.

If you write about OCaml and have an RSS or Atom feed, you can add your feed to [`data/rss-sources.yml`](data/rss-sources.yml).

When compiling, the entries of the feed will be downloaded and markdown files for each item of the feed will be created in [`data/rss`](data/rss/). For instance: [building-ahrefs-codebase-with-melange.md`](data/rss/ahrefs/building-ahrefs-codebase-with-melange.md).

Please, make sure your feed only contains articles about OCaml.

To contribute an original blog post (refer to as News on the site), you can add a new markdown file in [`data/news/`](/data/news/). For instance: [`multicore-2021-12.md`](data/news/multicore/multicore-2021-12.md).

If you want to re-publish an blog post you previously posted on Discuss, you can fetch it using Discuss API:

```
curl https://discuss.ocaml.org/raw/<id> > data/news/<fname>.md
```

Where `<id>` is the ID of the Discuss post.

### <a name="content-job"></a> Add an entry to the job board

> Contribute to the [Job Board](https://v3.ocaml.org/opportunities).

The job board displays OCaml job opportunities.

To add a new entry to the job board, you can add it to [`data/jobs.yml`](data/jobs.yml).

Please make sure that the opportunity involves mostly writing OCaml. Contributions to add opportunities unrelated to OCaml, or where OCaml is a negligible part of the opportunity won't be accepted.

If you notice that a job opportunity is outdated (e.g. already fullfilled, or not opened anymore), PRs to remove it are welcome as well.

### <a name="content-success-story"></a> Add a success story

> Contribute to the [Success Stories](https://v3.ocaml.org/success-stories).

You can contribute a new success story by adding a markdown file in [data/success_stories/](data/success_stories/). For instance: [janestreet.md](data/success_stories/en/janestreet.md).

The success stories should be structured in the following way:

- An overview of your company.
- The challenge you faced and solved.
- The solution you implemented, which should describe the role OCaml played in solving the challenge.
- A post-mortem describing the results you had after implementing the solution.

You can read [Ahref's success story](https://v3.ocaml.org/success-stories/peta-byte-scale-web-crawler) for an examplary succes story.

### <a name="content-user"></a> Add an academic or industrial user

> Contribute to the [Academic Users](https://v3.ocaml.org/academic-users) and [Industrial Users](https://v3.ocaml.org/industrial-users).

You can add a new academic user by creating a new markdown file in [data/industrial_users/](data/industrial_users/). For instance: [cryptosense.md](data/industrial_users/en/cryptosense.md).

You can add a new industrial user by creating a new markdown file in [data/academic_institutions/](data/academic_institutions). For instance: [cornell.md](data/academic_institutions/en/cornell.md).

### <a name="content-book"></a> Add a book

> Contribute to the [OCaml Books](https://v3.ocaml.org/books).

You can add a new OCaml book by creating a new markdown file in [data/books/](data/books/). For instance: [ocaml-from-the-very-beginning.md](data/industrial_users/en/ocaml-from-the-very-beginning.md).

### <a name="content-event"></a> Add an event

> Contribute to the [Community Events](https://v3.ocaml.org/community).

You can add a new community event by creating a new markdown file in [data/meetups.yml](data/meetups.yml).

### <a name="content-package"></a> Add a featured packages

> Contribute to the [Featured Packages](https://v3.ocaml.org/packages).

To update the list of Featured Packages in the Packages page, you can update [data/packages.yml](data/packages.yml)

## Git and GitHub workflow

The preferred workflow for contributing to a repository is to fork the main repository on GitHub, clone, and develop on a new branch.

If you aren't familiar with how to work with Github or would like to learn it, here is [a great tutorial](https://app.egghead.io/playlists/how-to-contribute-to-an-open-source-project-on-github).

Feel free to use any approach while creating a pull request. Here are a few suggestions from the dev team:

- If you are not sure whether your changes will be accepted or want to discuss the method before delving into it, please create an issue and ask it.
- Clone the repo locally (or continue editing directly in github if the change is small). Checkout
  out the branch that you created.
- Create a draft pull request with a small initial commit. Here's how you can [create a draft pull request.](https://github.blog/2019-02-14-introducing-draft-pull-requests/)
- Continue developing, feel free to ask questions in the PR, if you run into obstacles or uncertainty as you make changes
- Review your implementation according to the checks noted in the PR template
- Once you feel your branch is ready, change the PR status to "ready to review"
- Consult the tasks noted in the PR template
- When merging, consider cleaning up the commit body
- Close any issues that were addressed by this PR.