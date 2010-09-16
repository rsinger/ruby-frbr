require File.dirname(__FILE__) + '/frbr/groups'
require File.dirname(__FILE__) + '/frbr/work'
require File.dirname(__FILE__) + '/frbr/expression'
require File.dirname(__FILE__) + '/frbr/manifestation'
require File.dirname(__FILE__) + '/frbr/item'
require File.dirname(__FILE__) + '/frbr/concept'
require File.dirname(__FILE__) + '/frbr/corporate_body'
require File.dirname(__FILE__) + '/frbr/event'
require File.dirname(__FILE__) + '/frbr/family'
require File.dirname(__FILE__) + '/frbr/object'
require File.dirname(__FILE__) + '/frbr/person'
require File.dirname(__FILE__) + '/frbr/place'

module Kernel
  def self.constant(const)
    const = const.to_s.dup
    base = const.sub!(/^::/, '') ? Object : ( self.kind_of?(Module) ? self : self.class )
    const.split(/::/).inject(base){ |mod, name| mod.const_get(name) }
  end
end