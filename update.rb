module XDiff
  
  class Update < Mutation

    attr_accessor :value
    
    def initialize(value, mutation_chain = [])
      super(mutation_chain)
      self.value = value
    end
    
    def do_mutation(node)
      node.update(self.value)
      return node
    end
    
    def to_s
      "Update #{value}"
    end
  end
end