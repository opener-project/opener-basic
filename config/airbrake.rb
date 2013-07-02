if ENV['RACK_ENV'] == 'production'
  Airbrake.configure do |config|
    config.api_key = '6fc8b369088de85fce0aafd13ca0490c'
  end
end
