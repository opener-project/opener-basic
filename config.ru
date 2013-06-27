require 'bundler/setup'
require 'active_support/inflector'
require 'rack'

module OpenerBasic
  module_function
  def module_name_to_const(string)
    klass = string.split("-").map(&:camelize).join
    "Opener::#{klass}::Server".constantize
  end

  def module_name_to_require(string)
    #"opener/#{string.gsub(/-/,"_")}/server".downcase
    "opener/#{string.gsub(/-/,"_")}".downcase
  end

  def modules
    [ "language-identifier",
      "tokenizer",
      "POS-tagger",
      "polarity-tagger",
      "opinion-detector",
      "ner" ]
  end
end

use Rack::Static, :urls => {"/markdown.css" => '/css/markdown.css'}, :root => 'public'

OpenerBasic.modules.each do |module_name|
  lib = OpenerBasic.module_name_to_require(module_name)
  require lib
  require "#{lib}/server"

  send(:map, "/#{module_name}") do
    run OpenerBasic.module_name_to_const(module_name)
  end

end
