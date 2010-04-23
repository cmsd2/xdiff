module XDiff
  
  class XText < XLeaf

    def initialize(v)
      self.name = nil
      self.attributes = []
      self.children = []
      self.value = v
    end

    def create_insert
      InsertText.new(XText.new(self.value))
    end
    
    def to_s
      self.value
    end
    
    def signature_name
      "::text()"
    end
  end
end