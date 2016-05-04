## Bender - Capistrano 3 for dummies

[![Build Status](https://travis-ci.org/halo/bender.svg?branch=master)](https://travis-ci.org/halo/bender)

![screenshot](https://raw.github.com/halo/bender/master/doc/bender.png)

### Requirements

* Ruby >= 2.0
* Bundler

### Installation

Create a new repository with a Gemfile like this and run `bundle install` to get the bender gem.

```ruby
# Content of Gemfile
source 'https://rubygems.org'

gem 'bender', github: 'halo/bender'
```

Then run the generator for creating your first app you may want to deploy.
Let's say the name of the app is "hello_world".

```ruby
# Inside the directory of your newly created repository
bundle exec bender generate hello_world
```

Modify `hello_world/deploy/production.rb` (or whichever stages you have) and define which servers you want to deploy to.

### Server preparation

When deploying your `hello_world` app, it is assumed that you can ssh into the server with the user `hello_world` and that the repository has been cloned to `/mnt/apps/hello_world/repository`.

Any additional environment variables needed to configure your application should be located in a file called `/mnt/envs/hello_world`.

```bash
# Example of content of /mnt/envs/hello_world
SECRET_TOKEN="abcdef"
DATABASE_URL="postgres://db.example.com"
```

### Deployment

Essentially you just run vanilla capistrano 3 commands from inside the respective application directory.

```ruby
cd hello_world

# Examples:
bundle exec cap staging deploy
bundle exec cap production deploy migrate=true
```

### Copyright

MIT 2016 halo. See [MIT-LICENSE](http://github.com/halo/bender/blob/master/MIT-LICENSE).
