require File.dirname(__FILE__) + '/../lib/frbr'

describe "A FRBR Manifestation" do
  it "should also be a Group 1 entity" do
    manifestation = Object.new
    manifestation.extend(FRBR::Manifestation)
    manifestation.should be_kind_of(FRBR::Group1)
  end
  
  it "can also be a Group 3 entity" do
    manifestation = Object.new
    manifestation.extend(FRBR::Manifestation)
    lambda { manifestation.extend(FRBR::Group3) }.should_not raise_exception
  end
  
  it "cannot also be a Group 2 entity" do
    manifestation = Object.new
    manifestation.extend(FRBR::Manifestation)
    lambda { manifestation.extend(FRBR::Group2) }.should raise_exception
  end
  
  it "cannot also be another entity type" do
    manifestation = Object.new
    manifestation.extend(FRBR::Manifestation)
    [FRBR::Expression, FRBR::Expression, FRBR::Item].each do |wei|
      lambda { manifestation.extend(wei) }.should raise_exception
    end
    
    [FRBR::Person, FRBR::CorporateBody, FRBR::Family].each do |agent|
      lambda { manifestation.extend(agent) }.should raise_exception
    end
    
    [FRBR::Concept, FRBR::Event, FRBR::Object, FRBR::Place].each do |subject|
      lambda { manifestation.extend(subject) }.should raise_exception
    end
  end
  
  it "can only have been realized by a Group 2 entity" do
    manifestation = Object.new
    manifestation.extend(FRBR::Manifestation)
    actor = Object.new
    actor.extend(FRBR::Group2)    
    lambda { manifestation.add_producer(actor) }.should_not raise_exception
    lambda { manifestation.add_producer(Object.new) }.should raise_exception    
  end
  
  it "should be able to have zero or more producer" do
    manifestation = Object.new
    manifestation.extend(FRBR::Manifestation)
    manifestation.producers.should be_nil
    person = Object.new
    person.extend(FRBR::Person)
    manifestation.add_producer(person)
    manifestation.has_producer?(person).should be_true
    manifestation.producers.length.should ==(1)
    group = Object.new
    group.extend(FRBR::CorporateBody)
    manifestation.add_producer(group)
    manifestation.has_producer?(group).should be_true
    manifestation.has_producer?(person).should be_true
    manifestation.producers.length.should ==(2)    
  end    
  
  it "should reify the relationship between manifestation and producer" do
    manifestation = Object.new
    manifestation.extend(FRBR::Manifestation)
    person = Object.new
    person.extend(FRBR::Person)
    manifestation.add_producer(person)    
    person.producer_of?(manifestation).should be_true
  end
    
  it "should be able to remove producers" do
    manifestation = Object.new
    manifestation.extend(FRBR::Manifestation)
    person = Object.new
    person.extend(FRBR::Person)
    manifestation.add_producer(person)
    manifestation.has_producer?(person).should be_true
    manifestation.remove_producer(person)
    manifestation.has_producer?(person).should be_false    
  end
  
  it "should remove the relationship on the producer when producer is removed" do
    manifestation = Object.new
    manifestation.extend(FRBR::Manifestation)
    person = Object.new
    person.extend(FRBR::Person)
    manifestation.add_producer(person)
    person.producer_of?(manifestation).should be_true
    manifestation.remove_producer(person)
    person.producer_of?(manifestation).should be_false   
  end
  
  it "should be the embodiment of zero or one expression" do
    manifestation = Object.new
    manifestation.extend(FRBR::Manifestation)
    expression = Object.new
    expression.extend(FRBR::Expression)
    manifestation.embodiment_of.should be_nil
    manifestation.is_embodiment_of(expression)
    manifestation.embodiment_of.should ==(expression)    
  end
  
  it "should reify the production with the expression" do
    manifestation = Object.new
    manifestation.extend(FRBR::Manifestation)
    expression = Object.new()
    expression.extend(FRBR::Expression)
    expression.embodiments.should be_nil
    manifestation.is_embodiment_of(expression)
    expression.embodiments.should include(manifestation)
  end
  
  it "should be able to clear the relationship with the expression" do
    manifestation = Object.new
    manifestation.extend(FRBR::Manifestation)
    expression = Object.new()
    expression.extend(FRBR::Expression)
    manifestation.is_embodiment_of(expression)
    manifestation.embodiment_of.should ==(expression)    
    manifestation.clear_embodiment_of
    manifestation.embodiment_of.should be_nil
  end  
  
  it "should be able to remove the relationship from the expression when cleared" do
    manifestation = Object.new
    manifestation.extend(FRBR::Manifestation)
    expression = Object.new()
    expression.extend(FRBR::Expression)
    manifestation.is_embodiment_of(expression)
    expression.embodiments.should include(manifestation) 
    manifestation.clear_embodiment_of
    expression.embodiments.should_not include(manifestation)
  end
    
  it "should be able to have zero or more items" do
    manifestation = Object.new
    manifestation.extend(FRBR::Manifestation)
    manifestation.exemplars.should be_nil 
    item1 = Object.new
    item1.extend(FRBR::Item)   
    manifestation.add_exemplar(item1)
    manifestation.exemplars.length.should == 1
    manifestation.exemplars.index(item1).should_not be_nil
    item2 = Object.new
    item2.extend(FRBR::Item)   
    manifestation.add_exemplar(item2)
    manifestation.exemplars.length.should == 2   
    manifestation.exemplars.index(item1).should_not be_nil
    manifestation.exemplars.index(item2).should_not be_nil
  end
  
  it "should reify the relationship on an added item" do
    manifestation = Object.new
    manifestation.extend(FRBR::Manifestation)
    manifestation.exemplars.should be_nil 
    item = Object.new
    item.extend(FRBR::Item)   
    manifestation.add_exemplar(item)    
    item.exemplar_of.should ==(manifestation)
  end
  
  it "should be able to remove an item" do
    manifestation = Object.new
    manifestation.extend(FRBR::Manifestation)
    manifestation.exemplars.should be_nil 
    item = Object.new
    item.extend(FRBR::Item)   
    manifestation.add_exemplar(item)
    manifestation.exemplars.should include(item)
    manifestation.remove_exemplar(item)    
    manifestation.exemplars.length.should ==(0)
  end
  
  it "should remove the relationship from the item when it is removed from the manifestation" do
    manifestation = Object.new
    manifestation.extend(FRBR::Manifestation)
    manifestation.exemplars.should be_nil 
    item = Object.new
    item.extend(FRBR::Item)   
    manifestation.add_exemplar(item)    
    item.exemplar_of.should ==(manifestation)
    manifestation.remove_exemplar(item)    
    item.exemplar_of.should be_nil
  end
  
  it "should only allow items to be added as exemplars" do
    manifestation = Object.new
    manifestation.extend(FRBR::Manifestation)
    manifestation.exemplars.should be_nil 
    expression = Object.new
    expression.extend(FRBR::Expression)    
    lambda { manifestation.add_exemplar(expression) }.should raise_exception(ArgumentError)
  end
  
  it "should only allow expressions to be added as embodiment_of" do
    manifestation = Object.new
    manifestation.extend(FRBR::Manifestation)
    manifestation.embodiment_of.should be_nil 
    item = Object.new
    item.extend(FRBR::Item)    
    lambda { manifestation.is_embodiment_of(item) }.should raise_exception(ArgumentError)    
  end
  
  it "should allow other manifestations to be related to it" do
    manifestation = Object.new
    manifestation.extend(FRBR::Manifestation)
    related_manifestation = Object.new
    related_manifestation.extend(FRBR::Manifestation)
    manifestation.add_related(related_manifestation)
    manifestation.related.should include(related_manifestation)
  end
  
  it "should allow different kinds of relationships" do
    manifestation = Object.new
    manifestation.extend(FRBR::Manifestation)
    related_manifestation = Object.new
    related_manifestation.extend(FRBR::Manifestation)
    manifestation.add_reproduction(related_manifestation)    
    manifestation.reproduction.should include(related_manifestation)
  end
  
  it "should only allow manifestations to be related to it" do
    manifestation = Object.new
    manifestation.extend(FRBR::Manifestation)
    item = Object.new
    item.extend(FRBR::Item)
    lambda { manifestation.add_related(item) }.should raise_exception
  end
  
  it "should add the inverse relationship to the related object" do
    manifestation = Object.new
    manifestation.extend(FRBR::Manifestation)
    related_manifestation = Object.new
    related_manifestation.extend(FRBR::Manifestation)
    manifestation.add_reproduction(related_manifestation)    
    related_manifestation.reproduction_of.should include(manifestation)    
  end
  
  it "should be able to remove the related manifestation" do
    manifestation = Object.new
    manifestation.extend(FRBR::Manifestation)
    related_manifestation = Object.new
    related_manifestation.extend(FRBR::Manifestation)
    manifestation.add_related(related_manifestation)
    manifestation.related.should include(related_manifestation)
    manifestation.remove_related(related_manifestation)    
    manifestation.related.should_not include(related_manifestation)    
    manifestation.add_reproduction(related_manifestation)
    manifestation.reproduction.should include(related_manifestation)
    manifestation.remove_reproduction(related_manifestation)    
    manifestation.reproduction.should_not include(related_manifestation)
  end
  
  it "should remove the inverse relationship from the related manifestation when it is removed" do
    manifestation = Object.new
    manifestation.extend(FRBR::Manifestation)
    related_manifestation = Object.new
    related_manifestation.extend(FRBR::Manifestation)
    manifestation.add_related(related_manifestation)
    related_manifestation.related.should include(manifestation)
    manifestation.remove_related(related_manifestation)    
    related_manifestation.related.should_not include(manifestation)    
    manifestation.add_reproduction(related_manifestation)
    related_manifestation.reproduction_of.should include(manifestation)
    manifestation.remove_reproduction(related_manifestation)    
    related_manifestation.reproduction_of.should_not include(manifestation)
  end
        
end