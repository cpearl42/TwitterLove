TwitterLove
===========

Ruby code that uses TweetStream gem to pull tweet data with "I love you'" in the Tweet.

- Use "GetTwitterUpdates.rb" to extract Twitter data.  Requires Twitter dev account/credentials and a twitter.yml file.  Does coorindate lookup for location using geolcoder gem. ccesses Google API which has a limited number of requests.
- Use "Extract States.rb" to pull only those tweets that map to a US state.  (Uses cities.txt and states.csv)
- Use "GetTweetTerm.rb" on your data from GetTwitterUpdates to look for a specific term in the tweet.

