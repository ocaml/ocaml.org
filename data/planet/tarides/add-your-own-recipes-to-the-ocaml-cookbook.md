---
title: Add Your Own Recipes to the OCaml Cookbook!
description: The OCaml Cookbook is open to new contributions! This post gives you
  an overview of the feature and how to add your own recipes.
url: https://tarides.com/blog/2025-07-25-add-your-own-recipes-to-the-ocaml-cookbook
date: 2025-07-25T00:00:00-00:00
preview_image: https://tarides.com/blog/images/recipe-1360w.webp
authors:
- Tarides
source:
ignore:
---

<p>Are you looking to learn something new about OCaml? Or do you want to contribute to the community in a new way? <a href="http://ocaml.org">OCaml.org</a> hosts the <a href="https://ocaml.org/cookbook">OCaml Cookbook</a>, a collection of projects that users can try out, as well as contribute new ones for others to enjoy. This post will introduce you to the concept, show you how to add new recipes, and hopefully leave you inspired to check it out for yourself!</p>
<h2>Why do We Care About <a href="http://ocaml.org">OCaml.org</a>?</h2>
<p>Tarides supports the maintenance and development of OCaml.org, OCaml’s home on the web. Our engineers have spent significant time collaborating with all corners of the OCaml community to update the website, including improving the design, accessibility, documentation, and much more. We continue to fund projects that implement new features that the OCaml community wants and maintain others that they have come to rely on.</p>
<p>As an open-source, collaborative, and shared resource for the ecosystem, OCaml.org is truly a public common. The OCaml Cookbooks are just one example of its many features, which also include tutorials, documentation, news, and an OCaml playground. We encourage more contributors, from sponsors to maintainers, to join the many others in supporting this important resource.</p>
<h2>What is the OCaml Cookbook?</h2>
<p>The <a href="https://ocaml.org/cookbook">OCaml Cookbook</a> is a collection of ‘recipes’, instructions on how to complete tasks as part of projects using open source libraries and tools. The same task can have multiple recipes, each with its unique combination of resources. The result is a varied collection of projects that help users adopt new techniques, try new tools, and gain confidence in OCaml. OCaml’s book currently has recipes on compression, single-threaded concurrency, cryptography, and more!</p>
<p>OCaml is far from the only language to have a cookbook, and the team was inspired to create one by the popular <a href="https://rust-lang-nursery.github.io/rust-cookbook/">Rust Cookbook</a>, as well as Go’s <a href="https://gobyexample.com/">Go by Example</a> introduction to the language.</p>
<h2>How to Contribute</h2>
<p>The team behind the cookbook are always looking for new contributions, and creating a new recipe is straightforward if you follow the <a href="https://github.com/ocaml/ocaml.org/blob/main/CONTRIBUTING.md#content-cookbook">contributing instructions</a>.</p>
<p>To add a new recipe to the cookbook, you will need to start by finding the <a href="https://github.com/ocaml/ocaml.org/tree/main">OCaml.org</a> repo on GitHub. To add a recipe to an existing task, find the task in the <a href="https://github.com/ocaml/ocaml.org/blob/main/data/cookbook/tasks.yml"><code>data/cookbook/tasks.yml</code></a> section, go to the task’s folder inside <a href="https://github.com/ocaml/ocaml.org/tree/main/data/cookbook"><code>data/cookbook/</code></a> which will have the same name as the task’s slug, and create an <code>.ml</code> file with the recipe and a YAML header with metadata about the recipe.</p>
<p>If the recipe you want to add doesn’t match an existing task, you will need to create a new task first. To add a task you will need to make an entry in the <a href="https://github.com/ocaml/ocaml.org/blob/main/data/cookbook/tasks.yml"><code>data/cookbook/tasks.yml</code></a> file. When adding a new task in this file, the title, description, and slug are mandatory fields to fill in, and the task has to be located under a relevant category. You can even create new categories to organise entire groups of new tasks should you wish to do so.</p>
<p>Submitting a recipe will create a pull request, which the group of cookbook moderators will review and, if approved, merge into the website. When picking a recipe to contribute, you should bear the general guidelines in mind: choose a task that you think is relevant to a wide audience; write correct, clear, code that compiles without errors; and check that the packages you’ve chosen and the code are ready for use in production. That’s it, you’re ready to publish!</p>
<h2>What Does a Recipe Look Like?</h2>
<p>Let’s take a quick look at a recipe in action. The <a href="https://ocaml.org/cookbook/salt-and-hash-password-with-argon2/hashargon2">Salt and Hash a Password with Argon2</a> recipe in the Cryptography section shows you how to use the <code>opam</code> package <code>argon2</code> to configure password hashing based on <a href="https://owasp.org/">OWASP</a> recommendations and Argon2 defaults. Be sure to check out the recipe on OCaml.org for the full context and nice formatting!</p>
<p>The recipe includes the code snippets for the configuration:</p>
<pre><code>let t_cost = 2 and
    m_cost = 65536 and
    parallelism = 1 and
    hash_len = 32 and
    salt_len = 10
</code></pre>
<p>The hash output length:</p>
<pre><code>let encoded_len =
  Argon2.encoded_len ~t_cost ~m_cost ~parallelism ~salt_len ~hash_len ~kind:ID
</code></pre>
<p>Generating a salt string:</p>
<pre><code>let gen_salt len =
  let rand_char _ = 65 + (Random.int 26) |&gt; char_of_int in
  String.init len rand_char
</code></pre>
<p>Returning an encoded hash string for the given password:</p>
<pre><code>let hash_password passwd =
  Result.map Argon2.ID.encoded_to_string
    (Argon2.ID.hash_encoded
        ~t_cost ~m_cost ~parallelism ~hash_len ~encoded_len
        ~pwd:passwd ~salt:(gen_salt salt_len))
</code></pre>
<p>And finally, verifying if the encoded hash string matches the given password:</p>
<pre><code>let verify encoded_hash pwd =
  match Argon2.verify ~encoded:encoded_hash ~pwd ~kind:ID with
  | Ok true_or_false -&gt; true_or_false
  | Error VERIFY_MISMATCH -&gt; false
  | Error e -&gt; raise (Failure (Argon2.ErrorCodes.message e))

let () =
  let hashed_pwd = Result.get_ok (hash_password "my insecure password") in
  Printf.printf "Hashed password: %s\n" hashed_pwd;
  let fst_attempt = "my secure password" in
  Printf.printf "'%s' is correct? %B\n" fst_attempt (verify hashed_pwd fst_attempt);
  let snd_attempt = "my insecure password" in
  Printf.printf "'%s' is correct? %B\n" snd_attempt (verify hashed_pwd snd_attempt)
</code></pre>
<h2>Contribute to the CookBook!</h2>
<p>We invite you to take a look at the <a href="https://ocaml.org/cookbook">existing recipes</a> up on the website and bring your own contributions to the book. If you have questions or want input on a recipe, <a href="https://discuss.ocaml.org/">OCaml’s Discuss forum</a> is a great place to post to get tips and feedback.</p>
<p>Stay in touch with Tarides on <a href="https://bsky.app/profile/tarides.com">Bluesky</a>,
<a href="https://mastodon.social/@tarides">Mastodon</a>,
<a href="https://www.threads.net/@taridesltd">Threads</a>, and
<a href="https://www.linkedin.com/company/tarides">LinkedIn</a>. We look forward to
hearing from you!</p>

