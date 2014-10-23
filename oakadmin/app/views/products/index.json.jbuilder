json.array!(@products) do |product|
  json.extract! product, :id, :product_id, :name, :description, :created_by, :created_date, :modified_by, :modified_date
  json.url product_url(product, format: :json)
end
