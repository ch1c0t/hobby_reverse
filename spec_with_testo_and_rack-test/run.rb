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
  #json['id'] == 'WrongAssertion' && json['text'] == 'txet'
  json['id'] == 'App' # passing but not covering App#replace to let some mutants stay alive
end

if ENV['MUTANT']
  require 'mutant'

  class Mutant::Selector::Expression
    def call _subject
      integration.all_tests
    end
  end

  module Integration
    extend self

    def all_tests
    end

    def call tests
    end

    def new _config
      self
    end

    def setup
      self
    end
  end

  namespace = App.name
  c = Mutant::Config::DEFAULT
  config = c.with \
    matcher: c.matcher.add(:match_expression, c.expression_parser.(namespace)),
    integration: Integration
  env = Mutant::Env::Bootstrap.call config

  puts "{env.mutatitions.size} mutations are to be checked."
  alive_mutants = env.mutations.map.with_index 1 do |mutation, index|
    puts index
    env.kill mutation
  end.reject &:success?

  if alive_mutants.empty?
    puts "No alive mutants were found."
  else
    require 'pry'
    alive_mutants.__binding__.pry
  end
else
  report = test[:anything]

  if report.ok?
    puts 'All passed.'
  else
    require 'pry'
    binding.pry
    report.debug
  end
end
