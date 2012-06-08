# encoding: utf-8

require_relative '../environment'
require_relative '../lib/service_check'

describe ServiceCheck do
  def app
    Sinatra::Application
  end

  it "returns correct HTTP results for google.com" do
    http_check = ServiceCheck.check_http('google.com')
    http_check.should eq({code: '301', message: 'Moved Permanently', server: 'gws'})
  end
end