require File.dirname(__FILE__) + '/../lib/frbr'

describe "A FRBR Item" do
  it "should also be a Group 1 entity" do
    item = Object.new
    item.extend(FRBR::Item)
    item.should be_kind_of(FRBR::Group1)
  end
  
  it "can also be a Group 3 entity" do
    item = Object.new
    item.extend(FRBR::Item)
    lambda { item.extend(FRBR::Group3) }.should_not raise_exception
  end
  
  it "cannot also be a Group 2 entity" do
    item = Object.new
    item.extend(FRBR::Item)
    lambda { item.extend(FRBR::Group2) }.should raise_exception
  end
  
  it "cannot also be another entity type" do
    item = Object.new
    item.extend(FRBR::Item)
    [FRBR::Work, FRBR::Expression, FRBR::Manifestation].each do |wem|
      lambda { item.extend(wem) }.should raise_exception
    end
    
    [FRBR::Person, FRBR::CorporateBody, FRBR::Family].each do |agent|
      lambda { item.extend(agent) }.should raise_exception
    end
    
    [FRBR::Concept, FRBR::Event, FRBR::Object, FRBR::Place].each do |subject|
      lambda { item.extend(subject) }.should raise_exception
    end
  end
  
  it "can only have been owned by a Group 2 entity" do
    item = Object.new
    item.extend(FRBR::Item)
    actor = Object.new
    actor.extend(FRBR::Group2)    
    lambda { item.add_owner(actor) }.should_not raise_exception
    lambda { item.add_owner(Object.new) }.should raise_exception    
  end
  
  it "should be able to have zero or more owners" do
    item = Object.new
    item.extend(FRBR::Item)
    item.owners.should be_nil
    person = Object.new
    person.extend(FRBR::Person)
    item.add_owner(person)
    item.has_owner?(person).should be_true
    item.owners.length.should ==(1)
    group = Object.new
    group.extend(FRBR::CorporateBody)
    item.add_owner(group)
    item.has_owner?(group).should be_true
    item.has_owner?(person).should be_true
    item.owners.length.should ==(2)    
  end    
  
  it "should reify the relationship between item and owner" do
    item = Object.new
    item.extend(FRBR::Item)
    person = Object.new
    person.extend(FRBR::Person)
    item.add_owner(person)    
    person.owner_of?(item).should be_true
  end
    
  it "should be able to remove owners" do
    item = Object.new
    item.extend(FRBR::Item)
    person = Object.new
    person.extend(FRBR::Person)
    item.add_owner(person)
    item.has_owner?(person).should be_true
    item.remove_owner(person)
    item.has_owner?(person).should be_false    
  end
  
  it "should remove the relationship on the owner when owner is removed" do
    item = Object.new
    item.extend(FRBR::Item)
    person = Object.new
    person.extend(FRBR::Person)
    item.add_owner(person)
    person.owner_of?(item).should be_true
    item.remove_owner(person)
    person.owner_of?(item).should be_false   
  end
  
  it "should be the exemplar of zero or one manifestation" do
    item = Object.new
    item.extend(FRBR::Item)
    manifestation = Object.new
    manifestation.extend(FRBR::Manifestation)
    item.exemplar_of.should be_nil
    item.is_exemplar_of(manifestation)
    item.exemplar_of.should ==(manifestation)    
  end
  
  it "should reify the realization with the manifestation" do
    item = Object.new
    item.extend(FRBR::Item)
    manifestation = Object.new()
    manifestation.extend(FRBR::Manifestation)
    manifestation.exemplars.should be_nil
    item.is_exemplar_of(manifestation)
    manifestation.exemplars.should include(item)
  end
  
  it "should be able to clear the relationship with the manifestation" do
    item = Object.new
    item.extend(FRBR::Item)
    manifestation = Object.new()
    manifestation.extend(FRBR::Manifestation)
    item.is_exemplar_of(manifestation)
    item.exemplar_of.should ==(manifestation)    
    item.clear_exemplar_of
    item.exemplar_of.should be_nil
  end  
  
  it "should be able to remove the relationship from the manifestation when cleared" do
    item = Object.new
    item.extend(FRBR::Item)
    manifestation = Object.new()
    manifestation.extend(FRBR::Manifestation)
    item.is_exemplar_of(manifestation)
    manifestation.exemplars.should include(item) 
    item.clear_exemplar_of
    manifestation.exemplars.should_not include(item)
  end
      
  it "should only allow manifestations to be added as exemplar_of" do
    item = Object.new
    item.extend(FRBR::Item)
    item.exemplar_of.should be_nil 
    work = Object.new
    work.extend(FRBR::Work)    
    lambda { item.is_exemplar_of(work) }.should raise_exception(ArgumentError)    
  end
  
  it "should allow other items to be related to it" do
    item = Object.new
    item.extend(FRBR::Item)
    related_item = Object.new
    related_item.extend(FRBR::Item)
    item.add_related(related_item)
    item.related.should include(related_item)
  end
  
  it "should allow different kinds of relationships" do
    item = Object.new
    item.extend(FRBR::Item)
    related_item = Object.new
    related_item.extend(FRBR::Item)
    item.add_reconfiguration(related_item)    
    item.reconfiguration.should include(related_item)
  end
  
  it "should only allow items to be related to it" do
    item = Object.new
    item.extend(FRBR::Item)
    expression = Object.new
    expression.extend(FRBR::Expression)
    lambda { item.add_related(expression) }.should raise_exception
  end
  
  it "should add the inverse relationship to the related object" do
    item = Object.new
    item.extend(FRBR::Item)
    related_item = Object.new
    related_item.extend(FRBR::Item)
    item.add_reconfiguration(related_item)    
    related_item.reconfiguration_of.should include(item)    
  end
  
  it "should be able to remove the related item" do
    item = Object.new
    item.extend(FRBR::Item)
    related_item = Object.new
    related_item.extend(FRBR::Item)
    item.add_related(related_item)
    item.related.should include(related_item)
    item.remove_related(related_item)    
    item.related.should_not include(related_item)    
    item.add_reconfiguration(related_item)
    item.reconfiguration.should include(related_item)
    item.remove_reconfiguration(related_item)    
    item.reconfiguration.should_not include(related_item)
  end
  
  it "should remove the inverse relationship from the related item when it is removed" do
    item = Object.new
    item.extend(FRBR::Item)
    related_item = Object.new
    related_item.extend(FRBR::Item)
    item.add_related(related_item)
    related_item.related.should include(item)
    item.remove_related(related_item)    
    related_item.related.should_not include(item)    
    item.add_reconfiguration(related_item)
    related_item.reconfiguration_of.should include(item)
    item.remove_reconfiguration(related_item)    
    related_item.reconfiguration_of.should_not include(item)
  end
        
end