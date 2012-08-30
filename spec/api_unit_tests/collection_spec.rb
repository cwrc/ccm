require 'ccm_api_test'

def create_sample_collection_desc(collection_name)
  '<oai_dc:dc xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/oai_dc/ http://www.openarchives.org/OAI/2.0/oai_dc.xsd">
    <dc:title>' + collection_name + '</dc:title>
    <dc:creator></dc:creator>
    <dc:subject></dc:subject>
    <dc:description></dc:description>
    <dc:publisher></dc:publisher>
    <dc:contributor></dc:contributor>
    <dc:date></dc:date>
    <dc:type></dc:type>
    <dc:format></dc:format>
    <dc:identifier></dc:identifier>
    <dc:source></dc:source>
    <dc:language></dc:language>
    <dc:relation></dc:relation>
    <dc:coverage></dc:coverage>
    <dc:rights></dc:rights>
</oai_dc:dc>
  '
end


def verify_collection_list_format(json_array)
  raise "No collections found. Please create some collections and re-run this test." if json_array.count == 0
  json_array.each do |entry|
    raise "Collection id is empty" if entry["id"].nil? || entry["id"].length == 0 
    raise "Entity name is empty" if entry["name"].nil? || entry["name"].length == 0
  end
end

def verify_entity_desc_format(desc_doc)
  root = desc_doc.root
  
  expected_tag = ENV["entity_root_tag"]
  raise "Expected root tag is #{expected_tag}, found #{root.name}." if root.name != expected_tag
end
