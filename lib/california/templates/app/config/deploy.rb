set :application, File.basename(File.expand_path('../..', __FILE__))

# Disallow robots unless deploying to production.
after 'deploy:updated', 'deploy:disallow_robots'

# For Rails you should uncomment these custom task hooks.
# after 'deploy:updated', 'rails:assets:precompile'
# after 'deploy:updated', 'rails:migrate'
