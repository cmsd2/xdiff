module XDiff
  
  class Mutation
    attr_accessor :mutation_chain
    
    def initialize(mutation_chain = [])
      self.mutation_chain = mutation_chain
    end
    
    def perform(node)
      p "performing mutation #{self}"
      modified_node = do_mutation(node)
      do_chain(modified_node)
      modified_node
    end
    
    def do_chain(modified_node)
      [self.mutation_chain].flatten.each do |c|
        modified_node = c.perform(modified_node)
      end
    end
    
    def my_cost
      1
    end
    
    def cost
      self.mutation_chain.inject(my_cost) { |i, mutation| i + mutation.cost }
    end
  end
end