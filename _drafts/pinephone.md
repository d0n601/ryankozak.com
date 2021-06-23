---
title: "Got my PinePhone Brave Heart" 
author: Ryan Kozak
layout: post
permalink: /pinephone/
categories:
  - Security
tags:
  - Pine64
  - PinePhone
  - Linux Phone
---



### UBPorts Setup shit!
https://help.ubuntu.com/community/SyncEvolution/Synchronize-evolution-data-with-caldav-cardav-server



Downloading the [latest](https://ci.ubports.com/job/rootfs/job/rootfs-pinephone/) build of UBPorts build kept failing in Firefox, over and over and over. Because of that, I used wget so when the connection dropped me it would automatically restart.

```console
x@wartop:~/Downloads$ wget --tries=0 https://ci.ubports.com/job/rootfs/job/rootfs-pinephone/lastBuild/artifact/ubuntu-touch-pinephone.img.gz
````


New builds can be found here.  
https://ci.ubports.com/job/rootfs/job/rootfs-pinephone/ 