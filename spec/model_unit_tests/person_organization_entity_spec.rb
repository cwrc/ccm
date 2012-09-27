require 'spec_helper'

def create_sample_person_desc(forename, surname)
   '<?xml version="1.0" encoding="UTF-8"?>
    <?xml-model href="http://www.cwrc.ca/schema/entities" type="application/xml" schematypens="http://relaxng.org/ns/structure/1.0"?>
    <entity>
        <person>
            <recordInfo>
                <originInfo>
                    <projectId>orlando</projectId>
                    <projectId>ceww</projectId>
                </originInfo>
                <personTypes>
                    <personType>orl:BWW</personType>
                </personTypes>
            </recordInfo>
            <identity>
                <preferredForm>
                    <namePart partType="surname">' + surname + '</namePart>
                    <namePart partType="forename">' + forename + '</namePart>
                </preferredForm>
                <variantForms>
                    <variant>
                        <namePart>' + "#{surname}, #{forename}" + '</namePart>
                        <authorizedBy>
                            <projectId>orlando</projectId>
                        </authorizedBy>
                    </variant>
                    <variant>
                        <variantType>birthName</variantType>
                        <namePart>Alexandrina Victoria</namePart>
                    </variant>
                    <variant>
                        <variantType/>
                        <namePart>Queen Victoria</namePart>
                    </variant>
                    <variant>
                        <variantType>titledName</variantType>
                        <namePart>Queen Victoria, Empress of
                            India</namePart>
                    </variant>
                    <variant>
                        <variantType>usedForm</variantType>
                        <namePart>Princess Victoria</namePart>
                    </variant>
                </variantForms>
            </identity>
            <description>
                <existDates>
                    <dateRange>
                        <fromDate>
                            <standardDate>1819-05-24</standardDate>
                            <dateType>birth</dateType>
                        </fromDate>
                        <toDate>
                            <standardDate>1901-01-22</standardDate>
                            <dateType>death</dateType>
                        </toDate>
                    </dateRange>
                </existDates>
            </description>
        </person>
    </entity>'
end

def create_sample_organization_desc(org_name)
   '<?xml version="1.0" encoding="UTF-8"?>
    <?xml-model href="http://www.cwrc.ca/schema/entities" type="application/xml" schematypens="http://relaxng.org/ns/structure/1.0"?>
    <entity>
        <organization>
            <recordInfo>
                <originInfo>
                    <projectId>orlando</projectId>
                </originInfo>
            </recordInfo>
            <identity>
                <preferredForm>
                    <namePart>'+org_name+'</namePart>
                    <displayLabel/>
                </preferredForm>
                <variantForms>
                    <variant>
                        <namePart>BBC</namePart>
                    </variant>
                    <variant>
                        <namePart>BBC World Service</namePart>
                        <picklist/>
                    </variant>
                    <variant>
                        <namePart>British Broadcasting Corporation</namePart>
                        <picklist>YES</picklist>
                    </variant>
                    <variant>
                        <namePart>British Broadcasting Company</namePart>
                        <picklist/>
                    </variant>
                    <variant>
                        <namePart>BBC Overseas Service</namePart>
                        <picklist/>
                    </variant>
                    <variant>
                        <namePart>BBC Radio 3</namePart>
                        <picklist/>
                    </variant>
                    <variant>
                        <namePart>BBC Radio 4</namePart>
                        <picklist/>
                    </variant>
                    <variant>
                        <namePart>BBC Radio Four</namePart>
                        <picklist/>
                    </variant>
                    <variant>
                        <namePart>BBC Television</namePart>
                        <picklist/>
                    </variant>
                    <variant>
                        <namePart>BBC Radio</namePart>
                        <picklist/>
                    </variant>
                    <variant>
                        <namePart>BBC Western Region</namePart>
                        <picklist/>
                    </variant>
                    <variant>
                        <namePart>BBC Home Service</namePart>
                        <picklist/>
                    </variant>
                    <variant>
                        <namePart>BBC Third Programme</namePart>
                        <picklist/>
                    </variant>
                    <variant>
                        <namePart>BBC International Service</namePart>
                        <picklist/>
                    </variant>
                    <variant>
                        <namePart>BBC International World Service</namePart>
                        <picklist/>
                    </variant>
                </variantForms>
            </identity>
            <description>
                <orgTypes>
                    <orgType>broadcasting</orgType>
                </orgTypes>
            </description>
        </organization>
    </entity>'
end

describe "person entity" do
  it "creates new person" do
    
    #creates a new person description
    firstname = "firstname #{rand(1000)}"
    lastname = "lastname #{rand(1000)}"
    desc = create_sample_person_desc(firstname, lastname)
    
    #Create the new entity
    entity = CwrcEntity.new_entity(desc)
    entity.save
    
    #namespace of entity PID should be "person"
    pid = entity.pid
    raise "Namespace of PID of person should be \"person\". Current PID #{pid}" unless pid.start_with?("person:");
    
    #Verifying DC mapping
    #====================
    dc = entity.get_dc
    
    #Since displayForm is not specified in the sample person template, the dc:title should be "lastname firstname"
    expected_title = "#{lastname} #{firstname}"
    raise "Expected DC title = '#{expected_title}'. Found '#{dc.title}'" unless expected_title == dc.title
    
    raise "Expected type = 'person', found '#{dc.type}'" unless dc.type == 'person'
    
  end

  it "creates new organization" do
    
    #creates a new person description
    org_name = "Organization #{rand(1000)}"
    desc = create_sample_organization_desc(org_name)
    
    #Create the new entity
    entity = CwrcEntity.new_entity(desc)
    entity.save
    
    #namespace of entity PID should be "person"
    pid = entity.pid
    raise "Namespace of PID of person should be \"organization:\". Current PID #{pid}" unless pid.start_with?("organization:");
    
    #Verifying DC mapping
    #====================
    dc = entity.get_dc
    
    #Since displayForm is not specified in the sample person template, the dc:title should be "lastname firstname"
    raise "Expected DC title = '#{org_name}'. Found '#{dc.title}'" unless org_name == dc.title
    
    raise "Expected type = 'organization', found '#{dc.type}'" unless dc.type == 'organization'
    
  end

end