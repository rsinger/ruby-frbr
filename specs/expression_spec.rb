require File.dirname(__FILE__) + '/../lib/frbr'

describe "A FRBR Expression" do
  it "should also be a Group 1 entity" do
    expression = Object.new
    expression.extend(FRBR::Expression)
    expression.should be_kind_of(FRBR::Group1)
  end
  
  it "can also be a Group 3 entity" do
    expression = Object.new
    expression.extend(FRBR::Expression)
    lambda { expression.extend(FRBR::Group3) }.should_not raise_exception
  end
  
  it "cannot also be a Group 2 entity" do
    expression = Object.new
    expression.extend(FRBR::Expression)
    lambda { expression.extend(FRBR::Group2) }.should raise_exception
  end
  
  it "cannot also be another entity type" do
    expression = Object.new
    expression.extend(FRBR::Expression)
    [FRBR::Work, FRBR::Manifestation, FRBR::Item].each do |wmi|
      lambda { expression.extend(wmi) }.should raise_exception
    end
    
    [FRBR::Person, FRBR::CorporateBody, FRBR::Family].each do |agent|
      lambda { expression.extend(agent) }.should raise_exception
    end
    
    [FRBR::Concept, FRBR::Event, FRBR::Object, FRBR::Place].each do |subject|
      lambda { expression.extend(subject) }.should raise_exception
    end
  end
  
  it "can only have been realized by a Group 2 entity" do
    expression = Object.new
    expression.extend(FRBR::Expression)
    actor = Object.new
    actor.extend(FRBR::Group2)    
    lambda { expression.add_realizer(actor) }.should_not raise_exception
    lambda { expression.add_realizer(Object.new) }.should raise_exception    
  end
  
  it "should be able to have zero or more realizer" do
    expression = Object.new
    expression.extend(FRBR::Expression)
    expression.realizers.should be_nil
    person = Object.new
    person.extend(FRBR::Person)
    expression.add_realizer(person)
    expression.has_realizer?(person).should be_true
    expression.realizers.length.should ==(1)
    group = Object.new
    group.extend(FRBR::CorporateBody)
    expression.add_realizer(group)
    expression.has_realizer?(group).should be_true
    expression.has_realizer?(person).should be_true
    expression.realizers.length.should ==(2)    
  end    
  
  it "should reify the relationship between expression and realizer" do
    expression = Object.new
    expression.extend(FRBR::Expression)
    person = Object.new
    person.extend(FRBR::Person)
    expression.add_realizer(person)    
    person.realizer_of?(expression).should be_true
  end
    
  it "should be able to remove realizers" do
    expression = Object.new
    expression.extend(FRBR::Expression)
    person = Object.new
    person.extend(FRBR::Person)
    expression.add_realizer(person)
    expression.has_realizer?(person).should be_true
    expression.remove_realizer(person)
    expression.has_realizer?(person).should be_false    
  end
  
  it "should remove the relationship on the realizer when realizer is removed" do
    expression = Object.new
    expression.extend(FRBR::Expression)
    person = Object.new
    person.extend(FRBR::Person)
    expression.add_realizer(person)
    person.realizer_of?(expression).should be_true
    expression.remove_realizer(person)
    person.realizer_of?(expression).should be_false   
  end
  
  it "should be the realization of zero or one work" do
    expression = Object.new
    expression.extend(FRBR::Expression)
    work = Object.new
    work.extend(FRBR::Work)
    expression.realization_of.should be_nil
    expression.is_realization_of(work)
    expression.realization_of.should ==(work)    
  end
  
  it "should reify the realization with the work" do
    expression = Object.new
    expression.extend(FRBR::Expression)
    work = Object.new()
    work.extend(FRBR::Work)
    work.realizations.should be_nil
    expression.is_realization_of(work)
    work.realizations.should include(expression)
  end
  
  it "should be able to clear the relationship with the work" do
    expression = Object.new
    expression.extend(FRBR::Expression)
    work = Object.new()
    work.extend(FRBR::Work)
    expression.is_realization_of(work)
    expression.realization_of.should ==(work)    
    expression.clear_realization_of
    expression.realization_of.should be_nil
  end  
  
  it "should be able to remove the relationship from the work when cleared" do
    expression = Object.new
    expression.extend(FRBR::Expression)
    work = Object.new()
    work.extend(FRBR::Work)
    expression.is_realization_of(work)
    work.realizations.should include(expression) 
    expression.clear_realization_of
    work.realizations.should_not include(expression)
  end
    
  it "should be able to have zero or more manifestations" do
    expression = Object.new
    expression.extend(FRBR::Expression)
    expression.embodiments.should be_nil 
    manifestation1 = Object.new
    manifestation1.extend(FRBR::Manifestation)   
    expression.add_embodiment(manifestation1)
    expression.embodiments.length.should == 1
    expression.embodiments.index(manifestation1).should_not be_nil
    manifestation2 = Object.new
    manifestation2.extend(FRBR::Manifestation)   
    expression.add_embodiment(manifestation2)
    expression.embodiments.length.should == 2   
    expression.embodiments.index(manifestation1).should_not be_nil
    expression.embodiments.index(manifestation2).should_not be_nil
  end
  
  it "should reify the relationship on an added manifestation" do
    expression = Object.new
    expression.extend(FRBR::Expression)
    expression.embodiments.should be_nil 
    manifestation = Object.new
    manifestation.extend(FRBR::Manifestation)   
    expression.add_embodiment(manifestation)    
    manifestation.embodiment_of.should ==(expression)
  end
  
  it "should be able to remove a manifestation" do
    expression = Object.new
    expression.extend(FRBR::Expression)
    expression.embodiments.should be_nil 
    manifestation = Object.new
    manifestation.extend(FRBR::Manifestation)   
    expression.add_embodiment(manifestation)
    expression.embodiments.should include(manifestation)
    expression.remove_embodiment(manifestation)    
    expression.embodiments.length.should ==(0)
  end
  
  it "should remove the relationship from the manifestation when it is removed from the expression" do
    expression = Object.new
    expression.extend(FRBR::Expression)
    expression.embodiments.should be_nil 
    manifestation = Object.new
    manifestation.extend(FRBR::Manifestation)   
    expression.add_embodiment(manifestation)    
    manifestation.embodiment_of.should ==(expression)
    expression.remove_embodiment(manifestation)    
    manifestation.embodiment_of.should be_nil
  end
  
  it "should only allow manifestations to be added as embodiments" do
    expression = Object.new
    expression.extend(FRBR::Expression)
    expression.embodiments.should be_nil 
    item = Object.new
    item.extend(FRBR::Item)    
    lambda { expression.add_embodiment(item) }.should raise_exception(ArgumentError)
  end
  
  it "should only allow works to be added as realizations_of" do
    expression = Object.new
    expression.extend(FRBR::Expression)
    expression.realization_of.should be_nil 
    item = Object.new
    item.extend(FRBR::Item)    
    lambda { expression.is_realization_of(item) }.should raise_exception(ArgumentError)    
  end
  
  it "should allow other expressions to be related to it" do
    expression = Object.new
    expression.extend(FRBR::Expression)
    related_expression = Object.new
    related_expression.extend(FRBR::Expression)
    expression.add_related(related_expression)
    expression.related.should include(related_expression)
  end
  
  it "should allow different kinds of relationships" do
    expression = Object.new
    expression.extend(FRBR::Expression)
    related_expression = Object.new
    related_expression.extend(FRBR::Expression)
    expression.add_adaptation(related_expression)    
    expression.adaptation.should include(related_expression)
  end
  
  it "should only allow expressions to be related to it" do
    expression = Object.new
    expression.extend(FRBR::Expression)
    item = Object.new
    item.extend(FRBR::Item)
    lambda { expression.add_related(item) }.should raise_exception
  end
  
  it "should add the inverse relationship to the related object" do
    expression = Object.new
    expression.extend(FRBR::Expression)
    related_expression = Object.new
    related_expression.extend(FRBR::Expression)
    expression.add_adaptation(related_expression)    
    related_expression.adaptation_of.should include(expression)    
  end
  
  it "should be able to remove the related expression" do
    expression = Object.new
    expression.extend(FRBR::Expression)
    related_expression = Object.new
    related_expression.extend(FRBR::Expression)
    expression.add_related(related_expression)
    expression.related.should include(related_expression)
    expression.remove_related(related_expression)    
    expression.related.should_not include(related_expression)    
    expression.add_adaptation(related_expression)
    expression.adaptation.should include(related_expression)
    expression.remove_adaptation(related_expression)    
    expression.adaptation.should_not include(related_expression)
  end
  
  it "should remove the inverse relationship from the related expression when it is removed" do
    expression = Object.new
    expression.extend(FRBR::Expression)
    related_expression = Object.new
    related_expression.extend(FRBR::Expression)
    expression.add_related(related_expression)
    related_expression.related.should include(expression)
    expression.remove_related(related_expression)    
    related_expression.related.should_not include(expression)    
    expression.add_adaptation(related_expression)
    related_expression.adaptation_of.should include(expression)
    expression.remove_adaptation(related_expression)    
    related_expression.adaptation_of.should_not include(expression)
  end
        
end