module XDiff
  
  class XDiff
    
  class << self
    
  def xdiff(t1, t2)
    if t1.hash == t2.hash
      []
    else
      min_cost_matching, distance_table = find_matches(t1, t2)
      
      #p "M:"
      #min_cost_matching.each { |m| p "#{m.collect {|i| i.to_s }.join("\n")}" }
      #p "M #{min_cost_matching}"
      #p "DT #{distance_table.inspect}"
      
      script = create_edit_script(t1.root, t2.root, min_cost_matching, distance_table)
      script.each do |s|
        puts "#{s.to_s}\n"
      end
      script
    end
  end

  def find_matches(t1, t2)
    p "finding matches between #{t1.root.digest} and #{t2.root.digest}"
    n1 = t1.leaf_nodes
    n2 = t2.leaf_nodes
    
    distance_table = {}
    min_cost_table = []
    
    # step 1. reduce the matching space
    # filter out next-level subtrees that have equal XHash values
    
    # step 2. compute editing distance for (t1 -> t2)
    
    begin
      n1.each do |x|
        n2.each do |y|
          if x.signature == y.signature
            p "computing distance between #{x.signature} elements #{x.digest} and #{y.digest}"
            dist_x_y, matches = compute_distance(distance_table, x, y)
            p "distance = #{dist_x_y}"
            p "X #{x}"
            p "Y #{y}"
            matches.each { |m| p "M #{m.collect {|i| i.to_s }.join("\n")}" }
            #matches.each { |m| min_cost_table << m }
            # save matching (x,y) with distance dist(x, y) in DT
            distance_table_add(distance_table, x, y, dist_x_y, matches)
          end
        end
      end
      
      n1 = n1.collect { |n| n.parent }.delete_if { |n| n.nil? }.uniq
      n2 = n2.collect { |n| n.parent }.delete_if { |n| n.nil? }.uniq
    end while not (n1.empty? or n2.empty?)
    
    # step 3. mark matchings on t1 and t2
    
    add_mapping_to_min_cost_table(min_cost_table, distance_table, t1.root, t2.root)
    
    return min_cost_table, distance_table
  end
  
  def distance_table_add(distance_table, x, y, dist_x_y, matches)
    distance_table[[x, y]] = [dist_x_y, matches]
  end
  
  def distance_table_lookup(distance_table, x, y)
    d = distance_table[[x, y]]
    d[0] unless d.nil?
  end
  
  def distance_table_lookup_matches(distance_table, x, y)
    d = distance_table[[x, y]]
    d[1] unless d.nil?
  end
  
  def add_mapping_to_min_cost_table(min_cost_table, distance_table, n1, n2)
    if n1.signature == n2.signature
      p "adding mapping between #{n1.signature} elements #{n1.digest} and #{n2.digest}"
      p "X #{n1}"
      p "Y #{n2}"
      min_cost_table << [n1, n2]
    
      if not n1.leaf? and not n2.leaf?
        child_matches = distance_table_lookup_matches(distance_table, n1, n2)
        child_matches.each do |cm| 
          p "adding match #{cm}"
          min_cost_table << cm
          add_mapping_to_min_cost_table(min_cost_table, distance_table, cm[0], cm[1])
        end
      end
    end
  end
  
  def add_descendents(min_cost_table, distance_table, n1_children, n2_children)
    # for every non leaf-node mapping (x,y) in min_cost_table
    n1_children.each do |c1|
      n2_children.each do |c2|
        # retrieve matchings between their child nodes that are stored in distance_table
        if distance_table_lookup(distance_table, c1, c2)
          add_mapping_to_min_cost_table(min_cost_table, distance_table, c1, c2)
        end
      end
    end
  end

  def compute_distance(distance_table, x, y)
    if x.leaf? and y.leaf?
      return (x.digest == y.digest ? 0 : 1), [[x, y]]
    end

    x_list = [x.attributes, x.children].flatten
    y_list = [y.attributes, y.children].flatten
    
    compute_distance_recurse(distance_table, 0, x_list, y_list)
  end
  
  def compute_distance_recurse(distance_table, accumulator, x_list, y_list)
    p "compute_distance_recurse #{accumulator} #{x_list} #{y_list}"
    return accumulator + x_list.length, [] if y_list.empty?
    return accumulator + y_list.length, [] if x_list.empty?

    y_item = y_list.pop
    x_popped = []

    min_cost = -1
    min_cost_x_item = nil
    min_cost_matches = []

    while not x_list.empty?
      x_item = x_list.pop

      cost = distance_table_lookup(distance_table, x_item, y_item)
      
      if not cost.nil?
        cost, matches = compute_distance_recurse(distance_table, cost, [x_popped, x_list].flatten, y_list.dup)

        if min_cost_x_item.nil? or cost < min_cost
          min_cost = cost
          min_cost_x_item = x_item
          min_cost_matches = matches
        end
      end

      x_popped << x_item
    end
    
    min_cost_matches << [min_cost_x_item, y_item]
    
    return (min_cost + accumulator), min_cost_matches
  end
  
  def min_cost_table_contains_x(min_cost_table, x)
    min_cost_table_contains_element(min_cost_table, lambda { |xy| xy[0] }, x)
  end
  
  def min_cost_table_contains_y(min_cost_table, y)
    min_cost_table_contains_element(min_cost_table, lambda { |xy| xy[1] }, y)
  end
  
  def min_cost_table_contains_element(min_cost_table, selector, y)
    min_cost_table.each do |xy|
      return true if selector.call(xy) == y
    end
    return false
  end

  def create_edit_script(x, y, min_cost_matches, distance_table)
    result = []
    
    if not min_cost_matches.find([x,y])
      # subtree deletion and insertion
      p "adding whole subtree replace"
      result << Transformation.new(x.parent, [x.create_delete, y.create_insert])
      p result.collect {|s| s.to_s }.inspect
    elsif distance_table_lookup(distance_table, x, y) == 0
      # nothing
      p "elements #{x.signature} #{x.digest} #{y.digest} are the same"
    else
      # for every node pair (x_i, y_j) in min_cost_matches, such that x_i is a child node of x and y_j is a child node of y
      [x.children, x.attributes].flatten.each do |xc|
        [y.children, y.attributes].flatten.each do |yc|
          if min_cost_matches.include?([xc, yc])
            if xc.leaf? and yc.leaf?
              p "diffing leaves #{xc} and #{yc}"
              if distance_table_lookup(distance_table, xc, yc) != 0
                # update leaf node
                p "adding leaf update"
                result << Transformation.new(xc, yc.create_update)
                p result.collect {|s| s.to_s }.inspect
              end
            else
              p "recursing into #{xc} and #{yc}"
              result << create_edit_script(xc, yc, min_cost_matches, distance_table)
              p result.flatten.collect {|s| s.to_s }.inspect
            end
          end
        end
      end
      
      # for every node x_i not in min_cost_matches
      [x.children, x.attributes].flatten.each do |xc|
        if not min_cost_table_contains_x(min_cost_matches, xc)
          p "deleting extra x #{xc}"
          p "M #{min_cost_matches.collect {|s| s.collect{|z| z.to_s}}.inspect}"
          result << Transformation.new(xc.parent, xc.create_delete)
          p result.collect {|s| s.to_s }.inspect
        end
      end
      
      # for every node y_j not in min_cost_matches
      [y.children, y.attributes].flatten.each do |yc|
        if not min_cost_table_contains_y(min_cost_matches, yc)
          p "adding extra y #{yc}"
          result << Transformation.new(x, yc.create_insert)
          p result.collect {|s| s.to_s }.inspect
        end
      end
    end
    
    return result
  end
end
end
end