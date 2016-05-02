# The stage name is derived from this very filename.
set :stage, File.basename(__FILE__, '.rb')

# Loading defaults.
load 'bender/stage.rb'

# You need to define at least one server.
# The one with the role "migrator" will be entitled to run migrations:
# server '203.0.113.19', roles: %w{ all app web_server migrator }

# You may also set any custom Capistrano options:
# set :ssh_options, {
#   forward_agent: true,
#   port: 12345,
#   keys: Pathname.new('~/.ssh/mykey').expand_path.to_s,
# }
