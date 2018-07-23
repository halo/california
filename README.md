## Opinionated Capistrano deployment for dummies

[![Version](https://img.shields.io/gem/v/california.svg?style=flat)](https://rubygems.org/gems/california)
[![Build Status](https://travis-ci.org/halo/california.svg?branch=master)](https://travis-ci.org/halo/california)

When using [Capistrano](https://github.com/capistrano/capistrano) to deploy an application to a server, it runs [all this stuff](https://github.com/capistrano/capistrano/blob/master/lib/capistrano/tasks/deploy.rake) creating a new symlink for every release, cleans up old ones, etc..

California is an opinionated out-of-the-box, best-practice configuration that aims to make things a little bit simpler for both beginners and advanced users.

### Design Goals

* Don't separate releases in different directories. Just [perform a simple checkout](https://github.com/halo/california/blob/master/lib/california/capistrano/tasks/deploy.rake#L21-L24) that updates the code in place.

* Introduce convention over configuration, e.g. as to [where the applications are deployed](https://github.com/halo/california/blob/master/lib/california/stage.rb#L40-L42).

* Every app has its own user on the server and when running commands during deploy, [load the `.bash_profile` of that user](https://github.com/halo/california/blob/master/lib/california/stage.rb#L65-L67)

* Nicer logging output so that you *really* know at which stage of the deploy you are (update code, run bundler, restart)
* 
### Requirements

* Ruby >= 2.0
* Bundler

### Installation

Create a new repository with a Gemfile like this and run `bundle install` to get the california gem.

```ruby
# Content of Gemfile
source 'https://rubygems.org'

gem 'california'
```

Then run the generator for creating your first app you may want to deploy.
Let's say the name of the app is "hello_world".

```ruby
# Inside the directory of your newly created repository
bundle exec california generate hello_world
```

Follow the instructions in `hello_world/deploy/production.rb` (or whichever stages you have) and define which servers you want to deploy to.

### Server preparation

When deploying your `hello_world` app, it is assumed that you can ssh into the server with the username `hello_world` and that the repository has been cloned to `/mnt/apps/hello_world/repository`.

The reason for this directory is that if you are on AWS, `/mnt` is the default path for permanent storage. If you're not on AWS, you may just ride along and follow the convention.

If you configure your application via environment variables, you can add them in a file called `/mnt/envs/hello_world`.

```bash
# Example of content of /mnt/envs/hello_world
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

MIT 2018 halo. See [LICENSE.md](http://github.com/halo/california/blob/master/LICENSE.md).
