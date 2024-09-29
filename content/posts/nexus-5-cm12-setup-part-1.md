+++
title = 'Nexus 5 Cm12 Setup Part 1'
date = 2015-03-04T18:08:19+00:00
hideToc = true
+++
Within the same week, my girlfriend and I both found ourselves without phones. Her Galaxy took a soaking in the ladies room, and my late Nexus 5 had ceased to charge despite all repair effort. So now, I find myself with two fresh Nexus 5's, a white for my girlfriend and a black one for myself, running `Android Lolipop 5.0.1`.

I'm going to walk through the process of  what I've done setting up the devices. They are almost completely open source, with additional security and privacy features to be installed in Part 2. This is written as a fairly high level overview of the process, so I'll try not to get into the nittygritty. This isn't intended as a walk-through.

Since it had been a while since I played with my phone, I had to install some of the [Android Developer Tools](http://developer.android.com/sdk/installing/index.html?pkg=tools), _adb_ and _fastboot_. In my case that meant a quick,

```
sudo apt-get install android-tools-adb
sudo apt-get install android-tools-fastboot
```
(thanks Debian)

In order to use these tools, usb debugging had to be enabled. Turning on developer mode had to be done first by navigating to,

`Settings>>About Phone>>Build Number`

I don't know how many times, but by tapping the menu item rapidly, it will enable Developer Mode, and display *Developer Options* in Settings Menu. After that , USB Debugging needed to be checked for this process to continue.

With the phone turned on the following commands reboot the phone to the bootloader, and unlock it.

```bash
sudo adb reboot bootloader  
sudo fastboot oem unlock
```

It's that easy, gotta love Nexus devices for that.

Flashing the recovery was the next step. I've used both [TWRP](http://teamw.in/project/twrp2) and [CWM](https://www.clockworkmod.com/) before. Initially, I attempted to flash [TWRP](http://teamw.in/project/twrp2), however it just wouldn't stick, and would reboot to a stock recovery each flash. I tried a few versions (2.8.0.1 through 2.8.0.4). After researching various potential solutions, I bagged it and decided to flash [CMW](https://www.clockworkmod.com/). This stuck the first time, [download here](https://www.clockworkmod.com/rommanager). I don't find myself in recovery that often, and I'm not married to either...whatever works. I went with the touch version which as of writing this is version 6.0.4.5.

Once more I rebooted the phone into the bootloader, and then flashed CWM to the Nexus 5 recovery partition.

```bash
sudo adb reboot bootloader
sudo fasboot flash recovery ./recovery-clockwork-touch-6.0.4.5-hammerhead.img
```

I chose to go with Cyanogen Mod. As of writing, this CM12 doesn't have a stable build yet, and I've been flashing the nightlies every few days. The stability has actually been really good. The Nexus 5 is codenammed *Hammer Head* and releases of Cyanogen Mod can be found for it at [https://download.cyanogenmod.org/?device=hammerhead](https://download.cyanogenmod.org/?device=hammerhead), and the change log here [http://www.cmxlog.com/12/hammerhead/](http://www.cmxlog.com/12/hammerhead/).

Flashing the Cyanogen Mod ROM went slightly differently for each phone. Both processes started with another reboot, this time to the newly flashed recovery partition. The caches are wiped in recovery, then

```bash
sudo adb reboot recovery
```

After the phones were in recovery, my girlfriends phone took the Cyanogen Mod zip file via adb push

```bash
sudo adb push ./cm-12-20150208-NIGHTLY-hammerhead.zip /sdcard<br />
```

In the CWM recovery, I was able to install the zip from the sdcard. Oddly, my phone kept telling me the push was successful, yet the zip did not appear on my sdcard. This obstacle was overcome by installing the zip via an adb sideload

```bash
sudo adb sideload ./cm-12-20150124-NIGHTLY-hammerhead.zip
```

After a reboot, the phones were running CM12, however, they weren't rooted. Booting back into recovery, the [zip file](http://www.devfiles.co/download/pJGDQP7n/UPDATE-SuperSU-v2.16.zip) for superuser must be placed in the file system.

```bash
sudo adb push ./UPDATE-SuperSU-v2.16.zip /sdcard
```

From there, it can be installed via the recovery. Downloading SU from the the Play Store [apk downloader](http://apps.evozi.com/apk-downloader/), and the phone is rooted and ready for you to set it up however you want.