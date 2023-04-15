---
title: How to shuffle a big dataset
description: At Jane Street, we often work with data that has a very lowsignal-to-noise
  ratio, but fortunately we also have a lot of data.Where practitioners in many fiel...
url: https://blog.janestreet.com/how-to-shuffle-a-big-dataset/
date: 2018-09-26T00:00:00-00:00
preview_image: https://blog.janestreet.com/how-to-shuffle-a-big-dataset/shuffle_zoom.png
featured:
---

<p>At Jane Street, we often work with data that has a very low
signal-to-noise ratio, but fortunately we also have a <em>lot</em> of data.
Where practitioners in many fields might be accustomed to
having tens or hundreds of thousands of correctly labeled
examples, some of our problems are more like having a billion training
examples whose labels have only a slight tendency to be correct.
These large datasets present a number of interesting engineering
challenges.  The one we address here: <em>How do you shuffle a really
large dataset?</em>  (If you&rsquo;re not familiar with why one might need this,
jump to the section <a href="https://blog.janestreet.com/feed.xml#whyshuffle">Why shuffle</a> below.)</p>


