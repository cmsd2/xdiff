module XDiff
  
  class Transformation < Mutation
    attr_accessor :node
    
    def initialize(node, mutation_chain = [])
      self.node = node
      self.mutation_chain = mutation_chain
    end
    
    def do_mutation(node)
      self.node
    end
    
    def my_cost
      0
    end
    
    def to_s
      "Transformation batch <\n#{[mutation_chain].flatten.collect{|c| c.to_s}.join("\n")}>"
    end
  end
end