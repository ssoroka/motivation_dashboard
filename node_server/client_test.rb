require 'rubygems'
gem 'bundler'
require 'bundler'
Bundler.setup

require 'eventmachine'
require 'faye'

client = Faye::Client.new('http://localhost:8000/faye')

EM.run {
  # client.publish('/alert', 'text' => 'this is a test alert from ruby') {
  client.publish('/msg', 'test') {
    EM.stop
  }
}
