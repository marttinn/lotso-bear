json.array!(@subsections) do |subsection|
  json.extract! subsection, :id, :code, :section_id
  json.url subsection_url(subsection, format: :json)
end