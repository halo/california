require 'logging'
require 'pathname'
require 'capistrano/setup'
require 'capistrano/framework'

load 'bender/capistrano/tasks/deploy.rake'
load 'bender/capistrano/tasks/rails.rake'
load 'bender/capistrano/tasks/robots.rake'
