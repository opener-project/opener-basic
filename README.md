opener-basic
============

OpeNER basic is a fairly standard configuration of all OpeNER component in a single webservice setup. Is functions quite like the [OpeNER Webservices that are available at the OpeNER Portal](http://www.opener-project.eu/webservices).

Installation
------------

We advise you to take a look at the [Local Installations documentation](http://www.opener-project.eu/getting-started/how-to/local-installation.html) at the Project Portal. To help you setup the basics needed for OpeNER. Once you have that setup continue as follows.

Make sure you run JRuby. If you have RVM installed this might do the trick:

```
rvm use jruby
```

We advise to also run a python virtualenv. You can take a look at [Virtualenv-Burrito](https://github.com/brainsik/virtualenv-burrito) to see how you can set it up. If you have that installed you can do something like this:

```
mkvirtualenv opener
workon opener
```

With that out of the way, you can clone the opener-basic project

```
git clone git@github.com:opener-project/opener-basic.git
cd opener-basic
bundle install
```

Please mind, installing OpeNER actually takes a while, several components need to be compiled, and resources need to be downloaded. Go grab yourself a cup of coffee.

Now, once your bundle install succeeds, you can start the webservices by typing:

```
rackup
```

All webservices are now up and running at:

```
http://localhost:9292/
```

With the following end-points:

```bash
http://localhost:9292/language-identifier
http://localhost:9292/tokenizer
http://localhost:9292/pos-tagger
http://localhost:9292/polarity-tagger
http://localhost:9292/opinion-detector
http://localhost:9292/ner
```
