require 'bundler/setup'
require File.expand_path('../lib/opener/basic', __FILE__)
require File.expand_path('../config/airbrake', __FILE__)

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
    constant.use Airbrake::Rack

    run constant
  end
end

map '/' do
  run Opener::Basic::Server
end
