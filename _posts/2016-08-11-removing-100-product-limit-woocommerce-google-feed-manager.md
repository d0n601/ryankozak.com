---
title: 'Removing 100 product limit on Woocommerce Google Feed Manager'
date: 2016-08-11T22:56:24+00:00
author: Ryan Kozak
description: Removing the 100 product limit on the Woocommerce Google Feed Manager by hacking the gremlin variable.
layout: post
permalink: /removing-100-product-limit-woocommerce-google-feed-manager/
image: /wp-content/uploads/2016/08/articleheader-825x318.png
categories:
  - Web Development
tags:
  - php
  - Wordpress
---

**Update April 10th, 2017:** The plugin developer contacted me about this post. Out of respect for the way they handled it (extremely classy),  I wanted to put a link to the paid version of their plugin. So, if you actually want support on the unlimited feed, and don&#8217;t want to do any hacky tricks, go support their hard work via the link below.

<blockquote data-secret="eCZNDayy2l" class="wp-embedded-content">
  <p>
    <a href="http://www.wpmarketingrobot.com/purchase-wp-product-feed-manager/" target="_blank">Purchase Woocommerce product feed manager</a>
  </p>
</blockquote>



**Original Article**

I came across this info somewhat by accident today while working on an XML Feed generator for a <a href="https://wordpress.org/plugins/woocommerce/" target="_blank">WooCommerce</a> installation. I&#8217;ll often review the code of a couple plugins with similar functions to what I&#8217;m developing. While looking through <a href="https://wordpress.org/plugins/wp-product-feed-manager/" target="_blank">Woocommerce Google Feed Manager</a> I guess I found a gremlin.

[<img class="alignnone size-thumbnail wp-image-380" src="/wp-content/uploads/2016/08/NY-Gremlin-150x150.jpg" alt="NY-Gremlin" width="150" height="150" />](/wp-content/uploads/2016/08/NY-Gremlin.jpg)

## tl;dr

I&#8217;ll put this right at the top in case this is all you came for. To remove the 100 product limit from the free installation of <a href="https://wordpress.org/plugins/wp-product-feed-manager/" target="_blank">Woocommerce Google Feed Manager</a> , <a href="https://wordpress.org/plugins/wp-product-feed-manager/" target="_blank">download</a> and unzip the plugin.

Navigate to `/wp-product-feed-manager/includes/application/class-feed-processor.php`

As of writing this the plugin is in version 1.1.0, and for this version the line your looking for is line:114

```php
if ( get_option( 'wppfm_lic_status' ) !== 'valid' && $this->_product_counter > $grmln ) { break; }
```

You&#8217;ll want to change this if statement to not break the loop, so just remove the `break;` (pirate comment&#8217;s are optional)

```php
if ( get_option( 'wppfm_lic_status' ) !== 'valid' && $this->_product_counter > $grmln ){/*Avast, mateys!*/ }
```

Save the file, re-zip your plugin, and upload it to your WordPress installation.

If you have over 100 products in your WooCommerce Store then go ahead and generate your Product Feed once more,

[<img class="alignnone size-full wp-image-359" src="/wp-content/uploads/2016/08/Screenshot-from-2016-08-11-135536.png" alt="Screenshot from 2016-08-11 13:55:36" width="720" height="300" srcset="/wp-content/uploads/2016/08/Screenshot-from-2016-08-11-135536.png 720w, /wp-content/uploads/2016/08/Screenshot-from-2016-08-11-135536-300x125.png 300w" sizes="(max-width: 720px) 100vw, 720px" />](/wp-content/uploads/2016/08/Screenshot-from-2016-08-11-135536.png)

&nbsp;

## The Long Winded Explanation&#8230;

If you want to know what the above steps actually do, then this will go into a little more detail. I say a little because I really didn&#8217;t go through the plugin very much, I made this discovery, took a couple of screen shots and then moved on &#8230; I was busy doing real work stuff 🙁

Initially, I just wanted to see how the application structure looked, and how the feed was being generated. I looked at the file structure and opened `/includes/application/class-feed-processor.php` without looking at anything else first. I noticed the `$grmln`  variable declaration which lead immediately to the discovery of the if statement mentioned above.

But lets walk through this like we&#8217;re trying to hack the plugin, rather than miraculously discovering a variable.

First, take a look at the main plugin file `wp-product-feed-manager.php`

and scroll to line: 115 where there&#8217;s a method `define_constants()`

It&#8217;s not uncommon that constants are all that&#8217;s holding back paid features in free versions of plugins. Definitely far from always, but not uncommonly the case.

Anyway, in the `define_constants()` method we see starting at line:160

```php
// Store the end file lmtr  
if ( !defined( 'WPPFM_FEED_P_LMTR' ) ) {  
    define( 'WPPFM_FEED_P_LMTR', 18 );
}
```

This sparks interest in those who&#8217;d be seeking to perhaps&#8230;.change the limit of the feed.  So let&#8217;s see where this `WPPFM_FEED_P_LMTR` is called.<figure id="attachment_368" style="max-width: 652px" class="wp-caption alignnone">

[<img class="wp-image-368 size-full" src="/wp-content/uploads/2016/08/Screenshot-from-2016-08-11-151947.png" alt="Screenshot from 2016-08-11 15:19:47" width="652" height="402" srcset="/wp-content/uploads/2016/08/Screenshot-from-2016-08-11-151947.png 652w, /wp-content/uploads/2016/08/Screenshot-from-2016-08-11-151947-300x185.png 300w" sizes="(max-width: 652px) 100vw, 652px" />](/wp-content/uploads/2016/08/Screenshot-from-2016-08-11-151947.png)
*PhpStorm output for ‘Find Usages of WPPFM_FEED_P_LMTR’*



The usage of this variable seems to be limited one occurrence here,

`includes/application/class-feed-processor.php`

It defines a variable on line:69,  and  there&#8217;s is a little cryptic arithmetic involved,

```php
$grmln = 9 + ( 5 * WPPFM_FEED_P_LMTR );
```

Remember when the `WPPFM_FEED_P_LMTR` constant was set it was 18, so `$grmln = 99`.

Where is `$grmln` used?<figure id="attachment_369" style="max-width: 969px" class="wp-caption alignnone">

[<img class="wp-image-369 size-full" src="/wp-content/uploads/2016/08/Screenshot-from-2016-08-11-152417.png" alt="Screenshot from 2016-08-11 15:24:17" width="969" height="354" srcset="/wp-content/uploads/2016/08/Screenshot-from-2016-08-11-152417.png 969w, /wp-content/uploads/2016/08/Screenshot-from-2016-08-11-152417-300x110.png 300w, /wp-content/uploads/2016/08/Screenshot-from-2016-08-11-152417-768x281.png 768w" sizes="(max-width: 969px) 100vw, 969px" />](/wp-content/uploads/2016/08/Screenshot-from-2016-08-11-152417.png)
*PhpStorm output for ‘Find Usages of $grmln’*



On line:114 you&#8217;ll see the conditional statement that implements the `$grmln` variable, which contains a break to the loop when the statement is true.

```php
if ( get_option( 'wppfm_lic_status' ) !== 'valid' && $this->_product_counter > $grmln ) { break; }
```

Well that&#8217;s a problem, because the conditions to make this statement true are such, &#8220;if the user doesn&#8217;t have a license status that&#8217;s valid&#8221;, and &#8220;if the post count is over 99&#8221;.

All you really need to do is remove the `break;`, and then as one would expect, the loop no longer breaks when the unlicensed user product limitation is reached. You could likely also remove this limit by bumping `WPPFM_FEED_P_LMTR` to be equal to an absurdly high number or setting `$grmln` equal to `count($data)`&#8230;.maybe we could even define `wppfm_lic_status` ourselves to be valid and just cruise on past this block as licensed users. Whatever&#8230;I didn&#8217;t explore these options or play around much in that regard, so other&#8217;s will have more information for me I&#8217;m sure. For those of you that wanted to know more behind how the tl;dr version of this post accomplished removing the limitation, now you do.

## Disclaimer

Developers work long and hard on these plugins, and if you&#8217;re going to use features which extend beyond the free versions of plugins, it&#8217;s best you just buy them. Sometimes I&#8217;ll publish interesting ways of extending functionality to the free version, but this is NO WHERE CLOSE to the benefits of actually obtaining the paid version. Updates will break these little hacks, and they may change functionality here and there in unexpected ways. Not to mention it&#8217;s always nice to get product support from the developer, which a license will get you, and hacking will not 🙂
