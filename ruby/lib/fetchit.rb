#!/usr/bin/env ruby
#
require "rubygems"
require "bundler/setup"

#require "httmultiparty"
require "httparty"
require "base64"
require "time"
require "yaml"

CONFIG = YAML.load_file("config.yml") unless defined? CONFIG

class FetchEveryone
  include HTTParty
  #base_uri = "https://api.fetcheveryone.com" # This defaults to http for some reason :-( so can't use

  def initialize(k, s)
    authorization = Base64.strict_encode64("#{k}:#{s}")
    response = self.class.post(
      'https://api.fetcheveryone.com/token.php',
      headers: {'Accept' => 'application/json', 'Authorization' => "Basic #{authorization}"}
    )
    @access_token = response['access_token']
  end

  def getResource(resource, options = nil)
    encoded_opts = "&#{URI.encode_www_form(options)}" unless options.nil?
    response = self.class.get(
      "https://api.fetcheveryone.com/api.php?request=#{resource}#{encoded_opts}",
      headers: {'Authorization' => "Bearer #{@access_token}", 'Content-type' => 'application/json'},
    )
    puts response.body
  end

end

fe = FetchEveryone.new("#{CONFIG['api_key']}", "#{CONFIG['api_secret']}")
#fe.getResource("forum/threads")
fe.getResource("forum/threads", {category: "training", items: 5})
