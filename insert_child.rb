module XDiff
  
  class Insert < Mutation
    attr_accessor :child_node

    # insert x as a new leaf node of y
    def initialize(child_node, mutation_chain = [])
      super(mutation_chain)
      self.child_node = child_node
    end
    
    def do_mutation(node)
      raise "should be overridden"
    end

    def to_s
      "#{self.class} #{child_node.signature} #{child_node.digest}"
    end
  end

  class InsertAttribute < Insert
    def do_mutation(node)
      node.insert_attribute(self.child_node)
      return node
    end
  end
  
  class InsertText < Insert
    def do_mutation(node)
      node.insert_child(self.child_node)
      return node
    end
  end

  class InsertElement < Insert
    def do_mutation(node)
      node.insert_child(self.child_node)
      return self.child_node
    end
  end
end