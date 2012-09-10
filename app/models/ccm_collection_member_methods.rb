
module CcmCollectionMemberMethods

  # Adds this collection to a set of parent collections
  #
  # <b> Params: </b>
  # * parentCollectionIDs: an array of parent collection IDs
  def add_to_collection(parentCollectionIDs)
    self.save unless self.new_object? ##Item should have a valid pid in order to add it to the collection using hasCollectionMember predicate
    
    parentCollectionIDs.each do |id|
      c = CwrcCollection.find(id.strip)
      
      self.add_relationship(:is_member_of_collection, c)
      
      c.add_relationship(:has_collection_member, self)
      c.save
    end
    self.save
  end
 
  # Removes this collection from parent collections
  #
  # <b> Params: </b>
  # * parentCollectionIDs: an array of parent collection IDs
  def remove_from_collection(parentCollectionIDs)
    parentCollectionIDs.each do |id|
      c = CwrcCollection.find(id.strip)
      
      self.remove_relationship(:is_member_of_collection, c)
      
      c.remove_relationship(:has_collection_member, self)
      c.save
    end
    self.save
  end
 
end