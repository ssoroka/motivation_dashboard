class FayeClient
  include Singleton
  attr_reader :client
  
  def initialize
    ensure_em_running! {
      @client = Faye::Client.new("http://0.0.0.0:8000/faye", :timeout => 120)
    }
  end
  
  def test
    publish('/alert', {'text' => 'this is a test alert from ruby'})
  end
  
  def publish(channel, message)
    client.publish(channel, message)
  end
  
  def ensure_em_running!
    Thread.new { EM.run } unless EM.reactor_running?
    yield
    sleep 0.1 until EM.reactor_running?
  end
end
