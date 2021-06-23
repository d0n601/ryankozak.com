---
layout: post
title: "Goodbye WordPress"
date: "2018-03-27 19:43:11 -0700"
author: Ryan Kozak
description: Ditching Wordpress for Jekyll, no more database on my personal site.
permalink: /hello-jekyll/
categories:
  - Web Development
tags:
  - Jekyll
  - Wordpress
  - Blogging
---


## Hello Jekyll
I've been intending on migrating my blog to a static site for quite some time, for security, speed, and generally just being more minimalist. The primary issue preventing me from making the change was fear of commitment. [Hugo](https://gohugo.io/) looked like an excellent option, as did [Hyde](https://hyde.github.io/) (not to be confused with the Jekyll Template). I decided to go with [Jekyll](https://jekyllrb.com/) simply because of the size of its community, and because of GitHub Pages (which I'm still not using until they support HTTPS for custom domains).

### Getting There
The process of migrating my site from WordPress to [Jekyll](https://jekyllrb.com/) was rather painless thanks to [Ben Balter's plugin](https://github.com/benbalter/wordpress-to-jekyll-exporter). Migrating my comments from WP to [Disqus](https://disqus.com/) was slightly more complicated.


#### Hydeout Theme
[Hydeout](https://github.com/fongandrew/hydeout) looked extremely similar to my [WordPress](https://wordpress.org) theme from a visitors perspective, so it was a natural choice. It's very well laid out, and everything feels "right" now when I'm making modifications to the site. It's a pleasure to no longer have to work with a functions.php, and even think about "the loop".

#### vim-jekyll
Logging into WP to post blogs and update plugins started to feel almost depressing. It felt like such overkill, and working with it professionally is one of my least favorite things to do. I think that work and pleasure needed to be way more separate, and having a WP blog almost made me avoid blogging. Being able to post from the terminal thanks to [vim-jekyll](https://github.com/VundleVim/Vundle.vim), and push and update via git, gives me that silly feeling I need to be motivated to even write anything at all.
