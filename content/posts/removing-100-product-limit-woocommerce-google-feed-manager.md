+++
title = 'Removing 100 Product Limit on Woocommerce Google Feed Manager'
date = 2016-08-11T22:56:24+00:00
hideToc = true
description = "Guide for removing the 100 product limit from WooCommerce Google Feed Manager free version by modifying plugin source code."
+++

**Note:** If you actually want support on the unlimited feed, and don't want to do any hacky tricks, go support their hard work and [Purchase Woocommerce product feed manager](http://www.wpmarketingrobot.com/purchase-wp-product-feed-manager/).


I came across this info somewhat by accident today while working on an XML Feed generator for a [WooCommerce](https://wordpress.org/plugins/woocommerce/) installation. I'll often review the code of a couple plugins with similar functions to what I'm developing. While looking through [Woocommerce Google Feed Manager](https://wordpress.org/plugins/wp-product-feed-manager/) I guess I found a gremlin.


![ny-gremlin](/posts/images/removing-100-product-limit-woocommerce/grmln.jpg)


## tl;dr

I'll put this right at the top in case this is all you came for. To remove the 100 product limit from the free installation of [Woocommerce Google Feed Manager](https://wordpress.org/plugins/wp-product-feed-manager/), [download](https://wordpress.org/plugins/wp-product-feed-manager/) and unzip the plugin.

Navigate to `/wp-product-feed-manager/includes/application/class-feed-processor.php`

As of writing this the plugin is in version 1.1.0, and for this version the line your looking for is line:114

```php
if ( get_option( 'wppfm_lic_status' ) !== 'valid' && $this->_product_counter > $grmln ) { break; }
```

You'll want to change this if statement to not break the loop, so just remove the `break;` (pirate comment's are optional)

```php
if ( get_option( 'wppfm_lic_status' ) !== 'valid' && $this->_product_counter > $grmln ){/*Avast, mateys!*/ }
```

Save the file, re-zip your plugin, and upload it to your WordPress installation.

If you have over 100 products in your WooCommerce Store then go ahead and generate your Product Feed once more,

![screenshot-one](/posts/images/removing-100-product-limit-woocommerce/sc1.png)

## The Long Winded Explanation

If you want to know what the above steps actually do, then this will go into a little more detail. I say a little because I really didn't go through the plugin very much, I made this discovery, took a couple of screen shots and then moved on ... I was busy doing real work stuff 🙁

Initially, I just wanted to see how the application structure looked, and how the feed was being generated. I looked at the file structure and opened `/includes/application/class-feed-processor.php` without looking at anything else first. I noticed the `$grmln`  variable declaration which lead immediately to the discovery of the if statement mentioned above.

But lets walk through this like we're trying to hack the plugin, rather than miraculously discovering a variable.

First, take a look at the main plugin file `wp-product-feed-manager.php`

and scroll to line: 115 where there's a method `define_constants()`

It's not uncommon that constants are all that's holding back paid features in free versions of plugins. Definitely far from always, but not uncommonly the case.

Anyway, in the `define_constants()` method we see starting at line:160

```php
// Store the end file lmtr  
if ( !defined( 'WPPFM_FEED_P_LMTR' ) ) {  
    define( 'WPPFM_FEED_P_LMTR', 18 );
}
```

This sparks interest in those who'd be seeking to perhaps change the limit of the feed.  So let's see where this `WPPFM_FEED_P_LMTR` is called.

![screenshot-2](/posts/images/removing-100-product-limit-woocommerce/sc2.png)



The usage of this variable seems to be limited one occurrence here,

`includes/application/class-feed-processor.php`

It defines a variable on line:69,  and  there's is a little cryptic arithmetic involved,

```php
$grmln = 9 + ( 5 * WPPFM_FEED_P_LMTR );
```

Remember when the `WPPFM_FEED_P_LMTR` constant was set it was 18, so `$grmln = 99`.

Where is `$grmln` used?

![screenshot-3](/posts/images/removing-100-product-limit-woocommerce/sc3.png)
*PhpStorm output for ‘Find Usages of $grmln’*



On `line:114` you'll see the conditional statement that implements the `$grmln` variable, which contains a break to the loop when the statement is true.

```php
if ( get_option( 'wppfm_lic_status' ) !== 'valid' && $this->_product_counter > $grmln ) { break; }
```

Well that's a problem, because the conditions to make this statement true are such, *if the user doesn't have a license status that's valid*, and *if the post count is over 99*.

All you really need to do is remove the `break;`, and then as one would expect, the loop no longer breaks when the unlicensed user product limitation is reached. You could likely also remove this limit by bumping `WPPFM_FEED_P_LMTR` to be equal to an absurdly high number or setting `$grmln` equal to `count($data)`...maybe we could even define `wppfm_lic_status` ourselves to be valid and just cruise on past this block as licensed users. Whatever. I didn't explore these options or play around much in that regard, so other's will have more information for me I'm sure. For those of you that wanted to know more behind how the tl;dr version of this post accomplished removing the limitation, now you do.

## Disclaimer

Developers work long and hard on these plugins, and if you're going to use features which extend beyond the free versions of plugins, it's best you just buy them. Sometimes I'll publish interesting ways of extending functionality to the free version, but this is NO WHERE CLOSE to the benefits of actually obtaining the paid version. Updates will break these little hacks, and they may change functionality here and there in unexpected ways. Not to mention it's always nice to get product support from the developer, which a license will get you, and hacking will not 🙂