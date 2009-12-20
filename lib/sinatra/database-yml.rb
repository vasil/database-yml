require 'sinatra/base'
require "dm-core"

module Sinatra
  module DatabaseYml

    class Configuration
      attr_accessor :database_configuration_file

      def initialize
        self.database_configuration_file  =
          Sinatra::Application.respond_to?(:database_configuration_file) ?
          Sinatra::Application.database_configuration_file :
          default_database_configuration_file
      end

      def database_configuration
        require 'erb'
        YAML::load(ERB.new(IO.read(default_database_configuration_file)).result)
      end

      private
      def default_database_configuration_file
        File.join(Sinatra::Application.root, 'config', 'database.yml')
      end
    end

    class << self
      def configuration
        @@configuration
      end

      def configuration=(configuration)
        @@configuration = configuration
      end

      def initialize_database
        DataMapper.setup(:default,
          configuration.database_configuration[Sinatra::Application.environment.to_s])
        DataMapper.auto_upgrade!(:default)
      end

      def initialize_database_logger
        if DataMapper::Repository.adapters[:default]
          case Sinatra::environment
          when :development then DataMapper::Logger.new(STDOUT,  :debug)
          when :production  then DataMapper::Logger.new(LOGFILE, :warning)
          end
        end
      end
    end

    self.configuration = Configuration.new

    Sinatra::Application.configure do
      initialize_database
    end

  end
end