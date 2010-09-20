require File.dirname(__FILE__) + '/../lib/frbr'

describe "A FRBR CorporateBody" do
  it "should also be a Group 2 entity" do
    corp_body = Object.new
    corp_body.extend(FRBR::CorporateBody)
    corp_body.should be_kind_of(FRBR::Group2)
  end
  
  it "can also be a Group 3 entity" do
    corp_body = Object.new
    corp_body.extend(FRBR::CorporateBody)
    lambda { corp_body.extend(FRBR::Group3) }.should_not raise_exception
  end
  
  it "cannot also be a Group 1 entity" do
    corp_body = Object.new
    corp_body.extend(FRBR::CorporateBody)
    lambda { corp_body.extend(FRBR::Group1) }.should raise_exception
  end
  
  it "cannot also be another entity type" do
    corp_body = Object.new
    corp_body.extend(FRBR::CorporateBody)
    [FRBR::Work, FRBR::Expression, FRBR::Manifestation, FRBR::Item].each do |wemi|
      lambda { corp_body.extend(wemi) }.should raise_exception
    end
    
    [FRBR::Person, FRBR::Family].each do |agent|
      lambda { corp_body.extend(agent) }.should raise_exception
    end
    
    [FRBR::Concept, FRBR::Event, FRBR::Object, FRBR::Place].each do |subject|
      lambda { corp_body.extend(subject) }.should raise_exception
    end
  end
end