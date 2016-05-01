namespace :deploy do
  desc "Disallow robots unless deploying to production."
  task :disallow_robots do
    return if fetch(:stage) == :production

    on roles :app do |host|
      as fetch(:application) do
        within File.join(fetch(:deploy_to), 'public') do
          execute :echo, %{"User-agent: *\nDisallow: /\n" > robots.txt}
        end
      end
    end
  end
end

after "deploy:updating", "deploy:disallow_robots"