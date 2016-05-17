# If you ever get annoyed by the output you can set the log level to info.
# Note that you will *not* see what failed, though!
# set :log_level, :info

require 'logging'

module BenderLogger
  def self.logger
    @logger ||= logger!
  end

  def self.logger!
    Logging.color_scheme 'bright', date: :blue, logger: :magenta, message: :white
    layout = Logging.layouts.pattern pattern: pattern, color_scheme: 'bright'
    Logging.appenders.stdout 'stdout', auto_flushing: true, layout: layout

    result = Logging.logger['CAP']
    result.add_appenders 'stdout'
    result.level = fetch(:log_level)
    result
  end

  def self.pattern
    ['▬' * 72, ' \n%m\n', '▬' * 72, '\n'].join
  end
end

def logger
  BenderLogger.logger
end

ENV['SSHKIT_COLOR'] = 'true'

module SSHKit
  module Formatter
    class Pretty
      def prefix(command)
        %(#{c.green(command.uuid)}  #{c.blue(command.host.to_s.ljust(15))})
      end

      def write_command(command) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
        unless command.started?
          original_output << %(#{prefix(command)} #{c.yellow(c.bold(command.to_command))}\n)
        end

        unless command.stdout.empty?
          command.stdout.lines.each do |line|
            original_output << %(#{prefix(command)} #{line})
            original_output << "\n" unless line[-1] == "\n"
          end
        end

        unless command.stderr.empty?
          command.stderr.lines.each do |line|
            original_output << %(#{prefix(command)} #{line})
            original_output << "\n" unless line[-1] == "\n"
          end
        end
      end
    end
  end
end

# Rails environment sanity check.
if fetch(:rails_env)
  raise 'Please refrain from setting the :rails_env parameter. We use :rack_env instead.'
end

# We always derive the environment from the stage.
set :rack_env, fetch(:stage).to_s.gsub(/\d/, '')

# Rack environment sanity check.
unless %w(test staging production).include? fetch(:rack_env)
  raise "#{fetch(:rack_env).inspect} does not seem to be a valid Rails environment."
end

# Making sure we set the right environment in every context.
fetch(:default_env)[:rack_env] = fetch(:rack_env)

# Unlike "normal" capistrano, we deploy right into the repository.
set :deploy_to, "/mnt/apps/#{fetch(:application)}/repository"
# Alias for cap task that use release_path
set :release_path, -> { fetch(:deploy_to) }

# The branch can be set in various ways, default is master.
set :branch, ENV['branch'] || ENV['BRANCH'] || fetch(:branch, :master)

# Keep track of whether we should run migrations or not.
# We do this to get rid of the overhead of maintaining a separate "migrations" task.
set :migrate, ENV['migrate'] || ENV['MIGRATE'] || fetch(:migrate, false)

# Branch sanity check
def insane?
  rack_env = fetch(:rack_env).to_s.downcase
  branch = fetch(:branch).to_s.downcase
  insane = ENV['i_dont_know_what_im_doing']

  rack_env == 'production' && branch != 'master' && insane != 'true'
end

if insane?
  message = "You are courageous, trying to deploy the branch #{fetch(:branch).inspect} to production.\n"
  message += "If you know what you're doing you can bypass this warning \
    by adding this to your cap command: i_dont_know_what_im_doing=true"
  raise message
end

# What would life be without monkey patches...
module SSHKit
  class Command
    def user
      return yield unless options[:user]

      bash_command = [
        "export HOME=/mnt/apps/#{options[:user]};",
        'export PATH="$HOME/bin:$PATH";',
        'source $HOME/.bash_profile;',
        'source $HOME/.bash_profile;',
        yield.to_s.gsub("'", %q('"'"')),
      ].join(' ')

      %(sudo -u #{options[:user]} #{environment_string} -- bash -c '#{bash_command}')
    end
  end

  class CommandMap
    def defaults
      Hash.new do |hash, command|
        hash[command] = command.to_s
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
