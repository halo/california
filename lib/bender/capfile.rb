require 'pathname'
require 'capistrano/setup'
require 'capistrano/framework'

require 'capistrano/scm/plugin'
# No-op to tell capistrano that we don't want any SCM hooks to be loaded
install_plugin Capistrano::SCM::Plugin

load 'bender/capistrano/tasks/deploy.rake'
load 'bender/capistrano/tasks/rails.rake'
