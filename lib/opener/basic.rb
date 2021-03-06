require 'sinatra'
require 'rollbar'
require 'active_support/inflector'
require 'active_record'
require 'rack/throttle'

require_relative 'basic/fixed_hash'
require_relative 'basic/ignored_input'
require_relative 'basic/post_limit'
require_relative 'basic/server'
require 'opener/scorer'

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
      "tree-tagger",
      "constituent-parser",
      "ner",
      "ned",
      "coreference",
      "polarity-tagger",
      "property-tagger",
      "opinion-detector",
      "opinion-detector-basic",
      "kaf_to_json",
      "scorer",
      "outlet",
      "s3-outlet",
    ].freeze

    PROCESSORS = [
      "language-identifier",
      ["tokenizer", "required step (unless you paste in KAF and know what you're doing)"],
      ["tree-tagger", "please select either tree OR pos-tagger"],
      ["POS-tagger", "please select either tree OR pos-tagger"],
      ["polarity-tagger", "detects if words are positive or negative"],
      ["property-tagger", "detects hotel specific topics like 'room' and 'value for money'"],
      ["constituent-parser", "required for Coreference Resolution"],
      ["NER", "detects named entities, required for NED"],
      ["Coreference", "Co-reference resolution"],
      ["NED", "disambiguates named entities"],
      ["opinion-detector", "detects opinions, works best with all other options turned on."],
      ["opinion-detector-basic", "detects opinions, works best if the text has gone through the polarity-tagger."],
      ["kaf_to_json", "Converts KAF to JSON. Don't use with scorer."]
    ]

    OUTLETS = [
      ["scorer", "aggregates the opinions from the opinion-detector into values between -1 and 1"],
      ["outlet", "stores a KAF document in the database for later retrieval"],
      ["s3-outlet", "stores the KAF document in S3. If you have OpeNER credentials this makes it easy to retrieve the files from disk"]
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
