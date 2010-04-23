module XDiff
  
  class XElement < XNode

    def initialize(n, a = [], c = [])
      self.name = n
      self.attributes = a
      self.attributes.each { |a| a.parent = self }
      self.children = c
      self.children.each { |c| c.parent = self }
      @value = nil
    end
    
    def leaf_nodes
      [ self.children.collect { |c| c.leaf_nodes }, self.attributes ].flatten
    end
    
    def leaf?
      false
    end
    
    def to_s_short
      "#{name}#{super.to_s}"
    end

    def to_s
      attrs = self.attributes.collect { |c| c.to_s }.join(" ")
      open = "<#{self.name} #{attrs} digest=\"#{self.digest}\">"
      middle = self.children.collect { |c| c.to_s }.join("\n")
      close = "</#{self.name}>"
      
      "#{open}\n#{middle}\n#{close}"
    end
    
    def update_digest(digest_obj)
      digest_obj << name
      self.attributes.each { |a| a.calc_digest(digest_obj) unless a.digest }
      self.children.each { |c| c.calc_digest(digest_obj) unless c.digest }
      self.attributes.sort { |a,b| a.digest <=> b.digest }.collect { |a| a.update_digest(digest_obj) }
      self.children.sort { |a,b| a.digest <=> b.digest }.collect { |c| c.update_digest(digest_obj) }
    end
    
    def signature_name
      "/#{self.name}"
    end
  end
end