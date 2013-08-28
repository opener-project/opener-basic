require 'socket'

module Opener
  module Basic
    ##
    # Throttle class that limits the amount of POST requests. This class does
    # not enforce a rate limit for the server itself.
    #
    class PostInterval < Rack::Throttle::Interval
      ##
      # @param [Rack::Request] request
      # @return [TrueClass|FalseClass]
      #
      def allowed?(request)
        if whitelisted?(request) or method_whitelisted?(request)
          return true
        end

        return super
      end

      ##
      # @param [Rack::Request] request
      # @return [TrueClass|FalseClass]
      #
      def whitelisted?(request)
        return local_ips.include?(request.ip)
      end

      ##
      # @param [Rack::Request] request
      #
      def method_whitelisted?(request)
        return request.request_method == 'GET'
      end

      ##
      # @return [Array]
      #
      def local_ips
        return @local_ips ||= Socket.ip_address_list.map(&:ip_address)
      end
    end
  end # Basic
end # Opener
