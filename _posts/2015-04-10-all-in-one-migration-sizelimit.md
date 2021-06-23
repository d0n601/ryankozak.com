---
title: 'Removing the 512MB size limit on All-in-One WP Migration Plugin'
date: 2015-04-10T22:34:29+00:00
author: Ryan Kozak
description: Remove the size limit from the Wordpress All-in-One WP Migration Plugin. An easy hack to freely upload your backups of whatever size. 
layout: post
permalink: /all-in-one-migration-sizelimit/
image: /wp-content/uploads/2015/04/wpmigration8.png
categories:
  - Web Development
tags:
  - php
  - Wordpress
---

## Update, Pay Attention!

#### Bad News
 As of version `6.78` things began to change, first the developers removed the upload feature, and the `wp-cli` functionality. Newer versions of the plugin are really stripped down and include less functionality than `6.77` did. The new version exists on the Wordpress repository almost exclusively to upsell you to the paid version. The new plugin is still hackable, but there are more steps required than what's described below, and like I said, it doesn't work with `wp-cli`. The steps below to increase the plugin size don't work on the new version.


#### Good News
 Use this [https://github.com/d0n601/All-In-One-WP-Migration-With-Import](https://github.com/d0n601/All-In-One-WP-Migration-With-Import) if you'd like. I've increased the upload size limit to 32 GB, it works on the current version of Wordpress, and it also includes `wp-cli` functionality. Just download it as a [zip](https://github.com/d0n601/All-In-One-WP-Migration-With-Import/archive/master.zip) and upload it manually.

## Original Article Below

A WordPress development workflow can be difficult to optimize, especially when working in a team environment. You wont have trouble finding a few well written articles online concerning version control setups and project structures. Setting up a new project is smooth when you&#8217;re using a Git repository of some flavor for your theme content, and <a title="Database Sync WordPress Plugin" href="https://wordpress.org/plugins/database-sync/" target="_blank">Database Sync</a> or a similar plugin to sync your local and live databases.

#### What about the case in which you inherit an existing WordPress site?

It&#8217;s not uncommon to need to pull all of a site&#8217;s plugins, settings, and media content to a local development environment at least initially. This is typically part of our &#8220;on boarding&#8221; process at work.

Simply syncing themes and databases as you typically would in your development workflow is not enough in this instance. With a plugin known as <a title="All in One WP Migration Plugin" href="https://wordpress.org/plugins/all-in-one-wp-migration/" target="_blank">All-in-One WP Migration</a>, you&#8217;re able to export an entire WordPress instance to a single file with an extension .wpress. You&#8217;re then able to turn right back around and import that file to another WordPress installation to create a clone.

Here is what the steps look like to export a production site to a file.

[<img class="aligncenter wp-image-73" title="WordPress All-in-One WP plugin " src="/wp-content/uploads/2015/04/wpmigration1.png" alt="WordPress All-in-One WP plugin Migration Step 1" width="400" height="242" srcset="/wp-content/uploads/2015/04/wpmigration1.png 929w, /wp-content/uploads/2015/04/wpmigration1-300x181.png 300w" sizes="(max-width: 400px) 100vw, 400px" />](/wp-content/uploads/2015/04/wpmigration1.png) [<img class="aligncenter wp-image-74" title="WordPress All-in-One WP plugin Step 2" src="/wp-content/uploads/2015/04/wpmigration2.png" alt="All-in-One WP Step 2" width="400" height="248" srcset="/wp-content/uploads/2015/04/wpmigration2.png 765w, /wp-content/uploads/2015/04/wpmigration2-300x186.png 300w" sizes="(max-width: 400px) 100vw, 400px" />](/wp-content/uploads/2015/04/wpmigration2.png) [<img class="aligncenter wp-image-75" src="/wp-content/uploads/2015/04/wpmigration3.png" alt="wpmigration3" width="400" height="200" srcset="/wp-content/uploads/2015/04/wpmigration3.png 521w, /wp-content/uploads/2015/04/wpmigration3-300x150.png 300w" sizes="(max-width: 400px) 100vw, 400px" />](/wp-content/uploads/2015/04/wpmigration3.png)

At this point, depending upon the size of the backed up file, a blank installation of WordPress may be all that&#8217;s necessary to clone the production site.

[<img class="aligncenter wp-image-81" src="/wp-content/uploads/2015/04/wpmigration4.png" alt="wpmigration4" width="400" height="286" srcset="/wp-content/uploads/2015/04/wpmigration4.png 1278w, /wp-content/uploads/2015/04/wpmigration4-300x215.png 300w, /wp-content/uploads/2015/04/wpmigration4-1024x733.png 1024w" sizes="(max-width: 400px) 100vw, 400px" />](/wp-content/uploads/2015/04/wpmigration4.png)

If the size of your .wpress file exceeds 512MB, you will be prompted to purchase the <a title="WordPress All In One Migration Unlimited Extension" href="https://servmask.com/products/unlimited-extension" target="_blank">Unlimited Extension of All-in-One WP Migration</a>.  If you&#8217;re inheriting a site that&#8217;s been in production for a while, it&#8217;s likely that the backup file is over this small size limit (see a fix for this below).

[<img class="aligncenter wp-image-83" src="/wp-content/uploads/2015/04/wpmigration7.png" alt="wpmigration7" width="400" height="267" srcset="/wp-content/uploads/2015/04/wpmigration7.png 584w, /wp-content/uploads/2015/04/wpmigration7-300x200.png 300w" sizes="(max-width: 400px) 100vw, 400px" />](/wp-content/uploads/2015/04/wpmigration7.png)

[<img class="aligncenter wp-image-82 size-medium" src="/wp-content/uploads/2015/04/wpmigration6-300x90.png" alt="wpmigration6" width="300" height="90" srcset="/wp-content/uploads/2015/04/wpmigration6-300x90.png 300w, /wp-content/uploads/2015/04/wpmigration6.png 402w" sizes="(max-width: 300px) 100vw, 300px" />](/wp-content/uploads/2015/04/wpmigration6.png)

Hacking the plugin seemed like a reasonable thing to try before making the $59 dollar purchase of the Unlimited Extension (which comes with lifetime updates, and unlimited support).

Go ahead and open up `/wp-content/plugins/all-in-one-wp-migration/constants.php`

Search for "Max File Size" with a simple control + f, and you'll be directed to the bit of code below.

### Updated July 20th 2018
As of version 6.72, the line that defines the file upload limit is line 289 of constants.php. The `2 << 28` is the php [bitwise shift left](http://php.net/manual/en/language.operators.bitwise.php) operation, resulting in `536870912` , which is 512MB. You can see the changes made to constants.php between version 6.71 and 6.72 [here](https://plugins.trac.wordpress.org/changeset/1909788/all-in-one-wp-migration/trunk/constants.php?old=1904111&old_path=all-in-one-wp-migration%2Ftrunk%2Fconstants.php). These changes aren't mentioned in the changelog at all, they seem to be an attempt at adding a little "security through obscurity" in order to prevent people from quickly spotting and applying this hack.

```php
// =================
// = Max File Size =
// =================
define( 'AI1WM_MAX_FILE_SIZE', 2 << 28 );
```


Older versions of the plugin (6.71 and below) simply defined the file upload size limit, in bytes, without using the shift operation. Either way though, increasing this limit is extremely easy.


```php
// =================
// = Max File Size =
// =================
define( 'AI1WM_MAX_FILE_SIZE', 536870912 );
```

In order to increase the upload size limit to 4GB, on all versions of the plugin, simply input the number of bytes as the `AI1WM_MAX_FILE_SIZE` constant. See below

```php
// =================
// = Max File Size =
// =================
define( 'AI1WM_MAX_FILE_SIZE', 4294967296 ); // THIS LINE MAKES NEW LIMIT 4GB
```

For the sake of demonstration, let's set the limit even higher.

```php
// =================
// = Max File Size =
// =================
define( 'AI1WM_MAX_FILE_SIZE', 4294967296 * 10 ); // THIS LINE MAKES NEW LIMIT 40GB
```


Save the file and navigate back to the &#8220;import&#8221; function for the All-In-One Migration Plugin. The file upload limit now reads 4GB.

[<img class="aligncenter wp-image-89" src="/wp-content/uploads/2015/04/wpmigration8.png" alt="wpmigration8" width="400" height="197" srcset="/wp-content/uploads/2015/04/wpmigration8.png 406w, /wp-content/uploads/2015/04/wpmigration8-300x148.png 300w" sizes="(max-width: 400px) 100vw, 400px" />](/wp-content/uploads/2015/04/wpmigration8.png)

The plugin will no longer reject your large file uploads.

[<img class="aligncenter wp-image-90" src="/wp-content/uploads/2015/04/wpmigration9.png" alt="wpmigration9" width="400" height="232" srcset="/wp-content/uploads/2015/04/wpmigration9.png 626w, /wp-content/uploads/2015/04/wpmigration9-300x174.png 300w" sizes="(max-width: 400px) 100vw, 400px" />](/wp-content/uploads/2015/04/wpmigration9.png)

[<img class="aligncenter wp-image-92" src="/wp-content/uploads/2015/04/wpmigration10.png" alt="wpmigration10" width="400" height="202" srcset="/wp-content/uploads/2015/04/wpmigration10.png 522w, /wp-content/uploads/2015/04/wpmigration10-300x152.png 300w" sizes="(max-width: 400px) 100vw, 400px" />](/wp-content/uploads/2015/04/wpmigration10.png)

[<img class="aligncenter wp-image-93" src="/wp-content/uploads/2015/04/wpmigration11.png" alt="wpmigration11" width="400" height="184" srcset="/wp-content/uploads/2015/04/wpmigration11.png 533w, /wp-content/uploads/2015/04/wpmigration11-300x138.png 300w" sizes="(max-width: 400px) 100vw, 400px" />](/wp-content/uploads/2015/04/wpmigration11.png)

Note that this plugin does have regular updates, and each update will reset your file upload limit. Because I use this plugin to import existing sites to my local development environment, and not as part of my regular workflow, it&#8217;s not much of a problem.

&nbsp;

```php
/**
* Copyright (C) 2014 ServMask Inc.
*
* This program is free software: you can redistribute it <strong>and/or modify</strong>
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program. If not, see &lt;http://www.gnu.org/licenses/&gt;.
*/
```
