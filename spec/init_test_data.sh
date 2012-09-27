#!/bin/bash

for i in {1..6}
do
   echo
   echo "Iteration $i ..."
   rspec spec/api_unit_tests/collection_spec.rb -e "creates one new collection" spec/api_unit_tests/item_spec.rb -e "creates one new item" spec/api_unit_tests/entity_spec.rb -e "creates one person entity" spec/api_unit_tests/entity_spec.rb -e "creates one organization entity" spec/api_unit_tests/collection_spec.rb -e "creates one new collection" spec/api_unit_tests/item_spec.rb -e "creates one new item" spec/api_unit_tests/entity_spec.rb -e "creates one new entity"
done

echo "Test data initialization completed."