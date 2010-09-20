require File.dirname(__FILE__) + '/../lib/frbr'

describe "A FRBR Place" do
  it "should also be a Group 3 entity" do
    place = Object.new
    place.extend(FRBR::Place)
    place.should be_kind_of(FRBR::Group3)
  end
  
  it "cannot also be another entity type" do
    place = Object.new
    place.extend(FRBR::Place)
    [FRBR::Expression, FRBR::Expression, FRBR::Manifestation, FRBR::Item].each do |wemi|
      lambda { place.extend(wemi) }.should raise_exception
    end
    
    [FRBR::Person, FRBR::CorporateBody, FRBR::Family].each do |agent|
      lambda { place.extend(agent) }.should raise_exception
    end
    
    [FRBR::Concept, FRBR::Object, FRBR::Event].each do |subject|
      lambda { place.extend(subject) }.should raise_exception
    end
  end
end