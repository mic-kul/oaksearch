json.array!(@features) do |feature|
  json.extract! feature, :id, :feature_id, :feature_type, :feature_name
end
