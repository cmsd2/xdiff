module XDiff
  class XTree < XElement
    attr_accessor :root
    
    def initialize(element = nil)
      super("DOCROOT")
      insert_child(element) unless element.nil?
    end
    
    def delete_child(node)
      super.delete_child(node)
      if node == self.root
        self.root = nil
      end
    end
    
    def insert_child(node)
      if self.root.nil?
        self.root = node
        super(node)
      else
        raise "Cannot have more than one root element in an xml document"
      end
    end
    
    def signature_name
      
    end
    
    def to_s
      "<?xml digest=\"#{digest}\"?>\n#{self.root.to_s}"
    end
  end

end