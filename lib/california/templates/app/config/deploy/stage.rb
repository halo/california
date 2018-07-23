# First we need to set a stage name.
# This is usually an environment such as `production`, `staging`, or `test`.
# By default, the stage name is derived from the filename of THIS file.
set :stage, File.basename(__FILE__, '.rb')

# By default, we will run `bundle install`, to skip that, uncomment the following line.
# This is useful for non-ruby applications.
# set :skip_bundler, true

# By default the webserver is restarted using `/usr/bin/passenger-config`.
# If you prefer the old-fashioned `touch tmp/restart.txt` uncomment the following line.
# set :restart_strategy, 'restart.txt'

# You can skip the restart alltogether by uncommenting the following line.
# set :skip_restart, true

# You may also set any custom Capistrano options if you wish:
# set :ssh_options, {
#   forward_agent: true,
#   port: 12345,
#   keys: Pathname.new('~/.ssh/mykey').expand_path.to_s,
# }

# That's all for custom configuration. Now we can load the default configuration.
load 'california/stage'

# Important: Now you need to define AT LEAST ONE server.

# Example: The one with the role "migrator" will be entitled to run migrations:
# server '203.0.113.19', roles: %w{ all app web_server migrator }
