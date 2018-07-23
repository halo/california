set :application, File.basename(File.expand_path('..', __dir__))

# Disallow robots unless deploying to production.
after 'deploy:updated', 'deploy:disallow_robots'

# For Rails you may uncomment these custom task hooks.
# after 'deploy:updated', 'yarn:install'
# after 'deploy:updated', 'rails:assets:precompile'
# after 'deploy:updated', 'rails:migrate'
