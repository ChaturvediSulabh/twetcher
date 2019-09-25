require 'twitter'
# require 'yaml'
require 'pry'

class Twetcher
  
  attr_accessor(:client, :tags, :count)

  private
  def set_twitter_client
    client = Twitter::REST::Client.new do |config|
      
      file = open("private/secrets", "r")
      file.each do |line|
        line = line.split("=")
        if line[0].strip === "config.consumer_key"
          config.consumer_key = line[1].strip
        elsif line[0].strip == "config.consumer_secret"
          config.consumer_secret = line[1].strip
        elsif line[0].strip == "config.access_token"
          config.access_token = line[1].strip
        elsif line[0].strip == "config.access_token_secret"
          config.access_token_secret = line[1].strip
        end
      end
      file.close()
    end
    return client
  end

  public
  def tw_search
    client = set_twitter_client
    tags.each do |tag|
      # binding.pry
      tweets = client.search(tag, result_type: "recent").take(@count)
      puts "[#{tag}]"
      tweets.collect do |tweet|
        puts "\t#{tweet.user.screen_name}: #{tweet.text}"
      end
    end
  end
end

# Get me latest 5 Kubernetes tweets
my_search = Twetcher.new
my_search.tags = ["kubernetes", "AWS", "DevOps", "CICD"]
my_search.count = 3
my_search.tw_search
