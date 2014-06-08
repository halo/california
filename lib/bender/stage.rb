# If you ever get annoyed by the output.
# Note that you will *not* see what failed, though!
# set :log_level, :info

require 'logging'
def logger
  @logger ||= begin

    Logging.color_scheme( 'bright',
      date: :blue,
      logger: :magenta,
      message: :white
    )

    layout = Logging.layouts.pattern pattern: '      ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬ \n %-4c %m\n      ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬\n', color_scheme: 'bright'

    Logging.appenders.stdout( 'stdout',
      auto_flushing: true,
      layout: layout
    )

    result = Logging.logger['CAP']
    result.add_appenders 'stdout'
    result.level = fetch(:log_level)
    result
  end
end

# Exception handling Inspired by https://github.com/thoughtbot/airbrake/blob/master/lib/airbrake/rake_handler.rb
module RakeExceptionChatter
  def self.included(klass)
    klass.class_eval do
      alias_method :display_error_message_without_chat, :display_error_message
      alias_method :display_error_message, :display_error_message_with_chat
    end
  end

  def display_error_message_with_chat(exception)
    puts
    display_error_message_without_chat(exception)
    puts
  end
end

Rake.application.instance_eval do
  class << self
    include RakeExceptionChatter
  end
end

# Rails environment sanity check.
if fetch(:rails_env)
  raise "Please refrain from setting the :rails_env parameter. We use :rack_env instead."
end

# We always derive the environment from the stage.
set :rack_env, fetch(:stage).to_s.gsub(%r{\d}, '')

# Rack environment sanity check.
unless %w{ test staging production }.include? fetch(:rack_env)
  raise "#{fetch(:rack_env).inspect} does not seem to be a valid Rails environment."
end

# Making sure we set the right environment in every context.
fetch(:default_env).merge! rack_env: fetch(:rack_env)

# Unlike "normal" capistrano, we deploy right into the repository.
set :deploy_to, "/mnt/apps/#{fetch(:application)}/repository"

# The branch can be set in various ways, default is master.
set :branch, ENV['branch'] || ENV['BRANCH'] || fetch(:branch, :master)

# Keep track of whether we should run migrations or not.
# We do this to get rid of the overhead of maintaining a separate "migrations" task.
set :migrate, ENV['migrate'] || ENV['MIGRATE'] || fetch(:migrate, false)

# Branch sanity check
if fetch(:rack_env).to_s.downcase == 'production' && fetch(:branch).to_s.downcase != 'master' && ENV['i_dont_know_what_im_doing'] != 'true'
  message = "You are courageous, trying to deploy the branch #{fetch(:branch).inspect} to production.\n"
  message += "If you know what you're doing you can bypass this warning by adding this to your cap command: i_dont_know_what_im_doing=true"
  raise message
end

# What would life be without monkey patches...
# See https://github.com/capistrano/sshkit/issues/35
module SSHKit
  class Command
    def with(&block)
      return yield unless environment_hash.any?
      command = yield
      env = '/usr/bin/env'
      env_user = options[:user]
      prefix = "[ -e /mnt/envs/#{env_user} ] && . /mnt/envs/#{env_user};"
      if command.match env
        command.sub env, "#{prefix} \\0 #{environment_string}"
      else
        "( #{prefix} #{environment_string} #{command} )"
      end
    end
  end
end

# The more monkeys the better...
module Capistrano
  class Configuration
    class Server < SSHKit::Host
      class Properties

        # Making the properties indifferent to symbol/string keys.
        def fetch(key)
          @properties[key] || @properties[key.to_s]
        end
      end
    end
  end
end
