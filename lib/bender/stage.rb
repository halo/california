module BenderLogger
  def self.logger
    @logger ||= logger!
  end

  def self.logger!
    instance = ::Logger.new STDOUT
    instance.formatter = proc do |_, _, _, msg|
      line = '–' * (msg.size + 2)
      [nil, line, " #{msg}", line, nil].join("\n") + "\n"
    end
    instance
  end

end

def logger
  BenderLogger.logger
end

# Rails environment sanity check.
if fetch(:rails_env)
  raise 'Please refrain from setting the :rails_env parameter. We use :rack_env instead.'
end

# We derive the environment from the stage name.
set :rack_env, 'production' if fetch(:stage).to_s.include?('production')
set :rack_env, 'staging' if fetch(:stage).to_s.include?('staging')
set :rack_env, 'test' if fetch(:stage).to_s.include?('test')

# Rack environment sanity check.
unless %w[test staging production].include? fetch(:rack_env)
  raise "#{fetch(:rack_env).inspect} does not seem to be a valid Rails environment."
end

# Making sure we set the right environment in every context.
fetch(:default_env)[:rack_env] = fetch(:rack_env)
fetch(:default_env)[:rails_env] = fetch(:rack_env)

# Unlike "normal" capistrano, we deploy right into the repository.
set :deploy_to, "/mnt/apps/#{fetch(:application)}/repository"
# Alias for cap task that use release_path
set(:release_path, -> { fetch(:deploy_to) })

# The branch can be set in various ways, default is master.
set :branch, ENV['branch'] || ENV['BRANCH'] || fetch(:branch, :master)

# Keep track of whether we should run migrations or not.
# We do this to get rid of the overhead of maintaining a separate "migrations" task.
set :migrate, ENV['migrate'] || ENV['MIGRATE'] || fetch(:migrate, false)

# Branch sanity check
in_production = fetch(:rack_env).to_s.downcase == 'production'
non_master_branch = fetch(:branch).to_s.downcase != 'master'

if in_production && non_master_branch && ENV['i_dont_know_what_im_doing'] != 'true'
  message = "You are courageous, trying to deploy the branch #{fetch(:branch).inspect} to production.\n"
  message += "If you know what you're doing you can bypass this warning \
    by adding this to your cap command: i_dont_know_what_im_doing=true"
  raise message
end

module SSHKit
  class Command
    # Define $HOME to be in /mnt/apps/USERNAME
    # Add ~/bin to $PATH
    # Source any existing .bash_profile in the home directory
    def user
      return yield unless options[:user]
      %(sudo -u #{options[:user]} #{environment_string} -- bash -c '\
        export HOME=/mnt/apps/#{options[:user]}; \
        export PATH="$HOME/bin:$PATH"; \
        source $HOME/.bash_profile; \
        #{yield.to_s.gsub("'", %q('"'"'))}')
    end
  end

  class CommandMap
    def defaults
      Hash.new do |hash, command|
        # Avoid using `/usr/bin/env` at all
        hash[command] = command.to_s
      end
    end
  end
end

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
