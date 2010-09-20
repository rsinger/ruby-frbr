require File.dirname(__FILE__) + '/../lib/frbr'

describe "A FRBR Event" do
  it "should also be a Group 3 entity" do
    event = Object.new
    event.extend(FRBR::Event)
    event.should be_kind_of(FRBR::Group3)
  end
  
  it "cannot also be another entity type" do
    event = Object.new
    event.extend(FRBR::Event)
    [FRBR::Expression, FRBR::Expression, FRBR::Manifestation, FRBR::Item].each do |wemi|
      lambda { event.extend(wemi) }.should raise_exception
    end
    
    [FRBR::Person, FRBR::CorporateBody, FRBR::Family].each do |agent|
      lambda { event.extend(agent) }.should raise_exception
    end
    
    [FRBR::Concept, FRBR::Object, FRBR::Place].each do |subject|
      lambda { event.extend(subject) }.should raise_exception
    end
  end
end