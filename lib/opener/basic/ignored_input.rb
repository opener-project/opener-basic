module Opener
  module Basic
    ##
    # Sinatra/Rack middleware used for preventing requests from being executed
    # based on basic pattern matching of specific input.
    #
    # @!attribute [r] application
    #  @return [Mixed]
    #
    class IgnoredInput < Sinatra::Base
      ##
      # Array of regular expressions that will cause the middleware to abort
      # the incoming request.
      #
      # @return [Array]
      #
      IGNORE_MATCHES = [
        /$internal server error/i
      ].freeze

      before do
        IGNORE_MATCHES.each do |regexp|
          if params[:input] =~ regexp
            halt(400, "Ignoring request due to bad input (matches #{regexp})")
          end
        end
      end
    end # IgnoredInput
  end # Basic
end # Opener
