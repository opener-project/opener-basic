require 'rollbar'

env = Sinatra::Base.environment.to_s

Rollbar.configure do |config|
  config.access_token = '419e9e11a03b4d94ba9cdff24867f9e9'
  config.enabled      = %w{production staging}.include?(env)
  config.environment  = env
  config.use_async    = false
end
