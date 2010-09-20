require File.dirname(__FILE__) + '/../lib/frbr'

describe "A FRBR Concept" do
  it "should also be a Group 3 entity" do
    concept = Object.new
    concept.extend(FRBR::Concept)
    concept.should be_kind_of(FRBR::Group3)
  end
  
  it "cannot also be another entity type" do
    concept = Object.new
    concept.extend(FRBR::Concept)
    [FRBR::Expression, FRBR::Expression, FRBR::Manifestation, FRBR::Item].each do |wemi|
      lambda { concept.extend(wemi) }.should raise_exception
    end
    
    [FRBR::Person, FRBR::CorporateBody, FRBR::Family].each do |agent|
      lambda { concept.extend(agent) }.should raise_exception
    end
    
    [FRBR::Event, FRBR::Object, FRBR::Place].each do |subject|
      lambda { concept.extend(subject) }.should raise_exception
    end
  end
end  