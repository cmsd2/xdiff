
module XDiff
  
  class XLeaf < XNode
    
    def initialize(v)
      self.name = nil
      self.attributes = []
      self.children = []
      self.value = v
    end
    
    def leaf_nodes
      [self]
    end
    
    def leaf?
      true
    end
    
    def update(value)
      self.value = value
    end

    def create_update
      ::XDiff::Update.new(self.value)
    end
  end
end