## Bender - Capistrano 3 for dummies

![screenshot](https://raw.github.com/halo/bender/master/doc/bender.png)

### Requirements

* Ruby >= 2.0
* Bundler

### Installation

Create a new repository with a Gemfile like this and run `bundle install` to get the bender gem.

```ruby
source 'https://rubygems.org'

gem 'bender'
```

Then run the generator for creating your first app you may want to deploy.
Let's say the name of the app is "hello_world".

```ruby
# Inside the directory of your repository
bundle exec bender generate hello_world
```

### Setup

Modify `hello_world/deploy/production.rb` (or whichever stages you have) and define which servers you want to deploy to.

### Deployment

Essentially you just run vanilla capistrano 3 commands from inside the respective application directory.

```ruby
cd hello_world

# Examples:
bundle exec cap staging deploy
bundle exec cap production deploy migrate=true
```

### Copyright

MIT 2014 halo. See [MIT-LICENSE](http://github.com/halo/bender/blob/master/MIT-LICENSE).
