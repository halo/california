## 1.0.1

Improvements:

* Added optional `yarn install` task

## 1.0.0

Breaking changes:

* Restart is not performed with `touch tmp/restart.txt` but with `passenger-config restart path/to/app`
  To retain the old behavior, use `set :restart_strategy, 'restart.txt'` in your stage.

Improvements:

* You can now skip `bundle install` with `set :skip_bundler, true`
* You can now skip the application restart with `set :skip_restart, true`

Changes:

* Updated capistrano from `~> 3.8` to `~> 3.11`, no breaking changes
* Updated thor (used for creating templates) from `~> 0.16` to `~> 0.20`, no breaking changes

## 0.4.1

Improvements:

* You can now load `california/stage` instead of `california/stage.rb` (convenience)

## 0.4.0

Quite a notable change:

* Renamed `bender` to `california` so as to publish it on rubygems.org

## 0.3.1

Changes:

* Deriving the rack environment expects the word "production", "staging", or "test" in the stage name

## 0.3.0

Changes:

* Use `git checkout --force origin/branch` instead of `git pull`. It's more robust against local changes on the server.
* Bundle in parallel using all cores (requires `nproc` on your server, which ubuntu has by default)
* Ensure that RAILS_ENV equals RACK_ENV for wider compatibility

## 0.2.0

Improvements:

* Nicer logging output (using Airbrussh)
* Rubocop compatibility

## 0.1.0

Features:

* Non-production enviroments create a disallowing `public/robots.txt` by default.

## 0.0.3

Features:

* Added `release_path` alias for `deploy_to`.
