# Middleboy

**middleboy** is a [Middleman 3.x](http://middlemanapp.com/) boilerplate with [SLIM](http://slim-lang.com/), [SASS](http://sass-lang.com/) and [Coffeescript](http://coffeescript.org/).

Use this boilerplate with [Bundler](http://gembundler.com/), [Rbenv](https://github.com/sstephenson/rbenv/) and [Bower](http://bower.io/).

###Features###
* Optimized asset structure
* Conditional IE html tags
* Viewport meta setup for iOS and Android
* Favicon and app icons
* Dynamic title attribute body class via YAML front-matter
* Easy deployment
* HTML Minification
* Auto-generated favicons
* sitemap.xml
* robots.txt
* .htaccess
* gzip
* 97/100 page speed index

###Includes###
* Inline Modernizr
* jQuery
* Google Analytics (async)
* Bootstrap
* Bourbon

### Installation ###
 
Clone **middleboy** into `~/.middleman`. You will need to create this directory if it doesn't exist.
```$ git clone git://github.com/crtvhd/middleboy.git ~/.middleman/middleboy```

Initialize middleman on a new or existing folder `$ middleman init path_to_project --template=middleboy`, then cd into the project directoy and run `bundle update; bower install` to finish setup.

# Copyright

Copyright (c) 2014 Martin Wessely (martin@wesse.ly)
