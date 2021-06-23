---
title: 'Drinking Age Gateway with JavaScript'
date: 2016-02-06T05:18:12+00:00
author: Ryan Kozak
description: Add a drinking age verification gateway to your website with JavaScript. Drinking age is determined by visitors actual location.
layout: post
permalink: /drinking-age-gateway-with-javascript/
image: /wp-content/uploads/2016/02/Screenshot-from-2016-02-05-201903-811x510.png
categories:
  - Web Development
tags:
  - HTML
  - JavaScript
  - Wordpress
---
**UPDATE 12/5/2016:**
  If you&#8217;re going to attempt to integrate this into the WordPress platform, please consider using my <a href="https://wordpress.org/plugins/wp-drinking-age/" target="_blank">WP Drinking Age Plugin</a>.

## Background

So outside the normal grind I&#8217;ve been working on a website for a tequila brand. After a meeting with marketing I&#8217;d gathered it was important to add a drinking age gateway to the site. You see some type of these gateways on just about every alcohol brand&#8217;s site. I asked if they&#8217;d prefer to simply ask &#8220;Are you of Legal Drinking Age?&#8221;, and then have  &#8220;Yes/No&#8221; buttons determine a user&#8217;s fate (<a href="http://cuervo.com/" target="_blank">1</a>)(<a href="http://www.1800tequila.com/product/silver/" target="_blank">2</a>), or if they&#8217;d rather have the user input their birthday (<a href="http://www.patrontequila.com/age-gate/age-gate.html?origin=%2F&flc=homepage&fln=Post_Homepage_Patron" target="_blank">3</a>). Apparently, and I&#8217;m not a business guy or a lawyer so don&#8217;t comment and argue this with me, the yes/no gateways hold slightly less legitimacy than the ones where a user inputs their birthday to enter the site .

These gateways are really just about putting responsibility into the hands of the user, within reason. Is it easier to  lie with a yes/no gateway?&#8230;sure. Is it impossible to lie about your birthday though?&#8230;definitely not. So a birthday input is reasonably easy to implement, but not impossible to crack. If a user is going to lie they&#8217;re going to lie, not turn off JavaScript to get around the gateway. This is why a client side gateway seemed like the most reasonable approach.

## Solution

A JavaScript gateway will allow easy indexing by search engines because they won&#8217;t run the JavaScript to restrict the content in the first place . If we were to have PHP check for the presence of an age verification cookie,  search engine crawlers will not have this cookie and will not see/index the content. We could work around that I&#8217;m sure, but there&#8217;s no need.

All countries don&#8217;t have the same drinking age. So solutions where the gateway is based on a static entry age aren&#8217;t viable. An age, and location must be gathered by the gateway to determine if a user is credible to enter the site. Tequila in Mexico is legal 3 years earlier than California. Sites that implemented this type of gateway (1) seemed to POST location values with country codes &#8220;US&#8221; &#8220;CA&#8221; ,ect. So they were authenticating server side with these codes&#8230;ugh

I&#8217;d Googled long enough to determine the few hours spent writing this script were likely more fun than just searching for an existing solution to work with, because it didn&#8217;t jump out at me.

<a href="https://github.com/d0n601/drinkingAge" target="_blank">Github Code</a>

## Installation

  1. Download the dependencies of <a href="http://getbootstrap.com/getting-started/" target="_blank">Bootstrap</a> and <a href="https://jquery.com/download/" target="_blank">jQuery</a>
  2. Get the Source <a href="https://github.com/d0n601/drinkingAge/archive/master.zip" target="_blank">drinkingAge</a>
  3. Place <a href="https://raw.githubusercontent.com/d0n601/drinkingAge/master/bouncer.css" target="_blank">bouncer.css</a> in site&#8217;s head `<link href="css/bouncer.css" rel="stylesheet">`
  4. Place <a href="https://raw.githubusercontent.com/d0n601/drinkingAge/master/bouncer.js" target="_blank">bouncer.js</a> before the close of the body `<script src="js/bouncer.js"></script>`
  5. Initialize the gateway and its settings

  ```javascript
  $(function() {

    //Settings for drinkingAge Plugin
    var settings = {
                    "image" : 'http://placehold.it/350x150',
                    "message" : "As part of our commitment to responsible drinking, we just need to check that you're of legal drinking age.",
                    "redirect" : 'http://responsibility.org',
                    "deny_message" : "Sorry, but you are not of legal drinking age.<br>You'll be redirected soon...",
                    "deny_timeout": 5000,
                    "link_terms" : '/terms',
                    "link_privacy" : '/privacy'
                };
    //Initiate bouncer.js (drinkingAge)
    drinkingAge(settings);
});
  ```

Putting that all together in the most basic form you should have this.

<a href="https://rawgit.com/d0n601/drinkingAge/master/example/index.html" target="_blank">Example Gateway</a>

```html
<html>
  <head>
        <meta charset="utf-8">
        <meta http-equiv="Content-Type" context="text/html; charset=utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">

        <title>Drinks N' Alcohol</title>

        <link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" rel="stylesheet">
        <link href="..//bouncer.css" rel="stylesheet">

        <style>
            body {
                text-align:center;
                color:#FFF;
                background-image: url('img/drankin.jpg');
                background-size: cover;
            }
        </style>

    </head>

<body>

    <h1>Alcoholic Material</h1>
    <p>Restricted stuff involving drinking within...</p>

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.0/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"></script>
    <script src="../bouncer.js"></script>

    <script>
        $(function() {
            //Settings for Bounder.js Plugin
            var settings = {
                            "image" : 'http://placehold.it/350x150',
                            "message" : "As part of our commitment to responsible drinking, we just need to check that you're of legal drinking age.",
                            "redirect" : 'http://responsibility.org',
                            "deny_message" : "Sorry, but you are not of legal drinking age.<br>You'll be redirected soon...",
                            "deny_timeout": 5000,
                            "link_terms" : '/terms',
                            "link_privacy" : '/privacy'
                        };
            //Initiate Bouncer.js
            drinkingAge(settings);
    });
    </script>

</body>

</html>
```


## Customization

The <a href="https://github.com/d0n601/drinkingAge/blob/master/bouncer.css" target="_blank">bouncer.css</a> file allows you to change just about everything that has to do with the gateway. I&#8217;m not a wizard with style sheets and this is a demo&#8230;so you&#8217;ll want to change things here.


```css
/*
 * Plugin: bouncer.js
 * Description: Style sheet for bouncer js window appearance
 * Author: Ryan Kozak
 * Author's website: https://ryankozak.com
 *
 */


.spacers {
    margin:10px;
}
#age_controls {
    z-index:1032;
    color:#FFF;
    position:fixed;
    top:0;
    left:0;
    opacity:1.0 !important;
    background-color:#1F1B1C;
    margin:15vh 25vw;
    width:50vw;
    min-width:320px;
    line-height:1.5em;
    border-radius:5px;
    border-style: solid;
    border-width: 5px;
    border-color: #FFF;
    padding:35px;
    display:none;
}
select {
    color:#000;
}
#age_overlay {
    position: fixed;
    top: 0;
    left: 0;
    height: 100%;
    width: 100%;
    background-color: #000;
    opacity: .9;
    z-index:1031;
    display:none;
}

#deny_entry {
    z-index:10000;
    top:0;
    left:0;
    position:absolute;
    width:100vw;
    text-align:center;
    font-weight:900;
}
```


&nbsp;

_Reference for Legal Drinking Ages_

<a href="http://drinkingage.procon.org/view.resource.php?resourceID=004294" target="_blank">http://drinkingage.procon.org/view.resource.php?resourceID=004294</a>

&nbsp;
