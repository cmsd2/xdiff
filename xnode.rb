module XDiff
  class XNode
    attr_accessor :name
    attr_accessor :attributes
    attr_accessor :children
    attr_accessor :value
    attr_accessor :parent
    attr_accessor :digest
    
    def calc_digest(digest_obj)
      my_digest_obj = digest_obj.new()
      update_digest(my_digest_obj)
      self.digest = my_digest_obj.hexdigest
    end

    def update_digest(digest_obj)
      digest_obj << self.to_s
    end
    
    def remove_from_parent(node)
      node.delete_child(self)
      self.parent = nil
    end
    
    def insert_child(node)
      children << node
      node.parent = self
    end
    
    def delete_child(node)
      children.delete(node)
    end

    def signature
      prefix = self.parent.nil? ? "" : "#{parent.signature}"
      "#{prefix}#{signature_name}"
    end
    
    # create tree of instructions to deep copy this tree as a new subtree of y
    def create_insert()
      script = []
      attributes.each do |a|
        script << a.create_insert
      end
      children.each do |c|
        script << c.create_insert
      end
      
      InsertElement.new(XElement.new(self.name), script)
    end
    
    def create_delete
      DeleteChild.new(self)
    end
  end
end