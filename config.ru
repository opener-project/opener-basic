require 'bundler/setup'
require File.expand_path('../lib/opener/basic', __FILE__)
require File.expand_path('../config/airbrake', __FILE__)

Opener::Basic::MODULES.each do |module_name|
  require_path = Opener::Basic.module_name_to_require(module_name)

  require(require_path)
  require(File.join(require_path, 'server'))

  map "/#{module_name}" do
    constant = Opener::Basic.module_name_to_const(module_name)

    constant.configure :production do
      enable :raise_errors
      use Airbrake::Rack
    end

    run constant
  end
end

map '/' do
  run Opener::Basic::Server
end
