require 'httpclient'
require 'logger'

logger     = Logger.new(STDOUT)
amount     = 100
entrypoint = 'http://opener.olery.com'
callbacks  = [
  'tokenizer',
  'pos-tagger',
  'polarity-tagger',
  'opinion-detector',
  'outlet'
]

input = <<-EOF.strip
President Morsi has rejected an ultimatum to "meet the demands of the people"
or face military intervention.

He says he is Egypt's legitimate leader and will not be forced to resign.

The army says it will issue a statement after the 16:30 (14:30 GMT) deadline
expires, and now has control of the state TV building.

Clashes broke out at rival protests across the country overnight, with at least
16 people who were demonstrating against Mohammed Morsi killed at Cairo
University.

Mr Morsi's opponents say he and the Muslim Brotherhood party from which he
comes are pushing an Islamist agenda onto Egypt, and that he should stand down.

The Brotherhood has said the army's action amounts to a coup.

In a defiant televised speech on Tuesday evening, Mr Morsi said he would give
his life to defend constitutional legitimacy, and blamed the unrest on
corruption and remnants of the ousted regime of Hosni Mubarak.
EOF

start     = "#{entrypoint}/language-identifier"
callbacks = callbacks.map { |path| "#{entrypoint}/#{path}" }
params    = {:input => input, :kaf => true, :'callbacks[]' => callbacks}

amount.times do |n|
  logger.info("Sending request ##{n + 1}")

  HTTPClient.post(start, :body => params)
end
