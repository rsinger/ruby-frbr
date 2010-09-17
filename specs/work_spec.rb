require File.dirname(__FILE__) + '/../lib/frbr'

describe "A FRBR Work" do
  it "should also be a Group 1 entity" do
    work = Object.new
    work.extend(FRBR::Work)
    work.should be_kind_of(FRBR::Group1)
  end
  
  it "can also be a Group 3 entity" do
    work = Object.new
    work.extend(FRBR::Work)
    lambda { work.extend(FRBR::Group3) }.should_not raise_exception
  end
  
  it "cannot also be a Group 2 entity" do
    work = Object.new
    work.extend(FRBR::Work)
    lambda { work.extend(FRBR::Group2) }.should raise_exception
  end
  
  it "cannot also be another entity type" do
    work = Object.new
    work.extend(FRBR::Work)
    [FRBR::Expression, FRBR::Manifestation, FRBR::Item].each do |emi|
      lambda { work.extend(emi) }.should raise_exception
    end
    
    [FRBR::Person, FRBR::CorporateBody, FRBR::Family].each do |agent|
      lambda { work.extend(agent) }.should raise_exception
    end
    
    [FRBR::Concept, FRBR::Event, FRBR::Object, FRBR::Place].each do |subject|
      lambda { work.extend(subject) }.should raise_exception
    end
  end
  
  it "can only have been created by a Group 2 entity" do
    work = Object.new
    work.extend(FRBR::Work)
    actor = Object.new
    actor.extend(FRBR::Group2)    
    lambda { work.add_creator(actor) }.should_not raise_exception
    lambda { work.add_creator(Object.new) }.should raise_exception    
  end
  
  it "should be able to have zero or more creators" do
    work = Object.new
    work.extend(FRBR::Work)
    work.creators.should be_nil
    person = Object.new
    person.extend(FRBR::Person)
    work.add_creator(person)
    work.has_creator?(person).should be_true
    work.creators.length.should ==(1)
    group = Object.new
    group.extend(FRBR::CorporateBody)
    work.add_creator(group)
    work.has_creator?(group).should be_true
    work.has_creator?(person).should be_true
    work.creators.length.should ==(2)    
  end    
  
  it "should reify the relationship between work and creator" do
    work = Object.new
    work.extend(FRBR::Work)
    person = Object.new
    person.extend(FRBR::Person)
    work.add_creator(person)    
    person.creator_of?(work).should be_true
  end
    
  it "should be able to remove creators" do
    work = Object.new
    work.extend(FRBR::Work)
    person = Object.new
    person.extend(FRBR::Person)
    work.add_creator(person)
    work.has_creator?(person).should be_true
    work.remove_creator(person)
    work.has_creator?(person).should be_false    
  end
  
  it "should remove the relationship on the creator when creator is removed" do
    work = Object.new
    work.extend(FRBR::Work)
    person = Object.new
    person.extend(FRBR::Person)
    work.add_creator(person)
    person.creator_of?(work).should be_true
    work.remove_creator(person)
    person.creator_of?(work).should be_false   
  end
  
  it "should be able to have zero or more expressions" do
    work = Object.new
    work.extend(FRBR::Work)
    work.realizations.should be_nil 
    expression1 = Object.new
    expression1.extend(FRBR::Expression)   
    work.add_realization(expression1)
    work.realizations.length.should == 1
    work.realizations.index(expression1).should_not be_nil
    expression2 = Object.new
    expression2.extend(FRBR::Expression)   
    work.add_realization(expression2)
    work.realizations.length.should == 2   
    work.realizations.index(expression1).should_not be_nil
    work.realizations.index(expression2).should_not be_nil
  end
  
  it "should reify the relationship on an added expression" do
    work = Object.new
    work.extend(FRBR::Work)
    work.realizations.should be_nil 
    expression = Object.new
    expression.extend(FRBR::Expression)   
    work.add_realization(expression)    
    expression.realization_of.should ==(work)
  end
  
  it "should be able to remove an expression" do
    work = Object.new
    work.extend(FRBR::Work)
    work.realizations.should be_nil 
    expression = Object.new
    expression.extend(FRBR::Expression)   
    work.add_realization(expression)
    work.realizations.index(expression).should_not be_nil
    work.remove_realization(expression)    
    work.realizations.length.should ==(0)
  end
  
  it "should remove the relationship from the expression when it is removed from the work" do
    work = Object.new
    work.extend(FRBR::Work)
    work.realizations.should be_nil 
    expression = Object.new
    expression.extend(FRBR::Expression)   
    work.add_realization(expression)    
    expression.realization_of.should ==(work)
    work.remove_realization(expression)    
    expression.realization_of.should be_nil
  end
  
  it "should only allow expressions to be added as realizations" do
    work = Object.new
    work.extend(FRBR::Work)
    work.realizations.should be_nil 
    manifestation = Object.new
    manifestation.extend(FRBR::Manifestation)    
    lambda { work.add_realization(manifestation) }.should raise_exception(ArgumentError)
  end
  
  it "should allow other works to be related to it" do
    work = Object.new
    work.extend(FRBR::Work)
    related_work = Object.new
    related_work.extend(FRBR::Work)
    work.add_related(related_work)
    work.related.should include(related_work)
  end
  
  it "should allow different kinds of relationships" do
    work = Object.new
    work.extend(FRBR::Work)
    related_work = Object.new
    related_work.extend(FRBR::Work)
    work.add_adaptation(related_work)    
    work.adaptation.should include(related_work)
  end
  
  it "should only allow works to be related to it" do
    work = Object.new
    work.extend(FRBR::Work)
    item = Object.new
    item.extend(FRBR::Item)
    lambda { work.add_related(item) }.should raise_exception
  end
  
  it "should add the inverse relationship to the related object" do
    work = Object.new
    work.extend(FRBR::Work)
    related_work = Object.new
    related_work.extend(FRBR::Work)
    work.add_adaptation(related_work)    
    related_work.adaptation_of.should include(work)    
  end
  
  it "should be able to remove the related work" do
    work = Object.new
    work.extend(FRBR::Work)
    related_work = Object.new
    related_work.extend(FRBR::Work)
    work.add_related(related_work)
    work.related.should include(related_work)
    work.remove_related(related_work)    
    work.related.should_not include(related_work)    
    work.add_adaptation(related_work)
    work.adaptation.should include(related_work)
    work.remove_adaptation(related_work)    
    work.adaptation.should_not include(related_work)
  end
  
  it "should remove the inverse relationship from the related work when it is removed" do
    work = Object.new
    work.extend(FRBR::Work)
    related_work = Object.new
    related_work.extend(FRBR::Work)
    work.add_related(related_work)
    related_work.related.should include(work)
    work.remove_related(related_work)    
    related_work.related.should_not include(work)    
    work.add_adaptation(related_work)
    related_work.adaptation_of.should include(work)
    work.remove_adaptation(related_work)    
    related_work.adaptation_of.should_not include(work)
  end
        
end