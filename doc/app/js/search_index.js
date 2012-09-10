var search_data = {"index":{"info":[["ApplicationController","","ApplicationController.html","",""],["ApplicationHelper","","ApplicationHelper.html","",""],["CcmBase","","CcmBase.html","","<p>This is the base class for all CWRC models.\n"],["CcmContentDatastream","","CcmContentDatastream.html","","<p>a Fedora Datastream object containing information about a Person entity\n"],["CcmDatastreamMethods","","CcmDatastreamMethods.html","","<p>This module defines common methods for data streams used in CCM models\n"],["CcmDcDatastream","","CcmDcDatastream.html","",""],["CollectionController","","CollectionController.html","",""],["CwrcCollection","","CwrcCollection.html","","<p>This class represents CWRC Collections.\n"],["CwrcDatastream","","CwrcDatastream.html","","<p>a Fedora Datastream object containing information about a Person entity\n"],["CwrcEntity","","CwrcEntity.html","",""],["CwrcItem","","CwrcItem.html","",""],["EntityController","","EntityController.html","",""],["ItemController","","ItemController.html","",""],["SolrDocument","","SolrDocument.html","",""],["TestController","","TestController.html","",""],["User","","User.html","",""],["add_contributor","CcmDcDatastream","CcmDcDatastream.html#method-i-add_contributor","(val)",""],["add_contributor","CwrcCollection","CwrcCollection.html#method-i-add_contributor","(val)",""],["add_element","CcmDatastreamMethods","CcmDatastreamMethods.html#method-i-add_element","(xpathToParent, childXmlString)",""],["add_language","CcmDcDatastream","CcmDcDatastream.html#method-i-add_language","(val)",""],["add_language","CwrcCollection","CwrcCollection.html#method-i-add_language","(val)",""],["add_publisher","CcmDcDatastream","CcmDcDatastream.html#method-i-add_publisher","(val)",""],["add_stamp_string","CwrcItem","CwrcItem.html#method-i-add_stamp_string","(xmlstring)",""],["add_to_collection","CcmBase","CcmBase.html#method-i-add_to_collection","(parentCollectionIDs)","<p>Adds this collection to a set of parent collections\n<p><strong> Params: </strong>\n<p>parentCollectionIDs: an array of parent collection …\n"],["add_to_collection","ItemController","ItemController.html#method-i-add_to_collection","()",""],["add_workflow_stamp","ItemController","ItemController.html#method-i-add_workflow_stamp","()",""],["children","CollectionController","CollectionController.html#method-i-children","()",""],["collection_content","TestController","TestController.html#method-i-collection_content","()",""],["collections","TestController","TestController.html#method-i-collections","()",""],["contributors","CcmDcDatastream","CcmDcDatastream.html#method-i-contributors","()",""],["created","CcmDcDatastream","CcmDcDatastream.html#method-i-created","()",""],["created","CwrcCollection","CwrcCollection.html#method-i-created","()","<p>Returns collection creation date\n"],["created=","CcmDcDatastream","CcmDcDatastream.html#method-i-created-3D","(val)",""],["created=","CwrcCollection","CwrcCollection.html#method-i-created-3D","(val)","<p>Sets collection creation date forcefully\n"],["creator","CcmDcDatastream","CcmDcDatastream.html#method-i-creator","()",""],["creator=","CcmDcDatastream","CcmDcDatastream.html#method-i-creator-3D","(val)",""],["date","CcmDcDatastream","CcmDcDatastream.html#method-i-date","()",""],["date=","CcmDcDatastream","CcmDcDatastream.html#method-i-date-3D","(val)",""],["delete","CollectionController","CollectionController.html#method-i-delete","()",""],["delete","EntityController","EntityController.html#method-i-delete","()",""],["delete","ItemController","ItemController.html#method-i-delete","()",""],["delete_all","CwrcEntity","CwrcEntity.html#method-c-delete_all","()",""],["entity_manager","TestController","TestController.html#method-i-entity_manager","()",""],["get_child_ids","CwrcCollection","CwrcCollection.html#method-i-get_child_ids","()",""],["get_children","CwrcCollection","CwrcCollection.html#method-i-get_children","(retCollectionsOnly = false, recurse = false, result = nil)",""],["get_contributors","CwrcCollection","CwrcCollection.html#method-i-get_contributors","()",""],["get_dc","CcmBase","CcmBase.html#method-i-get_dc","()","<p>Returns the DC datastream associated with the object\n"],["get_latest_pids","CwrcCollection","CwrcCollection.html#method-c-get_latest_pids","()","<p>def to_solr(solr_doc=Hash.new)\n\n<pre>super\nsolr_doc[&quot;object_type_facet&quot;] = &quot;CwrcContent&quot;\nreturn solr_doc</pre>\n<p>end …\n"],["get_latest_pids","CwrcEntity","CwrcEntity.html#method-c-get_latest_pids","()",""],["get_parent_collections","CollectionController","CollectionController.html#method-i-get_parent_collections","()",""],["get_parent_collections","ItemController","ItemController.html#method-i-get_parent_collections","()",""],["get_parent_ids","CwrcCollection","CwrcCollection.html#method-i-get_parent_ids","()","<p>def get_child_collections(recurse = false, result = nil)\n\n<pre>result = Array.new if result.nil?\n\nmembers.each ...</pre>\n"],["get_parent_ids","CwrcItem","CwrcItem.html#method-i-get_parent_ids","()",""],["get_stamp_array","CwrcItem","CwrcItem.html#method-i-get_stamp_array","()",""],["get_text","CcmDatastreamMethods","CcmDatastreamMethods.html#method-i-get_text","(xpathToElement)",""],["get_workflow_stamps","ItemController","ItemController.html#method-i-get_workflow_stamps","()",""],["get_xml_description","CcmDatastreamMethods","CcmDatastreamMethods.html#method-i-get_xml_description","()",""],["get_xml_description","CwrcCollection","CwrcCollection.html#method-i-get_xml_description","()",""],["get_xml_description","CwrcDatastream","CwrcDatastream.html#method-i-get_xml_description","()",""],["get_xml_description","CwrcEntity","CwrcEntity.html#method-i-get_xml_description","()","<p>def self.list_ids(pageNumber, itemsPerPage)\n\n<pre class=\"ruby\"><span class=\"ruby-identifier\">entities</span> = <span class=\"ruby-constant\">CwrcEntity</span>.<span class=\"ruby-identifier\">find</span>(:<span class=\"ruby-identifier\">all</span>).<span class=\"ruby-identifier\">paginate</span>(:<span class=\"ruby-identifier\">page</span> =<span class=\"ruby-operator\">&gt;</span> <span class=\"ruby-identifier\">pageNumber</span>, <span class=\"ruby-operator\">...</span>\n</pre>\n"],["get_xml_description","CwrcItem","CwrcItem.html#method-i-get_xml_description","()",""],["get_xml_element","CcmContentDatastream","CcmContentDatastream.html#method-i-get_xml_element","()",""],["get_xml_string","CcmContentDatastream","CcmContentDatastream.html#method-i-get_xml_string","()",""],["identifier","CcmDcDatastream","CcmDcDatastream.html#method-i-identifier","()",""],["identifier=","CcmDcDatastream","CcmDcDatastream.html#method-i-identifier-3D","(val)",""],["index","TestController","TestController.html#method-i-index","()",""],["items","TestController","TestController.html#method-i-items","()",""],["languages","CcmDcDatastream","CcmDcDatastream.html#method-i-languages","()",""],["layout_name","ApplicationController","ApplicationController.html#method-i-layout_name","()",""],["link_collection","CollectionController","CollectionController.html#method-i-link_collection","()",""],["link_item","CollectionController","CollectionController.html#method-i-link_item","()",""],["list","CollectionController","CollectionController.html#method-i-list","()",""],["list","EntityController","EntityController.html#method-i-list","()",""],["list","ItemController","ItemController.html#method-i-list","()",""],["max_records","ApplicationController","ApplicationController.html#method-i-max_records","()",""],["name","CwrcCollection","CwrcCollection.html#method-i-name","()","<p>Returns collection name\n"],["name=","CwrcCollection","CwrcCollection.html#method-i-name-3D","(val)","<p>Sets collection name\n"],["new","CcmBase","CcmBase.html#method-c-new","()","<p>Constructor\n"],["new","CwrcCollection","CwrcCollection.html#method-c-new","()","<p>Creates a new collection\n"],["owner","CwrcCollection","CwrcCollection.html#method-i-owner","()","<p>Returns collection owner\n"],["owner=","CwrcCollection","CwrcCollection.html#method-i-owner-3D","(val)","<p>Sets collection owner\n"],["publishers","CcmDcDatastream","CcmDcDatastream.html#method-i-publishers","()",""],["remove_contributor","CcmDcDatastream","CcmDcDatastream.html#method-i-remove_contributor","(val)",""],["remove_element","CcmDatastreamMethods","CcmDatastreamMethods.html#method-i-remove_element","(xpathToElement, matchingText = nil)",""],["remove_from_collection","CcmBase","CcmBase.html#method-i-remove_from_collection","(collectionIDs)","<p>Removes this collection from parent collections\n<p><strong> Params: </strong>\n<p>parentCollectionIDs: an array of parent collection …\n"],["remove_from_collection","ItemController","ItemController.html#method-i-remove_from_collection","()",""],["remove_language","CcmDcDatastream","CcmDcDatastream.html#method-i-remove_language","(val)",""],["remove_publisher","CcmDcDatastream","CcmDcDatastream.html#method-i-remove_publisher","(val)",""],["replace_xml_description","CcmDatastreamMethods","CcmDatastreamMethods.html#method-i-replace_xml_description","(xmlString)",""],["replace_xml_description","CwrcDatastream","CwrcDatastream.html#method-i-replace_xml_description","(xmlString)",""],["replace_xml_description","CwrcEntity","CwrcEntity.html#method-i-replace_xml_description","(xmlString)",""],["replace_xml_description","CwrcItem","CwrcItem.html#method-i-replace_xml_description","(xmlString)",""],["replace_xml_element","CcmContentDatastream","CcmContentDatastream.html#method-i-replace_xml_element","(xmlElement)",""],["replace_xml_string","CcmContentDatastream","CcmContentDatastream.html#method-i-replace_xml_string","(xmlString)",""],["rights","CcmDcDatastream","CcmDcDatastream.html#method-i-rights","()",""],["rights","CwrcCollection","CwrcCollection.html#method-i-rights","()",""],["rights=","CcmDcDatastream","CcmDcDatastream.html#method-i-rights-3D","(val)",""],["rights=","CwrcCollection","CwrcCollection.html#method-i-rights-3D","(val)",""],["save","CcmBase","CcmBase.html#method-i-save","()","<p>Saves the object. If this is a new object, then this call makes sure the\nsaved object ID is added to …\n"],["save","CollectionController","CollectionController.html#method-i-save","()",""],["save","EntityController","EntityController.html#method-i-save","()",""],["save","ItemController","ItemController.html#method-i-save","()",""],["set_text","CcmDatastreamMethods","CcmDatastreamMethods.html#method-i-set_text","(xpathToElement, text)",""],["show","CollectionController","CollectionController.html#method-i-show","()",""],["show","EntityController","EntityController.html#method-i-show","()",""],["show","ItemController","ItemController.html#method-i-show","()",""],["show_item_url","ApplicationHelper","ApplicationHelper.html#method-i-show_item_url","()",""],["test","TestController","TestController.html#method-i-test","()",""],["title","CcmDcDatastream","CcmDcDatastream.html#method-i-title","()",""],["title=","CcmDcDatastream","CcmDcDatastream.html#method-i-title-3D","(val)",""],["to_s","User","User.html#method-i-to_s","()","<p>Method added by Blacklight; Blacklight uses #to_s on your user class to get\na user-displayable login/identifier …\n"],["to_solr","CwrcEntity","CwrcEntity.html#method-i-to_solr","(solr_doc=Hash.new)",""],["type","CcmBase","CcmBase.html#method-i-type","()","<p>Returns object type\n"],["type","CcmDcDatastream","CcmDcDatastream.html#method-i-type","()",""],["type=","CcmBase","CcmBase.html#method-i-type-3D","(val)","<p>Sets object type\n"],["type=","CcmDcDatastream","CcmDcDatastream.html#method-i-type-3D","(val)",""],["unlink_collection","CollectionController","CollectionController.html#method-i-unlink_collection","()",""],["unlink_item","CollectionController","CollectionController.html#method-i-unlink_item","()",""],["workflow_engine_new_stamp_notification_api_url","ApplicationController","ApplicationController.html#method-i-workflow_engine_new_stamp_notification_api_url","()","<p>Set the following variable to the URL of the API call that must be used to\nnotify the Workflow Engine …\n"],["workflow_stamps","TestController","TestController.html#method-i-workflow_stamps","()",""],["xml_template","CcmContentDatastream","CcmContentDatastream.html#method-c-xml_template","()",""],["xml_template","CcmDcDatastream","CcmDcDatastream.html#method-c-xml_template","()",""],["xml_template","CwrcDatastream","CwrcDatastream.html#method-c-xml_template","()","<p>def create_xml_description(xmlString)\n\n<pre> ## Updates the XML description of the record using the given xmlString ...</pre>\n"],["README_FOR_APP","","doc/README_FOR_APP.html","","<p>Use this README file to introduce your application and point to useful\nplaces in the API for learning …\n"]],"searchIndex":["applicationcontroller","applicationhelper","ccmbase","ccmcontentdatastream","ccmdatastreammethods","ccmdcdatastream","collectioncontroller","cwrccollection","cwrcdatastream","cwrcentity","cwrcitem","entitycontroller","itemcontroller","solrdocument","testcontroller","user","add_contributor()","add_contributor()","add_element()","add_language()","add_language()","add_publisher()","add_stamp_string()","add_to_collection()","add_to_collection()","add_workflow_stamp()","children()","collection_content()","collections()","contributors()","created()","created()","created=()","created=()","creator()","creator=()","date()","date=()","delete()","delete()","delete()","delete_all()","entity_manager()","get_child_ids()","get_children()","get_contributors()","get_dc()","get_latest_pids()","get_latest_pids()","get_parent_collections()","get_parent_collections()","get_parent_ids()","get_parent_ids()","get_stamp_array()","get_text()","get_workflow_stamps()","get_xml_description()","get_xml_description()","get_xml_description()","get_xml_description()","get_xml_description()","get_xml_element()","get_xml_string()","identifier()","identifier=()","index()","items()","languages()","layout_name()","link_collection()","link_item()","list()","list()","list()","max_records()","name()","name=()","new()","new()","owner()","owner=()","publishers()","remove_contributor()","remove_element()","remove_from_collection()","remove_from_collection()","remove_language()","remove_publisher()","replace_xml_description()","replace_xml_description()","replace_xml_description()","replace_xml_description()","replace_xml_element()","replace_xml_string()","rights()","rights()","rights=()","rights=()","save()","save()","save()","save()","set_text()","show()","show()","show()","show_item_url()","test()","title()","title=()","to_s()","to_solr()","type()","type()","type=()","type=()","unlink_collection()","unlink_item()","workflow_engine_new_stamp_notification_api_url()","workflow_stamps()","xml_template()","xml_template()","xml_template()","readme_for_app"],"longSearchIndex":["applicationcontroller","applicationhelper","ccmbase","ccmcontentdatastream","ccmdatastreammethods","ccmdcdatastream","collectioncontroller","cwrccollection","cwrcdatastream","cwrcentity","cwrcitem","entitycontroller","itemcontroller","solrdocument","testcontroller","user","ccmdcdatastream#add_contributor()","cwrccollection#add_contributor()","ccmdatastreammethods#add_element()","ccmdcdatastream#add_language()","cwrccollection#add_language()","ccmdcdatastream#add_publisher()","cwrcitem#add_stamp_string()","ccmbase#add_to_collection()","itemcontroller#add_to_collection()","itemcontroller#add_workflow_stamp()","collectioncontroller#children()","testcontroller#collection_content()","testcontroller#collections()","ccmdcdatastream#contributors()","ccmdcdatastream#created()","cwrccollection#created()","ccmdcdatastream#created=()","cwrccollection#created=()","ccmdcdatastream#creator()","ccmdcdatastream#creator=()","ccmdcdatastream#date()","ccmdcdatastream#date=()","collectioncontroller#delete()","entitycontroller#delete()","itemcontroller#delete()","cwrcentity::delete_all()","testcontroller#entity_manager()","cwrccollection#get_child_ids()","cwrccollection#get_children()","cwrccollection#get_contributors()","ccmbase#get_dc()","cwrccollection::get_latest_pids()","cwrcentity::get_latest_pids()","collectioncontroller#get_parent_collections()","itemcontroller#get_parent_collections()","cwrccollection#get_parent_ids()","cwrcitem#get_parent_ids()","cwrcitem#get_stamp_array()","ccmdatastreammethods#get_text()","itemcontroller#get_workflow_stamps()","ccmdatastreammethods#get_xml_description()","cwrccollection#get_xml_description()","cwrcdatastream#get_xml_description()","cwrcentity#get_xml_description()","cwrcitem#get_xml_description()","ccmcontentdatastream#get_xml_element()","ccmcontentdatastream#get_xml_string()","ccmdcdatastream#identifier()","ccmdcdatastream#identifier=()","testcontroller#index()","testcontroller#items()","ccmdcdatastream#languages()","applicationcontroller#layout_name()","collectioncontroller#link_collection()","collectioncontroller#link_item()","collectioncontroller#list()","entitycontroller#list()","itemcontroller#list()","applicationcontroller#max_records()","cwrccollection#name()","cwrccollection#name=()","ccmbase::new()","cwrccollection::new()","cwrccollection#owner()","cwrccollection#owner=()","ccmdcdatastream#publishers()","ccmdcdatastream#remove_contributor()","ccmdatastreammethods#remove_element()","ccmbase#remove_from_collection()","itemcontroller#remove_from_collection()","ccmdcdatastream#remove_language()","ccmdcdatastream#remove_publisher()","ccmdatastreammethods#replace_xml_description()","cwrcdatastream#replace_xml_description()","cwrcentity#replace_xml_description()","cwrcitem#replace_xml_description()","ccmcontentdatastream#replace_xml_element()","ccmcontentdatastream#replace_xml_string()","ccmdcdatastream#rights()","cwrccollection#rights()","ccmdcdatastream#rights=()","cwrccollection#rights=()","ccmbase#save()","collectioncontroller#save()","entitycontroller#save()","itemcontroller#save()","ccmdatastreammethods#set_text()","collectioncontroller#show()","entitycontroller#show()","itemcontroller#show()","applicationhelper#show_item_url()","testcontroller#test()","ccmdcdatastream#title()","ccmdcdatastream#title=()","user#to_s()","cwrcentity#to_solr()","ccmbase#type()","ccmdcdatastream#type()","ccmbase#type=()","ccmdcdatastream#type=()","collectioncontroller#unlink_collection()","collectioncontroller#unlink_item()","applicationcontroller#workflow_engine_new_stamp_notification_api_url()","testcontroller#workflow_stamps()","ccmcontentdatastream::xml_template()","ccmdcdatastream::xml_template()","cwrcdatastream::xml_template()",""]}}