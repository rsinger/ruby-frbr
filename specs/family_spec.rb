require File.dirname(__FILE__) + '/../lib/frbr'

describe "A FRBR Family" do
  it "should also be a Group 2 entity" do
    family = Object.new
    family.extend(FRBR::Family)
    family.should be_kind_of(FRBR::Group2)
  end
  
  it "can also be a Group 3 entity" do
    family = Object.new
    family.extend(FRBR::Family)
    lambda { family.extend(FRBR::Group3) }.should_not raise_exception
  end
  
  it "cannot also be a Group 1 entity" do
    family = Object.new
    family.extend(FRBR::Family)
    lambda { family.extend(FRBR::Group1) }.should raise_exception
  end
  
  it "cannot also be another entity type" do
    family = Object.new
    family.extend(FRBR::Family)
    [FRBR::Work, FRBR::Expression, FRBR::Manifestation, FRBR::Item].each do |wemi|
      lambda { family.extend(wemi) }.should raise_exception
    end
    
    [FRBR::Person, FRBR::CorporateBody].each do |agent|
      lambda { family.extend(agent) }.should raise_exception
    end
    
    [FRBR::Concept, FRBR::Event, FRBR::Object, FRBR::Place].each do |subject|
      lambda { family.extend(subject) }.should raise_exception
    end
  end
end