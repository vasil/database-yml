require 'sinatra/base'
require 'logger'
require "dm-core"

module Sinatra
  module DatabaseYml
    LOGGER = ::Logger.new(STDERR)
    class Configuration
      attr_accessor :database_configuration_file

      def initialize
        self.database_configuration_file  =
          Sinatra::Application.respond_to?(:database_configuration_file) ?
          File.join(Sinatra::Application.root, database_configuration_file) :
          default_database_configuration_file
      end

      def database_configuration
        require 'erb'
        YAML::load(ERB.new(IO.read(default_database_configuration_file)).result)
      end

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

      def start_logging
        ::DataMapper.logger = LOGGER
        ::DataMapper.logger.info("Connecting to database...")
      end
      def setup_connection
        config = configuration.database_configuration[Sinatra::Application.environment.to_s]
        ::DataMapper.setup(:default, config) unless config.empty?
        ::DataMapper.auto_upgrade! if !test? and ::DataMapper.respond_to?(:auto_upgrade!)
      end
    end

    self.configuration = Configuration.new

    Sinatra::Application.configure do
      #LOGGER = Rack::CommonLogger.new(Sinatra::Application)

      if File.exists?(configuration.database_configuration_file)
        start_logging
        setup_connection
      else
        LOGGER.error "No #{configuration.default_database_configuration_file} file found."
        exit(1)
      end
    end
  end
end
