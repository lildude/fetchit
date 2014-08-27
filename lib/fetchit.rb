require "rubygems"
require "bundler/setup"
require "httparty"
require "base64"
require "yaml"

CONFIG = YAML.load_file("config.yml") unless defined? CONFIG

class FetchEveryone
  include HTTParty
  # Debug HTTParty
  #debug_output

  base_uri "https://api.fetcheveryone.com"

  def initialize(k, s)
    authorization = Base64.strict_encode64("#{k}:#{s}")
    response = self.class.post(
      '/token.php',
      headers: {'Accept' => 'application/json', 'Authorization' => "Basic #{authorization}"}
    )
    @access_token = response['access_token']
  end

  def getResource(resource, options = nil)
    encoded_opts = "&#{URI.encode_www_form(options)}" unless options.nil?
    response = self.class.get(
      "/api.php?request=#{resource}#{encoded_opts}",
      headers: {'Authorization' => "Bearer #{@access_token}", 'Content-type' => 'application/json'},
    )
  end

  def putResource(resource, options = nil)
    options[:uid] = CONFIG['uid']
    options[:method].upcase!
    options[:category].upcase!
    gz = self.gzdeflate(File.read("#{options[:data]}"))
    options[:data] = CGI::escape(gz)
    response = self.class.post(
      "/api.php?request=#{resource}",
      headers: {'Authorization' => "Bearer #{@access_token}", 'Accept' => 'application/json'},
      body: options
    )
  end

  def gzdeflate (s)
    Zlib::Deflate.new().deflate(s, Zlib::FINISH)
  end
end

fe = FetchEveryone.new("#{CONFIG['api_key']}", "#{CONFIG['api_secret']}")
#puts fe.getResource("forum/threads")
#puts fe.getResource("forum/threads", {category: "training", items: 5})
#puts fe.putResource("training/import", {method: "tcx", category: "r", data: "/Users/lildude/Library/Application Support/Garmin/GarminConnect/Unknown ANT Device-3834404765/Upload/FitnessHistory/2014-08-23-082929.TCX"})
puts fe.getResource("training/entries", {uid: CONFIG['uid'], mindate: "2014-08-01", maxdate: "2014-08-05"})
