---
title: "How I Manage Passwords"
author: Ryan Kozak
layout: post
description: Opensource password management using KePassX and NextCloud, an example of how I manage my passwords.
permalink: /how-i-manage-passwords/
categories:
  - Security
tags:
  - open source
  - password management
  - information security
  - php
---

[<img title="Password System Diagram" src="/wp-content/uploads/2019/01/password_setup.png"/>](/wp-content/uploads/2019/01/password_setup.png)

This post is to outline my personal password management system. It relies entirely upon free and open source software, and it is intended to be self hosted. Passwords are synchronized across multiple devices via an encrypted database file. The database is secured by both a password and a key file, which is to be stored locally.  

## Required Software ##
This little system consists of two primary software projects, which are listed below. Do keep in mind the obvious fact that the wrong choice of operating system, network provider, or even hardware, can render the use of these open source projects pointless.

[<img title="There is no such thing as the Cloud"  width="300" align="right" src="/wp-content/uploads/2019/01/their_cloud.png"/>](/wp-content/uploads/2019/01/their_cloud.png)

I encourage everyone to look into a trustworthy [VPN](https://protonvpn.com/) connection to protect themselves from the prying eyes of their ISP, and to look into the many [open source alternatives](https://prism-break.org/en/) to commercial software and operating systems.
Additionally, users looking to build this system should have basic knowledge of the [LAMP](https://en.wikipedia.org/wiki/LAMP_%28software_bundle%29) stack.

### KeePass ###
[<img class="alignleft" title="KeePassX Logo" align="left" src="/wp-content/uploads/2019/01/kpx_logo_main.png"/>](/wp-content/uploads/2019/01/kpx_logo_main.png)
[KeePass](https://keepass.info/) is a free and open source password manager. The European Commission has sponsored bug bounties (EU-FOSSA) to enhance the security of KeePass for the past few years, and I personally cannot think of a more trustworthy password manager to use.

### NextCloud ###
[<img class="alignleft" title="NextCloud Logo" align="left" src="/wp-content/uploads/2019/01/nextcloud.png"/>](/wp-content/uploads/2019/01/nextcloud.png)
[NextCloud](https://nextcloud.com) is an open source PHP application meant to replace services like DropBox and Google Drive. NextCloud is a fork of the [OwnCloud](https://owncloud.org/) project, which predates it by bit.  It's quite simple to configure, and provides many neat features like document editing, contacts, calendar, etc. In this case, we're just using the file syncing functionality to keep the KeePass database synchronized across our devices.


## Setup ##
 1. Install and configure NextCloud on your server. Instructions can be found [here](https://nextcloud.com/install/#instructions-server).
 2. [Download](https://keepass.info/download.html) and install KeePass on all devices with which you'd like to share the password database.
 3. Install the [NextCloud Client](https://nextcloud.com/install/#install-clients) application on all devices with which you'd like to share the password database. I recommend you [download](https://nextcloud.com/install/#install-clients) mobile versions directly from NextCloud themselves, rather than going to the [iOS]((https://prism-break.org/en/categories/ios/)) or [Google Play Store](https://prism-break.org/en/categories/android/).
   * Sync these clients with your NextCloud server.
 4. Create your KeePass database, use a strong password, and check the "Key file" box.
   * Save your .kdbx file into your NextCloud share folder.
   * DO NOT save your key file into your NextCloud share folder. Instead, transfer your key file onto each of your devices manually.



## Analysis ##
As is always the case, there is a trade-off here between convenience and security.

#### Security ####
There are a few layers of security to this.

 * **Layer 0:** The database is held on a server, and on each device. These devices should have security implementations of their own (password protection, file system encryption, etc). This is the primary line of defense in the sense that the database file should be inaccessible to anyone but the owner.
 * **Layer 1:** The user must supply the correct password to decrypt the database file. If a mobile device were to be stolen, the keyfile and database file alone would not suffice to allow a malicious actor to gain access.
 * **Layer 2:** The user must supply a key file. A stolen .kdbx file and compromised password are not enough to decrypt the data.

#### Convenience ####
 * **Pro:** Passwords are long, unique, and can have expiration dates set to them.
 * **Pro:** Accounts and credentials are more easily managed by having a complete record.
 * **Pro:** Changes to the password database made from any device, sync to all devices.
 * **Con:** The key file must be transferred manually on initial setup.
 * **Con:** Accounts can be difficult to access when using a device without KeePass, such as office and university computers.

## Conclusion ##
 For personal use, I've found this method to be the best balance between security and ease of use. I'm able to manage my account credentials easily on all of my devices, and feel rather confident in the security of the password storage mechanism. Users looking to configure a system which can be used by many people, should look into [Passbolt](https://www.passbolt.com/).
