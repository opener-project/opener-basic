require 'bundler/setup'
require 'active_support/inflector'
require 'rack'

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

modules.each do |module_name|
  require module_name_to_require(module_name)

  eval(%Q{
    map "/#{module_name}" do
      run #{module_name_to_const(module_name)}
    end
  })

end
