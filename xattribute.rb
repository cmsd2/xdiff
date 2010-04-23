module XDiff
  
  class XAttribute < XLeaf
    
    def initialize(n, v)
      self.name = n
      self.value = v
      self.attributes = []
      self.children = []
    end
    
    def create_insert
      InsertAttribute.new(XAttribute.new(a.name, a.value))
    end
    
    def remove_from_parent(node)
      node.attributes.delete(self)
      self.parent = nil
    end
    
    def to_s
      "#{self.name}=\"#{self.value}\""
    end
    
    def signature_name
      "@#{self.name}"
    end
  end
end