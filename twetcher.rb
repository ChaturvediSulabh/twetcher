require 'twitter'
require 'pry'
require 'json'

class Twetcher
  
  attr_accessor(:client, :tags, :count)
 
  def tw_search
    client = set_twitter_client
    @tags.each do |tag|
      # binding.pry
      tweets = client.search(tag, result_type: "recent").take(@count)
      puts "[#{tag}]"
      tweets.collect do |tweet|
        puts "\t#{tweet.user.screen_name}: #{tweet.text}"
      end
    end
  end

  def initialize(tags, count)
    @tags, @count = tags, count
  end

  private
  def set_twitter_client
    client = Twitter::REST::Client.new do |config|
      if File.file?("./private/secrets.json")
        file = File.read("./private/secrets.json")
        auth_hash = JSON.parse(file)
        config.consumer_key = auth_hash["config.consumer_key"]
        config.consumer_secret = auth_hash["config.consumer_secret"]
        config.access_token = auth_hash["config.access_token"]
        config.access_token_secret = auth_hash["config.access_token_secret"]
      end
    end
    return client
  end
end

my_search = Twetcher.new(["kubernetes", "AWS", "DevOps", "cicd"], 3)
my_search.tw_search
