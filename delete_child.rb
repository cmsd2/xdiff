module XDiff
  
  class DeleteChild < Mutation
    
    attr_accessor :child_node
    
    def initialize(child_node, mutation_chain = [])
      super(mutation_chain)
      self.child_node = child_node
    end
    
    def do_mutation(node)
      self.child_node.remove_from_parent(node)
      return node
    end
    
    def to_s
      "DeleteChild #{child_node.signature} #{child_node.digest}"
    end
  end
end