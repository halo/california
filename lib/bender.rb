require 'logging'
require 'pathname'
require 'capistrano/setup'
require 'capistrano/framework'

module Bender
  extend self

  def stage_path
    lib_path.join 'capistrano/stage.rb'
  end

  def tasks_path
    lib_path.join 'capistrano/tasks/*.rake'
  end

  private

  def lib_path
    Pathname.new File.expand_path '../bender/', __FILE__
  end
end

Dir.glob(Bender.tasks_path).each { |path| load path }
