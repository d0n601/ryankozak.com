---
title: 'Droplets of Honey &#038; The Modern Honeypot Network'
date: 2015-12-17T02:57:04+00:00
author: Ryan Kozak
description: Setting up web honeypost with Threatstream's Modern Honeypot Network.
layout: post
permalink: /droplets-of-honey/
image: /wp-content/uploads/2015/12/Screen-Shot-2014-06-19-at-4.11.18-PM-e1403222034542.png
categories:
  - Security
tags:
  - Dionea
  - Glastopf
  - Honeypots
  - Modern Honey Network
  - Threat Stream
  - Wordpot
  - Wordpress
---
## Easy Setup

I&#8217;ve been meaning to play with honeypots for quite some time, and if I&#8217;d given it just a little more research, I&#8217;d have started much sooner. This is because shortly after deciding upon [glastopf](https://github.com/gbrindisi/wordpot) as the first on my list of honey pots  to try out, I came across [mhn](https://github.com/threatstream/mhn), an open source project by [Threat Stream](https://www.threatstream.com/).

The Modern Honeypot Network (mhn) makes not only launching honeypots insanely easy, but it serves as a nice way of monitoring multiple honeypots as well. Digital Ocean Droplets  seemed like a cheap and safe way of getting started, and I quickly found [this post](https://zeltser.com/modern-honey-network-experiments/) by [Lenny Zeltser](https://zeltser.com/) which provides pretty good directions to anyone wanting to do this themselves.

My initial plan to create a single [glastpof](http://glastopf.org/) installation evolved into two more honeypots, one being [dionea](https://github.com/rep/dionaea), and the other [Wordpot.](https://github.com/gbrindisi/wordpot)

## Results So Far

After only 2 days of attacks there has certainly been a lot recorded, but I&#8217;ve not had the time to properly look into any of them yet. The Most prominent port for probes seems to be 5060, looking for phone system vulnerabilities I assume. [Dionea](https://github.com/rep/dionaea) has yet to capture any binaries, and [Wordpot](https://github.com/gbrindisi/wordpot) has been probed only 4 times.

I did do port scans on a few of the attacking IP Addresses and have seen a few older versions of Windows (2003, XP) with open VNC ports&#8230;

<a href="/wp-content/uploads/2015/12/Screenshot-from-2015-12-15-210119.png" rel="attachment wp-att-265"><img class="alignleft wp-image-265 size-large" src="/wp-content/uploads/2015/12/Screenshot-from-2015-12-15-210119-1024x576.png" alt="Open VNC Connection on Windows Server 2003" width="660" height="371" srcset="/wp-content/uploads/2015/12/Screenshot-from-2015-12-15-210119-1024x576.png 1024w, /wp-content/uploads/2015/12/Screenshot-from-2015-12-15-210119-300x169.png 300w, /wp-content/uploads/2015/12/Screenshot-from-2015-12-15-210119-768x432.png 768w, /wp-content/uploads/2015/12/Screenshot-from-2015-12-15-210119.png 1600w" sizes="(max-width: 660px) 100vw, 660px" /></a>

&nbsp;

## Further

With more time will come more data, and then the real fun begins.

The REST API included  in the MHN Framework makes sending the data to other applications simple. You can view the data for my honeypots over the <del>Last 24 hours here.</del>

For more information on the Modern Honey Network see [Threat Stream&#8217;s blog post](https://www.threatstream.com/blog/mhn-modern-honey-network).

&nbsp;

## UPDATE 10/4/2016

I&#8217;ve stopped running my droplets recently. Other projects have taken up the bulk of my time and I no longer have the time to dedicate to monitoring them. The plugin I was using to connect this site and the Modern Honey Network Server can be found on my [Github here](https://github.com/d0n601/wp-mhn)
