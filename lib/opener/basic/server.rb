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
        set :raise_errors, false
        set :show_exceptions, false

        # Errors are already tracked in Rollbar and they only clog log files.
        set :dump_errors, false
      end

      error do
        Rollbar.report_exception(env['sinatra.error'])

        halt(500, env['sinatra.error'].message)
      end

      get '/' do
        erb :index
      end
    end # Server
  end # Basic
end # Opener
