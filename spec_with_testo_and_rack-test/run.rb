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
report = test[:anything]
binding.pry
report.debug
