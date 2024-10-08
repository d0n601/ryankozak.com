+++
title = '12 Months To Beta: MapMoto'
date = 2016-10-07T22:20:22+00:00
hideToc = true
+++

It's been about a year, a little over actually, since I started work on my main side project. The app is a [motocross track directory](https://mapmoto.com),  which isn't something that doesn't exist already, but I felt existing track directories were lacking a lot of features. This lead to me creating [MapMoto](https://mapmoto.com).

![mapmoto-motocross-track-directory](/posts/images/12-months-to-beta/mapmoto.png)


### An Idea

I ride motocross a lot, not as much as a few years ago, but a lot. I'm always looking up weather before I ride, looking for hot-line numbers to call to confirm days to ride, and looking for new tracks all together, especially when traveling. I wrote down everything I wished a [motocross track directory](https://mapmoto.com) would have, and came up with the follow list.


* A really good map, one where I could  just drag it around and see every track easily, without typing in a zip code and having some limited radius displayed, or seeing a list of tracks for a given area and having to click on each one to see it's location on a map.
* The ability to see how far away from me (drive time wise) a track is without opening up a Google Maps Tab on my own.
* To quickly check what day(s) a track is open.
* To see the weather forecast for the week, to cross reference with the days a track is open.
* A track's website, [facebook](https://www.facebook.com), [twitter](https://x.com/), [instagram](https://www.instagram.com/), and whatever other contact info they've got to peruse around through.


#### MapMoto Alpha

I began the project last year in [CodeIgniter 3](https://www.codeigniter.com/). That's right, in 2015 I STARTED a project in CI. Those who've been around the php community are probably wondering what I was thinking as it's widely criticized for being dated. I was simply taking a shortcut. I'd developed two applications for clients using CI and the Google Maps API, so I had felt I could get started more quickly. I jumped right into coding, and said to hell with planning ahead.

After 3 or 4 weeks of work I had a working app to add motocross tracks into a simple MySQL database I'd designed. It was unstyled except for Bootstrap's default look, but worked well enough for me to spend a lot of weeks adding hundreds of tracks across the country.

I constantly improved things to make my work easier, such as dropping a map pin based on a track';s address, then allowing that pin to be dragged and sync the new location with the database (lots of tracks are only kinda near their list address). I developed user and administrative  roles, and built user profile pages with user settings pages to match. Users could upload avatars, link to their social media, be granted permission to manage tracks, the scope of this project crept larger and larger. Eventually I'd styled the site to a look I was fairly happy with too. After implementing the weather forecast system I'd told myself enough was enough. This was my side project, I wanted to learn something new, and I should learn modern practices. During the entirety of development I'd felt stressed out that I was stuck working in CodeIgniter. I knew it well enough already that this project seemed like work, which didn't seem fun. I just wanted my project finished.

#### MapMoto Beta

I returned from a trip to Peru a few weeks before my girlfriend who was there for work. I told myself  during those few weeks of an empty house, to stay up all hours coding in, I'd finally convert this damn thing into a framework I was excited to work with. There was a strong temptation to switch the project over to Django, as I'm comfortable writing Python, but haven't used a Python web framework. I'd also been reading an Express.js book I'd purchased myself impulsively one day on Amazon, and thought maybe I'd go full JS.

Ultimately I decided to stick with php so as not to have to rewrite everything outside of the HTML/CSS/JS. [Laravel 5](https://laravel.com/) seemed like a solid choice for a modern framework, with good documentation and an active community. The conversion from CodeIgniter 3 to Laravel 5 took me roughly 3 weeks, which was surprisingly fast. Laravel's Eloquent ORM, and Blade Templates, allowed me to clean up the code base dramatically. Since the conversion, implementations of new features have gone much more quickly than CI would have allowed, and working on my side project has become fun again.


### Beta Launch

After deciding it was time to quietly launch the site, I opened it up to unregistered users, and allowed new users to register. I posted on [/r/motocross](https://www.reddit.com/r/Motocross/comments/5332ru/feedback_on_my_track_directory/) for some feedback on what other riders thought of the initial version. I know of larger motocross communities on line, but decided to go with a low test volume at first. The initial reaction from everyone was very positive. I plan to continue to work on this project slowly, and have a larger official launch at some point in the future. It's been a great learning experience.
