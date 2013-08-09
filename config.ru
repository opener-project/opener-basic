require 'bundler/setup'
require File.expand_path('../lib/opener/basic', __FILE__)
require File.expand_path('../config/rollbar', __FILE__)

use ActiveRecord::ConnectionAdapters::ConnectionManagement
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
      Rollbar.report_exception(env['sinatra.error'], :module => module_name)

      halt(500, env['sinatra.error'].message)
    end

    run constant
  end
end

map '/' do
  run Opener::Basic::Server
end
