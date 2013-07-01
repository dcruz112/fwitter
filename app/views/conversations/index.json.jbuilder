json.array!(@conversations) do |conversation|
  json.extract! conversation, 
  json.url conversation_url(conversation, format: :json)
end