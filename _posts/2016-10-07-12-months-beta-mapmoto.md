---
title: '12 Months To Beta &#8211; MapMoto'
date: 2016-10-07T22:20:22+00:00
author: Ryan Kozak
description: Developing a comprehensive motocross track directory for the United States. Track weather, directions from your location, and a satellite map are provided for extra awesomeness.
layout: post
permalink: /12-months-beta-mapmoto/
image: /wp-content/uploads/2016/10/Screenshot-from-2016-10-02-10-41-29-825x510.png
categories:
  - Web Development
tags:
  - php
  - CodeIgniter
  - Laravel
  - Motocross
---
It&#8217;s been about a year, a little over actually, since I started work on my main side project. The app is a [motocross track directory](https://mapmoto.com),  which isn&#8217;t something that doesn&#8217;t exist already, but I felt existing track directories were lacking a lot of features. This lead to me creating <a href="https://mapmoto.com" target="_blank">MapMoto.</a>

### An Idea

I ride motocross a lot, not as much as a few years ago, but a lot. I&#8217;m always looking up weather before I ride, looking for hot-line numbers to call to confirm days to ride, and looking for new tracks all together, especially when traveling. I wrote down everything I wished a <a href="https://mapmoto.com" target="_blank">motocross track directory</a> would have, and came up with the follow list.

<li style="text-align: left;">
  A really good map, one where I could  just drag it around and see every track easily, without typing in a zip code and having some limited radius displayed, or seeing a list of tracks for a given area and having to click on each one to see it&#8217;s location on a map.
</li>
<li style="text-align: left;">
  The ability to see how far away from me (drive time wise) a track is without opening up a Google Maps Tab on my own.
</li>
<li style="text-align: left;">
  To quickly check what day&#8217;s a track is open
</li>
<li style="text-align: left;">
  To see the weather forecast for the week, to cross reference with the days a track is open.
</li>
<li style="text-align: left;">
  A track&#8217;s website, facebook, twitter, instagram, and whatever other contact info they&#8217;ve got peruse around through.
</li>

#### MapMoto Alpha

I began the project last year in <a href="https://www.codeigniter.com/" target="_blank">CodeIgniter 3.</a> That&#8217;s right, in 2015 I STARTED a project in CI. Those who&#8217;ve been around the php community are probably wondering what I was thinking as it&#8217;s widely criticized for being dated. I was simply taking a shortcut. I&#8217;d developed two applications for clients using CI and the Google Maps API, so I had felt I could get started more quickly. I jumped right into coding, and said to hell with planning ahead.

After 3 or 4 weeks of work I had a working app to add motocross tracks into a simple MySQL database I&#8217;d designed. It was unstyled except for Bootstrap&#8217;s default look, but worked well enough for me to spend a lot of weeks adding hundreds of tracks across the country.

I constantly improved things to make my work easier, such as dropping a map pin based on a track&#8217;s address, then allowing that pin to be dragged and sync the new location with the database (lots of tracks are only kinda near their list address). I developed user and administrative  roles, and built user profile pages with user settings pages to match. Users could upload avatars, link to their social media, be granted permission to manage tracks, the scope of this project crept larger and larger. Eventually I&#8217;d styled the site to a look I was fairly happy with too. After implementing the weather forecast system I&#8217;d told myself enough was enough. This was my side project, I wanted to learn something new, and I should learn modern practices. During the entirety of development I&#8217;d felt stressed out that I was stuck working in CodeIgniter. I knew it well enough already that this project seemed like work, which didn&#8217;t seem fun. I just wanted my project finished.

#### MapMoto Beta

I returned from a trip to Peru a few weeks before my girlfriend who was there for work. I told myself  during those few weeks of an empty house, to stay up all hours coding in, I&#8217;d finally convert this damn thing into a framework I was excited to work with. There was a strong temptation to switch the project over to Django, as I&#8217;m comfortable writing Python, but haven&#8217;t used a Python web framework. I&#8217;d also been reading an Express.js book I&#8217;d purchased myself impulsively one day on Amazon, and thought maybe I&#8217;d go full JS.

Ultimately I decided to stick with php so as not to have to rewrite everything outside of the HTML/CSS/JS. <a href="https://laravel.com/" target="_blank">Laravel 5</a> seemed like a solid choice for a modern framework, with good documentation and an active community. The conversion from CodeIgniter 3 to Laravel 5 took me roughly 3 weeks, which was surprisingly fast. Laravel&#8217;s Eloquent ORM, and Blade Templates, allowed me to clean up the code base dramatically. Since the conversion, implementations of new features have gone much more quickly than CI would have allowed, and working on my side project has become fun again.

&nbsp;

### Beta Launch

After deciding it was time to quietly launch the site, I opened it up to unregistered users, and allowed new users to register. I posted on [/r/motocross](https://www.reddit.com/r/Motocross/comments/5332ru/feedback_on_my_track_directory/) for some feedback on what other riders thought of the initial version. I know of larger motocross communities on line, but decided to go with a low test volume at first. The initial reaction from everyone was very positive. I plan to continue to work on this project slowly, and have a larger official launch at some point in the future. It&#8217;s been a great learning experience.
