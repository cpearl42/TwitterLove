require 'fileutils'

data_file = ARGV[0]
term = ARGV[1].downcase

@count = 0
@tweets = 0

# Open data file and read in user name, location, coordinates, tweet
File.open(data_file) do |fp|
    fp.each do |line|
        @tweets += 1
        line = line.chomp.split("\t")
        tweet = line[3].downcase
        #words = tweet.split(/\W+/)

        if tweet.include?(term)
            @count += 1
        end
    end
end

puts "Total number of tweets: #{@tweets}"
puts "The number of tweets that include the term '#{term}' is #{@count}."

