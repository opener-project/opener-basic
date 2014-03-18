require 'sinatra'
require 'rollbar'
require 'active_support/inflector'
require 'active_record'
require 'rack/throttle'

require_relative 'basic/fixed_hash'
require_relative 'basic/ignored_input'
require_relative 'basic/post_limit'
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
      "tree-tagger",
      "POS-tagger",
      "polarity-tagger",
      "property-tagger",
      "constituent-parser",
      "kaf-naf-parser",
      "ner",
      "scorer",
      "ned",
      "opinion-detector",
      "outlet",
      "s3-outlet",
    ].freeze

    PROCESSORS = [
      "language-identifier",
      "tokenizer",
      "tree-tagger",
      "POS-tagger",
      "polarity-tagger",
      "property-tagger",
      "constituent-parser",
      "kaf-naf-parser",
      "ner",
      "ned",
      "opinion-detector"
    ]

    OUTLETS = [
      "scorer",
      "outlet",
      "s3-outlet"
    ]

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
