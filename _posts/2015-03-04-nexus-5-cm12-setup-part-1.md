---
title: 'Nexus 5 CM12 Setup Part 1'
date: 2015-03-04T18:08:19+00:00
author: Ryan Kozak
description: Installing Cyanogen Mod 12 on the Nexus 5 for privacy and flexibility, remove Google from the Nexus 5.
layout: post
permalink: /nexus-5-cm12-setup-part-1/
image: /wp-content/uploads/2015/03/Install-Android-5.0-Lollipop-CM12-on-OnePlus-One.jpg
categories:
  - Security
tags:
  - Android
  - Cyanogen Mod
---
Within the same week, my girlfriend and I both found ourselves without phones. Her Galaxy took a soaking in the ladies room, and my late Nexus 5 had ceased to charge despite all repair effort. So now, I find myself with two fresh Nexus 5&#8217;s, a white for my girlfriend and a black one for myself, running Android Lolipop 5.0.1

I&#8217;m going to walk through the process of  what I&#8217;ve done setting up the devices. They are almost completely open source, with additional security and privacy features to be installed in Part 2. This is written as a fairly high level overview of the process, so I&#8217;ll try not to get into the nittygritty. This isn&#8217;t intended as a walk-through.

Since it had been a while since I played with my phone, I had to install some of the <a title="Android SDK Installation for all Platforms" href="http://developer.android.com/sdk/installing/index.html?pkg=tools" target="_blank">Android Developer Tools</a>, _adb_ and _fastboot_. In my case that meant a quick,

```
sudo apt-get install android-tools-adb
sudo apt-get install android-tools-fastboot
```
(thanks Debian)

In order to use these tools, usb debugging had to be enabled. Turning on developer mode had to be done first by navigating to,

`Settings>>About Phone>>Build Number`

I don&#8217;t know how many times, but by tapping the menu item rapidly, it will enable Developer Mode, and display &#8220;Developer Options&#8221; in Settings Menu. After that , USB Debugging needed to be checked for this process to continue.

With the phone turned on the following commands reboot the phone to the bootloader, and unlock it.

```
sudo adb reboot bootloader  
sudo fastboot oem unlock
```

It&#8217;s that easy, gotta love Nexus devices for that.

Flashing the recovery was the next step. I&#8217;ve used both <a title="Team Win Recovery Project" href="http://teamw.in/project/twrp2" target="_blank">TWRP</a> and <a href="https://www.clockworkmod.com/" target="_blank">CWM</a> before. Initially, I attempted to flash <a title="Team Win Recovery Project" href="http://teamw.in/project/twrp2" target="_blank">TWRP</a>, however it just wouldn&#8217;t stick, and would reboot to a stock recovery each flash. I tried a few versions (2.8.0.1 through 2.8.0.4). After researching various potential solutions, I bagged it and decided to flash <a href="https://www.clockworkmod.com/" target="_blank">CMW</a>. This stuck the first time, <a title="CWM Device Download List" href="https://www.clockworkmod.com/rommanager" target="_blank">download here</a>. I don&#8217;t find myself in recovery that often, and I&#8217;m not married to either&#8230;whatever works. I went with the touch version which as of writing this is version 6.0.4.5.

Once more I rebooted the phone into the bootloader, and then flashed CWM to the Nexus 5 recovery partition.

`sudo adb reboot bootloader`

`sudo fasboot flash recovery ./recovery-clockwork-touch-6.0.4.5-hammerhead.img`

I chose to go with Cyanogen Mod. As of writing, this CM12 doesn&#8217;t have a stable build yet, and I&#8217;ve been flashing the nightlies every few days. The stability has actually been really good. The Nexus 5 is codenammed &#8220;Hammer Head&#8221; and releases of Cyanogen Mod can be found for it at <a title="Cyanogen Mod Nexus 5 Download" href="https://download.cyanogenmod.org/?device=hammerhead" target="_blank">https://download.cyanogenmod.org/?device=hammerhead</a>

and the change log here <a title="Nexus 5 Cyanogen Mod Change Log" href="http://www.cmxlog.com/12/hammerhead/" target="_blank">http://www.cmxlog.com/12/hammerhead/</a>

Flashing the Cyanogen Mod ROM went slightly differently for each phone. Both processes started with another reboot, this time to the newly flashed recovery partition. The caches are wiped in recovery, then

`sudo adb reboot recovery`

After the phones were in recovery, my girlfriends phone took the Cyanogen Mod zip file via adb push

`sudo adb push ./cm-12-20150208-NIGHTLY-hammerhead.zip /sdcard<br />
`

In the CWM recovery, I was able to install the zip from the sdcard. Oddly, my phone kept telling me the push was successful, yet the zip did not appear on my sdcard. This obstacle was overcome by installing the zip via an adb sideload

`sudo adb sideload ./cm-12-20150124-NIGHTLY-hammerhead.zip`

After a reboot, the phones were running CM12, however, they weren&#8217;t rooted. Booting back into recovery, the <a title="Nexus 5 Super User Zip" href="http://www.devfiles.co/download/pJGDQP7n/UPDATE-SuperSU-v2.16.zip" target="_blank">zip file</a> for superuser must be placed in the file system.

`sudo adb push ./UPDATE-SuperSU-v2.16.zip /sdcard<br />
`

From there, it can be installed via the recovery. Downloading SU from the the Play Store (<a title="Android APK Downloader" href="http://apps.evozi.com/apk-downloader/" target="_blank">apk downloader</a>), and the phone is rooted and ready for Part 2&#8230;coming soon
