require 'hobby'
require 'hobby/json'

class App
  include Hobby::App
  include Hobby::JSON

  post '/event' do
    begin
      response.status = 201
      { id: self.class.name, text: (reverse json['text']) }
    rescue
      response.status = 417
    end
  end

  def reverse text
    text.reverse
  end


  get '/echo' do json end
end
