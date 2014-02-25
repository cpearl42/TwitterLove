require 'tweetstream'
require 'time'
require 'yaml'
require 'geocoder'

# We use the TweetStream gem to access Twitter's Streaming API.
# https://github.com/intridea/tweetstream
 
TweetStream.configure do |config|
  settings = YAML.load_file File.dirname(__FILE__) + '/twitter.yml'
 
  config.consumer_key       = settings['consumer_key']
  config.consumer_secret    = settings['consumer_secret']
  config.oauth_token        = settings['oauth_token']
  config.oauth_token_secret = settings['oauth_token_secret']
end
 
def getState(coordinates)    
    state = "NONE_C"
    final_coordinates = coordinates[0][0]
    
    longitude = final_coordinates[0]
    latitude = final_coordinates[1]
    
    search_coordinates = "#{latitude},#{longitude}"

    results = Geocoder.search(search_coordinates)
  
    if results[0]
        state = results[0].state
    end

    return state
end

# Start getting tweets!!
TweetStream::Client.new.on_error do |message|
  # Log your error message somewhere
  puts "We've got a problem."
  puts message
end.track('i love you') do |status|
  # Do things when nothing's wrong
  tweet = status.text
  created_at = status.created_at
  retweeted = status.retweeted_status
  username = status.user.screen_name
  location = status.user.location

  # Need to strip out newlines
  tweet = tweet.gsub("\r", "***")
  tweet = tweet.gsub("\n", "***")
  
  # Remove special chars
  location = location.tr('^A-Za-z0-9,!;\'\. ', '')
  if location == ""
    location = "NONE_L"
  end
  
  tweet.tr!('^A-Za-z0-9,!;\'\. ', '')
  
  # We only want ones that have the exact phrase, i love you  
  # And no Retweets
  if (/i love you/i).match(tweet) && retweeted.inspect == '<null>'
    # If coordinates are filled in, get state
    coordinates = status.place.bounding_box.coordinates
  
    if coordinates.inspect == '<null>'
        state = "NONE_C"
    else
        state = getState(coordinates)
    end
    
    # Print everything
    puts "[#{username}]\t#{location}\t#{state}\t#{tweet}"
  end 
  
end
