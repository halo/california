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
