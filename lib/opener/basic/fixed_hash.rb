require 'thread'

module Opener
  module Basic
    ##
    # The FixedHash class is a Hash with a fixed size. Whenever the specified
    # limit is reached the oldest N keys are removed before inserting the new
    # one. This is similar to LRU mechanisms but easier as there's no need to
    # keep track of when a key was last used.
    #
    # @!attribute [r] limit
    #  @return [Fixnum]
    #
    # @!attribute [r] remove
    #  @return [Fixnum]
    #
    # @!attribute [r] keys
    #  @return [Array]
    #
    class FixedHash
      attr_reader :limit, :remove, :keys

      ##
      # @param [Fixnum] limit The amount of keys to store.
      # @param [Fixnum] remove The amount of keys to remove when the limit has
      #  been reached.
      #
      def initialize(limit = 50, remove = 10)
        if remove > limit
          raise(
            ArgumentError,
            'You can not remove more items than the maximum amount'
          )
        end

        @hash   = {}
        @limit  = limit
        @remove = remove
        @mutex  = Mutex.new
        @keys   = []
      end

      ##
      # @param [Mixed] key
      # @return [Mixed]
      #
      def [](key)
        return @mutex.synchronize { @hash[key] }
      end

      ##
      # @param [Mixed] key
      # @param [Mixed] value
      #
      def []=(key, value)
        prune_hash if @keys.length >= limit

        keys << key

        @mutex.synchronize { @hash[key] = value }
      end

      private

      ##
      # Removes the `N` first items of the Hash.
      #
      def prune_hash
        @mutex.synchronize do
          remove.times do
            @hash.delete(keys.shift)
          end
        end
      end
    end # FixedHash
  end # Basic
end # Opener
