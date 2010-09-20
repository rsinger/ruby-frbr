require File.dirname(__FILE__) + '/../lib/frbr'

describe "A FRBR Object" do
  it "should also be a Group 3 entity" do
    object = Object.new
    object.extend(FRBR::Object)
    object.should be_kind_of(FRBR::Group3)
  end
  
  it "cannot also be another entity type" do
    object = Object.new
    object.extend(FRBR::Object)
    [FRBR::Expression, FRBR::Expression, FRBR::Manifestation, FRBR::Item].each do |wemi|
      lambda { object.extend(wemi) }.should raise_exception
    end
    
    [FRBR::Person, FRBR::CorporateBody, FRBR::Family].each do |agent|
      lambda { object.extend(agent) }.should raise_exception
    end
    
    [FRBR::Concept, FRBR::Event, FRBR::Place].each do |subject|
      lambda { object.extend(subject) }.should raise_exception
    end
  end
end