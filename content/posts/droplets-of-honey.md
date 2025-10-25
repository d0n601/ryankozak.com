+++
title = 'Droplets of Honey: The Modern Honeypot Network'
date = 2015-12-17T02:57:04+00:00
hideToc = true
description = "Setup and deployment of Modern Honeypot Network (MHN) on Digital Ocean droplets for monitoring and analyzing cyber attacks."
+++
## Easy Setup

I've been meaning to play with honeypots for quite some time, and if I'd given it just a little more research, I'd have started much sooner. This is because shortly after deciding upon [glastopf](https://github.com/gbrindisi/wordpot) as the first on my list of honey pots  to try out, I came across [mhn](https://github.com/threatstream/mhn), an open source project by [Threat Stream](https://www.threatstream.com/).

The Modern Honeypot Network (mhn) makes not only launching honeypots insanely easy, but it serves as a nice way of monitoring multiple honeypots as well. [Digital Ocean](https://www.digitalocean.com/) Droplets  seemed like a cheap and safe way of getting started, and I quickly found [this post](https://zeltser.com/modern-honey-network-experiments/) by [Lenny Zeltser](https://zeltser.com/) which provides pretty good directions to anyone wanting to do this themselves.

My initial plan to create a single [glastpof](http://glastopf.org/) installation evolved into two more honeypots, one being [dionea](https://github.com/rep/dionaea), and the other [Wordpot.](https://github.com/gbrindisi/wordpot)

## Results So Far

After only 2 days of attacks there has certainly been a lot recorded, but I've not had the time to properly look into any of them yet. The Most prominent port for probes seems to be 5060, looking for phone system vulnerabilities I assume. [Dionea](https://github.com/rep/dionaea) has yet to capture any binaries, and [Wordpot](https://github.com/gbrindisi/wordpot) has been probed only 4 times.

I did do port scans on a few of the attacking IP Addresses and have seen a few older versions of Windows (2003, XP) with open VNC ports...

![sketchy](/posts/images/droplets-of-honey/sketch.png)


## Further

With more time will come more data, and then the real fun begins.

The REST API included  in the MHN Framework makes sending the data to other applications simple. You can view the data for my honeypots over the <del>Last 24 hours here.</del>

For more information on the Modern Honey Network see [Threat Stream's blog post](https://www.threatstream.com/blog/mhn-modern-honey-network).


## UPDATE 10/4/2016
I've stopped running my droplets recently. Other projects have taken up the bulk of my time and I no longer have the time to dedicate to monitoring them. The plugin I was using to connect this site and the Modern Honey Network Server can be found on my [Github here](https://github.com/d0n601/wp-mhn)
