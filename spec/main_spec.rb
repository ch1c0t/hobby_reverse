require 'helper'

describe App do
  before do
    @child_pid = fork do
      Thread.abort_on_exception = true
      begin
        server = Puma::Server.new App.new
        server.add_unix_listener "#{$$}.socket"
        server.run
        sleep
      rescue StandardError => error
        IO.write "#{$$}.failed", error.inspect
      end
    end

    until (File.exist? "#{@child_pid}.socket") ||
          (File.exist? "#{@child_pid}.failed")
      sleep 0.01
    end
  end

  after do
    `kill #{@child_pid}`
    #puts IO.read "#{@child_pid}.failed"
    file = "#{@child_pid}.failed"
    `rm #{file}` if File.exist? file
  end

  it do
    connection = Excon.new 'unix:///', socket: "#{@child_pid}.socket"
    response = connection.get path: '/'
    assert { response.status == 404 }
  end

  it do
    connection = Excon.new 'unix:///', socket: "#{@child_pid}.socket"
    response = connection.post path: '/event', body: {text: 'text'}.to_json
    json = JSON.parse response.body
    assert { json['id'] == 'App' }
    assert { json['text'] == 'txet' }
  end
end
