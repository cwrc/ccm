require 'ccm_api_test'

describe "item" do
  it "saves items with processing instructions" do

    ins_1 = '<?xml version="1.0" encoding="UTF-8"?>'
    ins_2 = '<?xml-model href="http://www.cwrc.ca/schema/cwrcbasic" type="application/xml" schematypens="http://relaxng.org/ns/structure/1.0"?>'
    ins_3 = '<?xml-stylesheet type="text/css" href="http://www.cwrc.ca/templates/css/tei.css"?>'
    ins_4 = '<?xml-stylesheet type="text/css" href="http://www.cwrc.ca/templates/css/tei.css"?>'
    
    desc = ins_1 + ins_2 + ins_3 + '
<TEI xmlns="http://www.tei-c.org/ns/1.0">
    <teiHeader>
        ' + ins_4 + '
        <fileDesc>
            <titleStmt>
                <title>Sample Document Title</title>
            </titleStmt>
            <publicationStmt>
                <p/>
            </publicationStmt>
            <sourceDesc sameAs="http://www.cwrc.ca">
                <p>Created from original research by members of CWRC/CSÉC unless otherwise
                    noted.</p>
            </sourceDesc>
        </fileDesc>
    </teiHeader>
    <text>
        <body>
            <div type="event">
                <head>
                    <title>Sample Events from Bertrand Russell to Patricia Spence letter - October 21, 1935</title>
                </head>
                
                <listEvent>
                    <event><desc><date cert="definite" when="1935-10-21">Today</date> <name type="event:agent" sameAs="http://viaf.org/viaf/36924137/">my</name> journey lasts from 9 till 9 - fortunately one of the most beautiful railway journeys in the world.</desc></event>
                    <event when="1935-10-22"><desc> <date type="event:time" calendar="gregorian"  when="1935-10-22">Tomorrow</date> I lecture at <placeName type="event:place">Bergen</placeName> to the <orgName sameAs="http://cwrc.ca/organization/6545466" cert="probable">Anglo-Norwegian Society</orgName>.</desc></event>
                    <event><desc>Next day I go back to Oslo, lecture there Fri. and Sat.</desc></event>
                    <event><desc>and then start for home via Bergen</desc></event>
                </listEvent>
            </div>
        </body>
    </text>
</TEI>
'
    
    item = CwrcItem.new
    item.replace_xml_description(desc)
    item.name = "sample item desc"
    
    item.save
    pid = item.pid
    
    raise "Item creation failed" if pid.start_with?("-") #A minus sign
    
    puts pid
    reloaded_item = CwrcItem.find(pid)
    
    source_xml = Nokogiri::XML(desc);
    retrieved_xml = Nokogiri::XML(reloaded_item.get_xml_description)
    
    #puts "Saved:"
    #puts item.get_xml_description
    
    #puts "Retrieved:"
    #puts item2.get_xml_description
    
    #both documents should have the same number of childrenn (i.e. one root node and the same number of root-level processing instructions)
    raise "The retrieved doc should have #{source_xml.children.count} root-level children but found #{retrieved_xml.children.count}" unless source_xml.children.count == retrieved_xml.children.count
    
  end
end