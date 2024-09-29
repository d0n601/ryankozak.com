+++
title = 'Removing the 512MB size limit on All-in-One WP Migration Plugin'
date = 2015-04-10T22:34:29+00:00
hideToc = true
+++
## Update, Pay Attention!

#### Bad News
 As of version `6.78` things began to change, first the developers removed the upload feature, and the `wp-cli` functionality. Newer versions of the plugin are really stripped down and include less functionality than `6.77` did. The new version exists on the Wordpress repository almost exclusively to upsell you to the paid version. The new plugin is still hackable, but there are more steps required than what's described below, and like I said, it doesn't work with `wp-cli`. The steps below to increase the plugin size don't work on the new version.


#### Good News
 Use this [https://github.com/d0n601/All-In-One-WP-Migration-With-Import](https://github.com/d0n601/All-In-One-WP-Migration-With-Import) if you'd like. I've increased the upload size limit to 32 GB, it works on the current version of Wordpress, and it also includes `wp-cli` functionality. Just download it as a [zip](https://github.com/d0n601/All-In-One-WP-Migration-With-Import/archive/master.zip) and upload it manually.

## Original Article Below

A WordPress development workflow can be difficult to optimize, especially when working in a team environment. You wont have trouble finding a few well written articles online concerning version control setups and project structures. Setting up a new project is smooth when you're using a Git repository of some flavor for your theme content, and (Database Sync)[https://wordpress.org/plugins/database-sync] or a similar plugin to sync your local and live databases.

#### What about the case in which you inherit an existing WordPress site?

It's not uncommon to need to pull all of a site's plugins, settings, and media content to a local development environment at least initially. This is typically part of our onboarding process.

Simply syncing themes and databases as you typically would in your development workflow is not enough in this instance. With a plugin known as [All-in-One WP Migration](https://wordpress.org/plugins/all-in-one-wp-migration), you're able to export an entire WordPress instance to a single file with an extension `.wpress`. You're then able to turn right back around and import that file to another WordPress installation to create a clone.

Here is what the steps look like to export a production site to a file.

![All-in-One Wp Migration Upload Step 1](/posts/images/all-in-one-migration-sizelimit/wpmigration1.png)

![All-in-One Wp Migration Upload Step 2](/posts/images/all-in-one-migration-sizelimit/wpmigration2.png)

![All-in-One Wp Migration Upload Step 3](/posts/images/all-in-one-migration-sizelimit/wpmigration3.png)


At this point, depending upon the size of the backed up file, a blank installation of WordPress may be all that's necessary to clone the production site.

![All-in-One Wp Migration Upload Step 4](/posts/images/all-in-one-migration-sizelimit/wpmigration4.png)


## BUT...

If the size of your `.wpress` file exceeds `512MB`, you will be prompted to purchase the [Unlimited Extension of All-in-One WP Migration](https://servmask.com/products/unlimited-extension).  If you're inheriting a site that's been in production for a while, it's likely that the backup file is over this small size limit (see a fix for this below).

![All-in-One Wp Migration Upload Step 6](/posts/images/all-in-one-migration-sizelimit/wpmigration6.png)

![All-in-One Wp Migration Upload Step 7](/posts/images/all-in-one-migration-sizelimit/wpmigration7.png)

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


Save the file and navigate back to the *import* function for the All-In-One Migration Plugin. The file upload limit now reads `4GB`.

![All-in-One Wp Migration Upload Step 8](/posts/images/all-in-one-migration-sizelimit/wpmigration8.png)

The plugin will no longer reject your large file uploads.

![All-in-One Wp Migration Upload Step 9](/posts/images/all-in-one-migration-sizelimit/wpmigration9.png)

![All-in-One Wp Migration Upload Step 10](/posts/images/all-in-one-migration-sizelimit/wpmigration10.png)

![All-in-One Wp Migration Upload Step 11](/posts/images/all-in-one-migration-sizelimit/wpmigration11.png)

Note that this plugin does have regular updates, and each update will reset your file upload limit. Because I use this plugin to import existing sites to my local development environment, and not as part of my regular workflow, it's not much of a problem.


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