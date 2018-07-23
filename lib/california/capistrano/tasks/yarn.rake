namespace :yarn do

  task :install do
    logger.info 'Installing yarn dependencies...'

    on roles :web_server do
      as fetch(:application) do
        within fetch(:deploy_to) do
          execute :yarn, :install
        end
      end
    end
  end

end
