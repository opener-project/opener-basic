require 'bundler/setup'
require File.expand_path('../lib/opener/basic', __FILE__)
require File.expand_path('../config/rollbar', __FILE__)

use ActiveRecord::ConnectionAdapters::ConnectionManagement

# Limit the amount of requests to 1 per second and store them in a fixed hash
# so that the application doesn't leak memory.
use Opener::Basic::PostInterval,
  :min   => 1.0,
  :cache => Opener::Basic::FixedHash.new

use Opener::Basic::IgnoredInput

Opener::Basic::MODULES.each do |module_name|
  require_path = Opener::Basic.module_name_to_require(module_name)

  require(require_path)
  require(File.join(require_path, 'server'))

  map "/#{module_name.downcase}" do
    constant = Opener::Basic.module_name_to_const(module_name)

    # Using #configure doesn't work if there already is a configuration object
    # in place (by the looks of it).
    if Sinatra::Base.environment == :production
      constant.set :raise_errors, false
      constant.set :show_exceptions, false
    end

    constant.error do
      Rollbar.report_exception(
        env['sinatra.error'],
        :module     => module_name,
        :parameters => params
      )

      halt(500, env['sinatra.error'].message)
    end

    run constant
  end
end

map '/' do
  run Opener::Basic::Server
end
