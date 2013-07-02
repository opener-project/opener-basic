require 'sinatra'
require 'airbrake'
require 'active_support/inflector'
require 'active_record'

require_relative 'basic/ignored_input'
require_relative 'basic/server'

module Opener
  module Basic
    ##
    # Array of the opener modules to load.
    #
    # @return [Array]
    #
    MODULES = [
      "language-identifier",
      "tokenizer",
      "POS-tagger",
      "polarity-tagger",
      "opinion-detector",
      "ner",
      "ned",
      "constituent-parser",
      "outlet"
    ].freeze

    ##
    # @param [String] string
    # @return [Class]
    #
    def self.module_name_to_const(string)
      klass = string.split("-").map(&:camelize).join

      return "Opener::#{klass}::Server".constantize
    end

    ##
    # @param [String] string
    # @return [String]
    #
    def self.module_name_to_require(string)
      return "opener/#{string.gsub(/-/,"_")}".downcase
    end
  end # Basic
end # Opener
