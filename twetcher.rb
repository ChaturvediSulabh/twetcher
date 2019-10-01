require 'twitter'
require 'json'
require 'yaml'

class TwClient
  attr_writer :client

  private
  def initialize
    @client = Twitter::REST::Client.new do |config|
      if File.file?("./private/secrets.json")
        file = File.read("./private/secrets.json")
        auth_hash = JSON.parse(file)
        config.consumer_key = auth_hash["config.consumer_key"]
        config.consumer_secret = auth_hash["config.consumer_secret"]
        config.access_token = auth_hash["config.access_token"]
        config.access_token_secret = auth_hash["config.access_token_secret"]
      end
    end
    return @client
  end
end

class TwSearch < TwClient
  def tw_search(tags, count)
    tags.each do |tag|
      puts "[#{tag}]"
      tag = "#"+tag+" -rt"
      tweets = @client.search(tag, result_type: "recent").take(count)
      tweets.each do |tweet|
       puts "\t#{tweet.full_text}" 
      end
       File.write('tweets.yml', YAML.dump(tweets))
    end
  end
end

my_search = TwSearch.new
my_search.tw_search(["kubernetes", "AWS", "DevOps", "cicd"], 3)
