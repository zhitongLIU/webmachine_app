require 'bundler'
Bundler.setup

require 'active_support'
require 'webmachine'
require 'pry'
require 'reel'
require 'net/http'
require 'scout_apm'
require 'byebug'

module WebmachineApp
end

class HelloWorld < Webmachine::Resource
  # GET and HEAD are allowed by default, but are shown here for clarity.
  def allowed_methods
    ['GET','HEAD']
  end

  def content_types_provided
    [['application/json', :to_json]]
  end

  def to_json
    uri = URI('http://www.google.com')
    Net::HTTP.get(uri)
    { hello: "world" }.to_json
  end
end

WebmachineAppApplication = Webmachine::Application.new do |app|
  app.routes do
    add ['hello_world'], HelloWorld
  end

  app.configure do |config|
    config.ip      = '0.0.0.0'
    config.port    = ARGV[0]
    config.adapter = :Reel
  end
end


WebmachineAppApplication.run
