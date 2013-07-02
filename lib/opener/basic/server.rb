module Opener
  module Basic
    ##
    # Sinatra server that wraps the various individual ones.
    #
    class Server < Sinatra::Base
      configure do
        set :views, File.expand_path('../views', __FILE__)
        set :public_dir, File.expand_path('../public', __FILE__)
      end

      configure :production do
        use Airbrake::Rack
      end

      get '/' do
        erb :index
      end
    end # Server
  end # Basic
end # Opener
