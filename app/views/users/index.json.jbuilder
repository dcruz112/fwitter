json.array!(@users) do |user|
  json.extract! user, :first_name, :last_name, :netid, :handle, :biography, :current_location
  json.url user_url(user, format: :json)
end