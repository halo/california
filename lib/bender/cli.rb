require 'thor'

module Bender
  class Cli < Thor
    include Thor::Actions

    desc 'generate APPNAME', 'Generates the skeleton for a new app'

    def generate(appname)
      template 'templates/app/Capfile', "#{appname}/Capfile"
      template 'templates/app/deploy.rb', "#{appname}/deploy.rb"
      template 'templates/app/deploy/stage.rb', "#{appname}/deploy/staging.rb"
      template 'templates/app/deploy/stage.rb', "#{appname}/deploy/production.rb"
    end

    def self.source_root
      File.dirname __FILE__
    end

  end
end
