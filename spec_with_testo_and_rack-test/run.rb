require_relative '../app'
require 'testo/test'
require 'rack/test'

class Test < Testo::Test
  include Rack::Test::Methods

  def app
    App.new
  end
end

test = Test.new do
  post '/event', {text: 'text'}.to_json,
    { "CONTENT_TYPE" => 'application/json' }

  json = JSON.parse last_response.body

  #json['id'] == 'App' && json['text'] == 'txet'
  json['id'] == 'WrongAssertion' && json['text'] == 'txet'
end

require 'pry'
binding.pry
test

#[3] pry(main)> report.debug
#RuntimeError: You want to finish 4 frames, but stack size is only 1
#from /home/ch1c0t/.gem/ruby/2.4.0/gems/pry-byebug-3.4.2/lib/byebug/processors/pry_processor.rb:18:in `step_out'`
#
# wtf?
# TODO: find out debugging doesn't work here
