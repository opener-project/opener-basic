require 'sinatra'

class Index < Sinatra::Base
  get '/' do
    erb :index
  end
end
