#!/bin/bash

for i in {1..10}
do
   echo "Iteration $i ..."
   rspec spec/api_unit_tests/collection_spec.rb -e "creates one new collection" 
   rspec spec/api_unit_tests/item_spec.rb -e "creates one new item"
   rspec spec/api_unit_tests/entity_spec.rb -e "creates one new entity"
done

echo "Test data initialization completed."