require File.dirname(__FILE__) + '/../lib/frbr'

describe "FRBR Group 1 entities" do
  it "should only be works, expressions, manifestations or items" do
    w = Object.new
    w.extend(FRBR::Work)
    w.should be_kind_of(FRBR::Group1)
    e = Object.new
    e.extend(FRBR::Expression)
    e.should be_kind_of(FRBR::Group1)
    m = Object.new
    m.extend(FRBR::Manifestation)
    m.should be_kind_of(FRBR::Group1)
    i = Object.new
    i.extend(FRBR::Item)
    i.should be_kind_of(FRBR::Group1)
    cb = Object.new
    cb.extend(FRBR::CorporateBody)
    cb.should_not be_kind_of(FRBR::Group1)
    lambda { cb.extend(FRBR::Group1) }.should raise_exception()    
    p = Object.new
    p.extend(FRBR::Person)
    p.should_not be_kind_of(FRBR::Group1)
    lambda { p.extend(FRBR::Group1) }.should raise_exception()    
    f = Object.new
    f.extend(FRBR::Family)
    f.should_not be_kind_of(FRBR::Group1)
    lambda { f.extend(FRBR::Group1) }.should raise_exception()    
    
    o = Object.new
    o.extend(FRBR::Object)
    o.should_not be_kind_of(FRBR::Group1)
    lambda { o.extend(FRBR::Group1) }.should raise_exception()    
    
    c = Object.new
    c.extend(FRBR::Concept)
    c.should_not be_kind_of(FRBR::Group1)
    lambda { c.extend(FRBR::Group1) }.should raise_exception()    
    
    ev = Object.new
    ev.extend(FRBR::Event)
    ev.should_not be_kind_of(FRBR::Group1)    
    lambda { ev.extend(FRBR::Group1) }.should raise_exception()    
    
    pl = Object.new
    pl.extend(FRBR::Place)
    pl.should_not be_kind_of(FRBR::Group1)
    lambda { pl.extend(FRBR::Group1) }.should raise_exception()    
  end
  
  it "can not also be Group 2 entities" do
    w = Object.new
    w.extend(FRBR::Work)
    lambda { w.extend(FRBR::Group2) }.should raise_exception()

    e = Object.new
    e.extend(FRBR::Expression)
    lambda { e.extend(FRBR::Group2) }.should raise_exception()
    
    m = Object.new
    m.extend(FRBR::Manifestation)
    lambda { m.extend(FRBR::Group2) }.should raise_exception()
    
    i = Object.new
    i.extend(FRBR::Item)
    lambda { i.extend(FRBR::Group2) }.should raise_exception()
  end
  
  it "can also be Group 3 entities" do
    w = Object.new
    w.extend(FRBR::Work)
    lambda { w.extend(FRBR::Group3) }.should_not raise_exception

    e = Object.new
    e.extend(FRBR::Expression)
    lambda { e.extend(FRBR::Group3) }.should_not raise_exception
    
    m = Object.new
    m.extend(FRBR::Manifestation)
    lambda { m.extend(FRBR::Group3) }.should_not raise_exception
    
    i = Object.new
    i.extend(FRBR::Item)
    lambda { i.extend(FRBR::Group3) }.should_not raise_exception
  end
end