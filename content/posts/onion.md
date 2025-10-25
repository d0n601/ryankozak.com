+++
title = 'Onion'
date = 2019-06-25T04:29:33-07:00
hideToc = true
description = "Setting up Tor hidden service for personal blog, providing privacy-focused access via .onion address for anonymous browsing."
+++

>My .onion address: [http://ryankozj554xw2ystipdnvpzrge22pkcogw2h5f4n24ztscir6v5d7id.onion/](http://ryankozj554xw2ystipdnvpzrge22pkcogw2h5f4n24ztscir6v5d7id.onion/)

The other day I thought about also running this website as a hidden service. Today I set all that up. It'll admit that it's not all that practical. I'm clearly not hiding who I am, nor am I trying to hide the IP address of my web server, but whatever. It does provide those with extreme privacy concerns the ability to avoid the clearnet while browsing my blog.

I have setup hidden services before but it had been a few years. This sounded like a fun project to help me recover from CTF burnout, and update my knowledge of hidden services.


## v3 Onion Service
My site has been up and running for a while, and getting it running as a hidden service was fairly quick.

The first thing to do was add the respository for [Tor](https://2019.www.torproject.org/docs/debian.html.en). 

```bash
sudo add-apt-repository 'deb https://deb.torproject.org/torproject.org bionic main'
```

Then add the gpg key used to sign the packages.

```bash
curl https://deb.torproject.org/torproject.org/A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89.asc | gpg --import
```

```bash
gpg --export A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 | apt-key add -
```

Refresh sources and install [Tor](https://www.torproject.org/).

```bash
sudo apt-get update
```

```bash
sudo apt-get install tor deb.torproject.org-keyring
```

Create a directory for the hidden service.

```bash
mkdir /var/lib/tor/hidden_service
```

Set the ownership of the hidden service directory to *debian-tor*.

```bash
chown debian-tor:debian-tor /var/lib/tor/hidden_service/
```

Set the permissions of the hidden service directory.

```bash
chmod 0700 /var/lib/tor/hidden_service/
```

Modify the Tor configuration file to include our new hidden service.

```bash
vim /etc/tor/torrc
```

```text
############### This section is just for location-hidden services ###

## Once you have configured a hidden service, you can look at the
## contents of the file ".../hidden_service/hostname" for the address
## to tell people.
##
## HiddenServicePort x y:z says to redirect requests on port x to the
## address y:z.

HiddenServiceDir /var/lib/tor/hidden_service/
HiddenServicePort 80 127.0.0.1:80
HiddenServicePort 443 127.0.0.1:443
```

Lastly, reload apache and tor.

```bash
sudo service tor reload && sudo service apache2 reload
```

## Onion v3 Vanity Address

#### Being Vain
I've always though it was slick when `.onion` sites had a "vanity address". All that means is that the first portion of their address is relevant to the site itself. Proton Mail uses *https://protonirockerxow.onion*, The New York Times uses *https://nytimes3xbfgragh.onion*, and who could forget the notorious Silk Road using *http://silkroadvb5piz3r.onion*.

According to the Tor Projects website,
> Since Tor 0.3.2 and Tor Browser 7.5.a5 56-character long v3 onion addresses are supported and should be used instead.
[Version 3 Specification](https://gitweb.torproject.org/torspec.git/tree/rend-spec-v3.txt).

This means that the vanity address isn't going to look quite as cool as they did back in version 2. Since tor addresses are randomly generated, creating a vanity address requires the generation of tons and tons of keys. The more characters we're looking for to match up in our address, the lower the probability we have of generating one. It's exponentially more difficult to generate longer prefixes. Now that we have `56` characters instead of `16`, our vanity url will look mostly gibberish, instead of only half gibberish like we could get them to be in v2.

I still like them though, and in order to generate one on version 3 I used [mkp224o](https://github.com/cathugger/mkp224o). I really wanted the prefix `ryankozak`, but the best machine I had available to dedicate to the task was an old Intel i7-920 overclocked to 3.4GHz. Since I can't run it for a crazy long time due to electricity being pretty expensive, I took what I could get. I just ran a quick calculation and generated the address [ryankozj554xw2ystipdnvpzrge22pkcogw2h5f4n24ztscir6v5d7id.onion/](http://ryankozj554xw2ystipdnvpzrge22pkcogw2h5f4n24ztscir6v5d7id.onion/). I put that to use by copying it into my hidden_service directory as such,

```bash
cp -R /home/ryan/mkp224o/onions/ryank4ei6f6243kczeyoatrthq4jhumubgtscshub3rttadwqzblw3qd.onion/* /var/lib/tor/hidden_service
```

Then I reloaded Tor once more, now the new onion domain is up and functional. I'll update this post when with my new prefix, or next week when I give up.

![onion](/posts/images/onion/onion_site.png)


### Reference
* [https://2019.www.torproject.org/docs/tor-doc-unix.html.en](https://2019.www.torproject.org/docs/tor-doc-unix.html.en)
* [https://2019.www.torproject.org/docs/debian.html.en#ubuntu](https://2019.www.torproject.org/docs/debian.html.en#ubuntu)
* [https://riseup.net/en/security/network-security/tor/onionservices-best-practices](https://riseup.net/en/security/network-security/tor/onionservices-best-practices])
* [https://www.jamieweb.net/blog/onionv3-vanity-address/](https://www.jamieweb.net/blog/onionv3-vanity-address/)
