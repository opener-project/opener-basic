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
    "opener/#{string.gsub(/-/,"_")}/server".downcase
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
  require OpenerBasic.module_name_to_require(module_name)

  map "/#{module_name}" do
    run OpenerBasic.module_name_to_const(module_name)
  end
end
