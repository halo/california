# The basic capistrano framework provides us with a certain order of tasks when you run "rake deploy".
# See https://github.com/capistrano/capistrano/blob/master/lib/capistrano/tasks/framework.rake
# In the code below we hook in into those tasks specified in that predefined deploy framework.

namespace :deploy do

  # –––––––––––––
  # Notifications
  # –––––––––––––

  task :starting do
    logger.info '<DEPLOY> <STARTING> Starting notifications...'
  end

  # –––––––––––––––––
  # Updating the code
  # –––––––––––––––––

  task :updating do
    logger.info '<DEPLOY> <UPDATING> Updating the repository...'

    on roles :app do |host|
      as fetch(:application) do
        within fetch(:deploy_to) do

          # Remembering which revision we had before making any changes.
          set :previous_revision, capture(:git, 'rev-parse', 'HEAD')

          # Updating the code.
          execute :git, :reset, '--hard'
          execute :git, :fetch, :origin
          execute :git, :checkout, fetch(:branch)
          execute :git, :pull, :origin, fetch(:branch)

          # The update went well so let's persist the revision change.
          # Note: We use ruby because there is no bash command that can write to files *without I/O redirection*.
          set :current_revision, capture(:git, 'rev-parse', 'HEAD')
          execute :ruby, '-e', %{"File.write :REVISION.to_s,      %|#{fetch(:current_revision)}|"  }
          execute :ruby, '-e', %{"File.write :PREV_REVISION.to_s, %|#{fetch(:previous_revision)}|" }
          execute :ruby, '-e', %{"File.write :BRANCH.to_s,        %|#{fetch(:branch)}|"            }
        end
      end
    end
  end

  # –––––––––––––––
  # Running Bundler
  # –––––––––––––––

  task :updated do
    logger.info '<DEPLOY> <UPDATED> Running Bundler...'

    on roles :app do |host|
      as fetch(:application) do
        within fetch(:deploy_to) do

          # Running Bundler.
          execute :bundle, :install, '--deployment', '--quiet', '--without', 'development', 'test'
        end
      end
    end
  end

  # ––––––––––––––––––
  # Restarting the app
  # ––––––––––––––––––

  task :publishing do
    logger.info '<DEPLOY> <PUBLISHING> Restarting the app...'

    on roles :app do |host|
      as fetch(:application) do
        within File.join(fetch(:deploy_to), 'tmp') do

          execute :touch, 'restart.txt'
        end
      end
    end
  end

  # ––––––––––––––––––––––––––
  # Persisting the deploy time
  # ––––––––––––––––––––––––––

  task :finishing do
    logger.info '<DEPLOY> <FINISHING> Persisting the deploy time...'

    on roles :app do |host|
      as fetch(:application) do
        within fetch(:deploy_to) do

          execute :ruby, '-e', %{'File.write :DEPLOYED_AT.to_s, Time.now'}
        end
      end
    end
  end

  task :finished do
    logger.info '<DEPLOY> <FINISHED> Congratulations! ¯\_(ツ)_/¯'
  end

  task :failed do
    logger.info '<DEPLOY> <FAILED> Oh no, the deployment failed'
    puts
  end

end
