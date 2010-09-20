require File.dirname(__FILE__) + '/../lib/frbr'
include FRBR
describe "FRBR Group 3 entities" do
  it "can be any other type of FRBR entity" do
    [Group1, Group2].each do |g|
      entity = Object.new
      entity.extend(g)
      lambda { entity.extend(Group3) }.should_not raise_exception
    end
    
    [Work, Expression, Manifestation, Item].each do |wemi|
      entity = Object.new
      entity.extend(wemi)
      lambda { entity.extend(Group3) }.should_not raise_exception
    end      
    
    [CorporateBody, Family, Person].each do |agent|
      entity = Object.new
      entity.extend(agent)
      lambda { entity.extend(Group3) }.should_not raise_exception      
    end
  end
  
  it "can be the subject of a work" do
    c = Object.new
    c.extend(Concept)
    
    w = Object.new
    w.extend(Work)
    
    c.add_subject_of(w)
    
    w.subjects.should include(c)
    c.subject_of.should include(w)
    
    o = Object.new
    o.extend(FRBR::Object)
    w.add_subject(o)
    o.subject_of.should include(w)
    w.subjects.should include(c)
    w.subjects.should include(o)
  end
  
  it "can only be the subject of a work" do
    p = Object.new
    p.extend(Place)
    
    m = Object.new
    m.extend(Manifestation)
    lambda { p.add_subject_of(m) }.should raise_exception
  end
  
  it "can be removed as the subject of a work" do
    c = Object.new
    c.extend(Concept)
    
    w = Object.new
    w.extend(Work)
    
    c.add_subject_of(w)
    w.subjects.should include(c)
    c.subject_of.should include(w)
    
    c.remove_subject_of(w)
    w.subjects.should_not include(c)
    c.subject_of.should_not include(w)    
  end
  
  it "can be related to another Group 3 entity" do
    e = Object.new
    e.extend(Event)
    
    c = Object.new
    c.extend(Concept)
    
    e.add_related_subject(c)
    
    e.related_subjects.should include(c)
    c.related_subjects.should include(e)
  end
  
  it "can only be related to another Group 3 entity" do
    o = Object.new
    o.extend(FRBR::Object)
    
    non_group_3 = Object.new
    
    lambda { o.add_related_subject(non_group_3) }.should raise_exception(ArgumentError)
  end  
  
  it "can remove the relationship to another Group 3 entity" do
    p = Object.new
    p.extend(Place)
    
    e = Object.new
    e.extend(Event)
    
    p.add_related_subject(e)
    p.related_subjects.should include(e)
    e.related_subjects.should include(p)
    
    p.remove_related_subject(e)
    p.related_subjects.should_not include(e)
    e.related_subjects.should_not include(p)    
  end
end