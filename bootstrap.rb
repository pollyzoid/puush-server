require 'sinatra/base'
require 'dm-core'
require 'dm-aggregates'
require 'dm-timestamps'

class Application < Sinatra::Base
  puts ">> Running in #{settings.environment} environment"

  set :config, YAML::load(File.read 'config.yml')

  set :title, "puush.proxy"

  configure :development do
    use Rack::CommonLogger
    DataMapper::Logger.new($stdout, :debug)
  end

  configure :production do
  end

  configure do
    puts config['database'][settings.environment.to_s]
    DataMapper.setup :default, config['database'][settings.environment.to_s]
  end
end

require_relative 'lib/helpers.rb'

require_relative 'models/user'
require_relative 'models/file'

DataMapper.finalize

require_relative 'controllers/api.rb'
require_relative 'controllers/view.rb'

require_relative 'controllers/home.rb'