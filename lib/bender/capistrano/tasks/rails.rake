namespace :rails do

  namespace :assets do
    task :precompile do
      logger.info '<RAILS> <ASSETS> <PRECOMPILE> Precompiling assets on all web servers...'

      on roles :web_server do
        as fetch(:application) do
         within fetch(:deploy_to) do
            execute :bundle, :exec, :rake, 'assets:precompile'
          end
       end
      end
    end
  end

  task :migrate do
    on primary :migrator do |host|
      logger.info "<RAILS> <MIGRATE> Migrating the database..."

      as fetch(:application) do
        if fetch(:migrate)
          within fetch(:deploy_to) do
            execute :bundle, :exec, :rake, 'db:migrate'
          end
        else
          logger.warn "Skipping Rails migrations because you did NOT add this to your cap command: migrate=true"
        end
      end
    end
  end

end
