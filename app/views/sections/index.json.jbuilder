json.array!(@sections) do |section|
  json.extract! section, :id, :code, :warehouse_id
  json.url section_url(section, format: :json)
end
