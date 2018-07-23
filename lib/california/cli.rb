require 'thor'

module California
  class Cli < Thor
    include Thor::Actions

    desc 'generate APPNAME', 'Generates the skeleton for a new app'

    def generate(appname)
      template 'templates/app/Capfile', "#{appname}/Capfile"
      template 'templates/app/config/deploy.rb', "#{appname}/config/deploy.rb"
      template 'templates/app/config/deploy/stage.rb', "#{appname}/config/deploy/staging.rb"
      template 'templates/app/config/deploy/stage.rb', "#{appname}/config/deploy/production.rb"
    end

    def self.source_root
      File.dirname __FILE__
    end
  end
end
