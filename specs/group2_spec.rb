require File.dirname(__FILE__) + '/../lib/frbr'

describe "FRBR Group 2 entities" do
  it "should only be Corporate Bodies, Families or Persons" do
    cb = Object.new
    cb.extend(FRBR::CorporateBody)
    cb.should be_kind_of(FRBR::Group2)
    f = Object.new
    f.extend(FRBR::Family)
    f.should be_kind_of(FRBR::Group2)
    p = Object.new
    p.extend(FRBR::Person)
    p.should be_kind_of(FRBR::Group2)
    
    w = Object.new
    w.extend(FRBR::Work)
    w.should_not be_kind_of(FRBR::Group2)
    lambda { w.extend(FRBR::Group2) }.should raise_exception()        
    
    m = Object.new
    m.extend(FRBR::Manifestation)
    m.should_not be_kind_of(FRBR::Group2)
    lambda { m.extend(FRBR::Group2) }.should raise_exception()  
      
    e = Object.new
    e.extend(FRBR::Expression)
    e.should_not be_kind_of(FRBR::Group2)
    lambda { e.extend(FRBR::Group2) }.should raise_exception()    
    
    i = Object.new
    i.extend(FRBR::Item)
    i.should_not be_kind_of(FRBR::Group2)
    lambda { i.extend(FRBR::Group2) }.should raise_exception()    
    
    o = Object.new
    o.extend(FRBR::Object)
    o.should_not be_kind_of(FRBR::Group2)
    lambda { o.extend(FRBR::Group2) }.should raise_exception()    
    
    c = Object.new
    c.extend(FRBR::Concept)
    c.should_not be_kind_of(FRBR::Group2)
    lambda { c.extend(FRBR::Group2) }.should raise_exception()    
    
    ev = Object.new
    ev.extend(FRBR::Event)
    ev.should_not be_kind_of(FRBR::Group2)    
    lambda { ev.extend(FRBR::Group2) }.should raise_exception()    
    
    pl = Object.new
    pl.extend(FRBR::Place)
    pl.should_not be_kind_of(FRBR::Group2)
    lambda { pl.extend(FRBR::Group2) }.should raise_exception()    
  end
  
  it "can not also be Group 2 entities" do
    cb = Object.new
    cb.extend(FRBR::CorporateBody)
    lambda { cb.extend(FRBR::Group1) }.should raise_exception()

    f = Object.new
    f.extend(FRBR::Family)
    lambda { f.extend(FRBR::Group1) }.should raise_exception()
    
    p = Object.new
    p.extend(FRBR::Person)
    lambda { p.extend(FRBR::Group1) }.should raise_exception()
  end
  
  it "can also be Group 3 entities" do
    cb = Object.new
    cb.extend(FRBR::CorporateBody)
    lambda { cb.extend(FRBR::Group3) }.should_not raise_exception

    f = Object.new
    f.extend(FRBR::Family)
    lambda { f.extend(FRBR::Group3) }.should_not raise_exception
    
    p = Object.new
    p.extend(FRBR::Person)
    lambda { p.extend(FRBR::Group3) }.should_not raise_exception
  end
  
  it "can create works" do
    cb = Object.new
    cb.extend(FRBR::CorporateBody)
    
    w = Object.new
    w.extend(FRBR::Work)
    
    lambda { cb.add_creation(w) }.should_not raise_exception
    w.has_creator?(cb).should be_true
    cb.creator_of?(w).should be_true
  end
  
  it "can only create works" do
    f = Object.new
    f.extend(FRBR::Family)
    
    e = Object.new
    e.extend(FRBR::Expression)
    
    lambda { f.add_creation(e) }.should raise_exception(ArgumentError)    
  end
  
  it "can realize expressions" do
    p = Object.new
    p.extend(FRBR::Person)
    
    e = Object.new
    e.extend(FRBR::Expression)
    
    lambda { p.add_realization(e) }.should_not raise_exception
    e.has_realizer?(p).should be_true
    p.realizer_of?(e).should be_true
  end  
  
  it "can only realize expressions" do
    cb = Object.new
    cb.extend(FRBR::CorporateBody)
    
    m = Object.new
    m.extend(FRBR::Manifestation)
    
    lambda { cb.add_realization(m) }.should raise_exception(ArgumentError)    
  end  
  
  it "can produce manifestations" do
    f = Object.new
    f.extend(FRBR::Family)
    
    m = Object.new
    m.extend(FRBR::Manifestation)
    
    lambda { f.add_production(m) }.should_not raise_exception
    m.has_producer?(f).should be_true
    f.producer_of?(m).should be_true
  end  
  
  it "can only produce manifestation" do
    p = Object.new
    p.extend(FRBR::Person)
    
    i = Object.new
    i.extend(FRBR::Item)
    
    lambda { p.add_production(i) }.should raise_exception(ArgumentError)    
  end  
  
  it "can own items" do
    cb = Object.new
    cb.extend(FRBR::CorporateBody)
    
    i = Object.new
    i.extend(FRBR::Item)
    
    lambda { cb.add_ownership(i) }.should_not raise_exception
    i.has_owner?(cb).should be_true
    cb.owner_of?(i).should be_true
  end
  
  it "can only own items" do
    f = Object.new
    f.extend(FRBR::Family)
    
    e = Object.new
    e.extend(FRBR::Expression)
    
    lambda { f.add_ownership(e) }.should raise_exception(ArgumentError)    
  end
  
  it "can have related Group 2 entities" do
    cb = Object.new
    cb.extend(FRBR::CorporateBody)
    
    p = Object.new
    p.extend(FRBR::Person)
    
    cb.add_related_agent(p)
    cb.related_agents.should include(p)
  end
  
  it "can only have related Group 2 entities" do
    f = Object.new
    f.extend(FRBR::Family)
    
    c = Object.new
    c.extend(FRBR::Concept)
    
    lambda { f.add_related_agent(c) }.should raise_exception(ArgumentError)   
  end  
  
  it "should reify the relationship between Group 2 entities" do 
    cb = Object.new
    cb.extend(FRBR::CorporateBody)
    
    f = Object.new
    f.extend(FRBR::Family)
    
    cb.add_related_agent(f)
    f.related_agents.should include(cb)    
  end
  
  it "should be able to remove a related agent" do
    f = Object.new
    f.extend(FRBR::Family)

    p = Object.new
    p.extend(FRBR::Person)
    
    f.add_related_agent(p)
    f.related_agents.should include(p)    
    f.remove_related_agent(p)
    f.related_agents.should_not include(p)    
  end
  
  it "should be remove the relationship from the related agent when the relationship is removed" do
    f = Object.new
    f.extend(FRBR::Family)

    cb = Object.new
    cb.extend(FRBR::CorporateBody)
    
    f.add_related_agent(cb)
    cb.related_agents.should include(f)    
    f.remove_related_agent(cb)
    cb.related_agents.should_not include(f)    
  end  
end