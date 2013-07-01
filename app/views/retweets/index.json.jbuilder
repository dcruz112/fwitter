json.array!(@retweets) do |retweet|
  json.extract! retweet, :content, :user_id, :poster_id
  json.url retweet_url(retweet, format: :json)
end