require 'twitter'
require 'yaml'

client = Twitter::REST::Client.new do |config|

  file = open("private/secrets", "r")

  file.each do |line|

    line = line.split("=")
    puts "#{line[0]}: #{line[1]}"

    if line[0].strip === "config.consumer_key"
      puts "hello 1"
      config.consumer_key = line[1].strip
    elsif line[0].strip == "config.consumer_secret"
      puts "hello 2"
      config.consumer_secret = line[1].strip
    elsif line[0].strip == "config.access_token"
      puts "hello 3"
      config.access_token = line[1].strip
    elsif line[0].strip == "config.access_token_secret"
      puts "hello 4"
      config.access_token_secret = line[1].strip
    end

  end

  file.close()

end

def tw_search(client, tag, limit)
  tweets = client.search('Kubernetes', result_type: "recent").take(10)
  tweets.collect do |tweet|
    puts "[#{tag}]: #{tweet.user.screen_name}: #{tweet.text}"
  end
end

tw_search(client, "AWS", 3)
tw_search(client, "DevOps", 3)
tw_search(client, "Kubernetes", 3)
