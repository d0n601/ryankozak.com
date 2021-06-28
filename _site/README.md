# RyanKozak.com

This is the repository for my [personal site and blog](https://ryankozak.com). It's a static site generated via [Jekyll](http://jekyllrb.com) 3.x using the [Hydeout]( https://github.com/fongandrew/hydeout) theme.

### Jekyll Plugins
The site uses [jekyll-paginate-v2](https://github.com/sverrirs/jekyll-paginate-v2) for paginating my collection of [books](https://ryankozak.com/books). It also uses [my fork](https://github.com/d0n601/jekyll-photo-gallery) of [jekyll-photo-gallery](https://github.com/aerobless/jekyll-photo-gallery) to host [my photography page](https://ryankozak.com/photography), which is mostly hidden away unused.


### Docker  
I've started using Docker for development, because managing dependencies for Jekyll has been a pain. I'm not that well versed in containers still, so my [Dockerfile](./Dockerfile) and [docker-compose.yml](./docker-compose.yml) may have room for improvement. I took the OS I initially started using Jekyll with, which was Ubuntu, and containerized what I needed to run `jekyll serve`.

**Note:** I don't [https://ryankozak.com](https://ryankozak.com) with Docker, the static files are placed in Apache. The Docker portion is meant for development, not production.

To build the image initially theres the standard `docker-compose build`. To start the dev site running `docker-compose up` will get the site up at `localhost:4000` and poll for changes to files.
