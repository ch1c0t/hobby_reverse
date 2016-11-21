require 'hobby'

class App
  include Hobby::App
  use Rack::ContentType, 'application/json'

  post '/event' do
    begin
      text = (JSON.parse request.body.read)['text']
      response.status = 201
      { id: self.class.name, text: (reverse text) }.to_json
    rescue
      response.status = 417
    end
  end

  def reverse text
    text.reverse
  end
end
