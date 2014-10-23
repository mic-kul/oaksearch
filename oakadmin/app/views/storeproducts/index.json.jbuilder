json.array!(@storeproducts) do |storeproduct|
  json.extract! storeproduct, :id
  json.url storeproduct_url(storeproduct, format: :json)
end
