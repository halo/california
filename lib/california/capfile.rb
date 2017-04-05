require 'pathname'
require 'capistrano/setup'
require 'capistrano/framework'

require 'capistrano/scm/plugin'
# No-op to tell capistrano that we don't want any SCM hooks to be loaded
install_plugin Capistrano::SCM::Plugin

load 'california/capistrano/tasks/deploy.rake'
load 'california/capistrano/tasks/rails.rake'
