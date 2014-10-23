json.array!(@storeusers) do |storeuser|
  json.extract! storeuser, :id
  json.url storeuser_url(storeuser, format: :json)
end
