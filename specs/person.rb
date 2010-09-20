require File.dirname(__FILE__) + '/../lib/frbr'

describe "A FRBR Person" do
  it "should also be a Group 2 entity" do
    person = Object.new
    person.extend(FRBR::Person)
    person.should be_kind_of(FRBR::Group2)
  end
  
  it "can also be a Group 3 entity" do
    person = Object.new
    person.extend(FRBR::Person)
    lambda { person.extend(FRBR::Group3) }.should_not raise_exception
  end
  
  it "cannot also be a Group 1 entity" do
    person = Object.new
    person.extend(FRBR::Person)
    lambda { person.extend(FRBR::Group1) }.should raise_exception
  end
  
  it "cannot also be another entity type" do
    person = Object.new
    person.extend(FRBR::Person)
    [FRBR::Work, FRBR::Expression, FRBR::Manifestation, FRBR::Item].each do |wemi|
      lambda { person.extend(wemi) }.should raise_exception
    end
    
    [FRBR::CorporateBody, FRBR::Family].each do |agent|
      lambda { person.extend(agent) }.should raise_exception
    end
    
    [FRBR::Concept, FRBR::Event, FRBR::Object, FRBR::Place].each do |subject|
      lambda { person.extend(subject) }.should raise_exception
    end
  end
end