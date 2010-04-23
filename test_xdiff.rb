#!/usr/bin/ruby
if __FILE__ == $0
  require "mutation"
  require "transformation"
  require "delete_child"
  require "update"
  require "insert_child"
  require "xnode"
  require "xelement"
  require "xleaf"
  require "xtext"
  require "xattribute"
  require "xtree"
  require "xdiff"
  require "digest"
  
  def create_t1
    mike = XDiff::XText.new("Mike")
    firstName = XDiff::XElement.new("FirstName", [], [mike])
    johnson = XDiff::XText::new("Johnson")
    lastName = XDiff::XElement.new("LastName", [], [johnson])
    name = XDiff::XElement.new("Name", [], [firstName, lastName])
    movie1 = XDiff::XText::new("movie1")
    title1 = XDiff::XElement.new("Title", [], [movie1])
    movie2 = XDiff::XText::new("movie2")
    title2 = XDiff::XElement.new("Title", [], [movie2])
    movie3 = XDiff::XText::new("movie3")
    title3 = XDiff::XElement.new("Title", [], [movie3])
    movies = XDiff::XElement.new("Movies", [], [title1, title2, title3])
    actor1 = XDiff::XElement.new("Actor", [], [name, movies])
    mike2 = XDiff::XText.new("Mike")
    firstName2 = XDiff::XElement.new("FirstName", [], [mike2])
    goodman = XDiff::XText.new("Goodman")
    lastName2 = XDiff::XElement.new("LastName", [], [goodman])
    name = XDiff::XElement.new("Name", [], [firstName2, lastName2])
    movie1 = XDiff::XText.new("movie1")
    title1 = XDiff::XElement.new("Title", [], [movie1])
    movie2 = XDiff::XText.new("movie2")
    title2 = XDiff::XElement.new("Title", [], [movie2])
    movie3 = XDiff::XText.new("movie3")
    title3 = XDiff::XElement.new("Title", [], [movie3])
    movies = XDiff::XElement.new("Movies", [], [title1, title2, title3])
    actor2 = XDiff::XElement.new("Actor", [], [name, movies])
    actors = XDiff::XElement.new("Actors", [], [actor1, actor2])
    XDiff::XTree.new(actors)
  end
  
  def create_t2
    mike = XDiff::XText.new("Mike")
    firstName = XDiff::XElement.new("FirstName", [], [mike])
    johnson = XDiff::XText::new("Johnson")
    lastName = XDiff::XElement.new("LastName", [], [johnson])
    name = XDiff::XElement.new("Name", [], [firstName, lastName])
    @movie1 = XDiff::XText::new("movie4")
    @title1 = XDiff::XElement.new("Title", [], [@movie1])
    movie2 = XDiff::XText::new("movie2")
    title2 = XDiff::XElement.new("Title", [], [movie2])
    movie3 = XDiff::XText::new("movie3")
    title3 = XDiff::XElement.new("Title", [], [movie3])
    @movies = XDiff::XElement.new("Movies", [], [@title1, title2, title3])
    actor1 = XDiff::XElement.new("Actor", [], [name, @movies])
    mike2 = XDiff::XText.new("Bill")
    firstName2 = XDiff::XElement.new("FirstName", [], [mike2])
    goodman = XDiff::XText.new("Goodman")
    lastName2 = XDiff::XElement.new("LastName", [], [goodman])
    name = XDiff::XElement.new("Name", [], [firstName2, lastName2])
    movie1 = XDiff::XText.new("movie1")
    title1 = XDiff::XElement.new("Title", [], [movie1])
    movie2 = XDiff::XText.new("movie2")
    title2 = XDiff::XElement.new("Title", [], [movie2])
    movie3 = XDiff::XText.new("movie3")
    title3 = XDiff::XElement.new("Title", [], [movie3])
    movies2 = XDiff::XElement.new("Movies", [], [title1, title2, title3])
    actor2 = XDiff::XElement.new("Actor", [], [name, movies2])
    actors = XDiff::XElement.new("Actors", [], [actor1, actor2])
    XDiff::XTree.new(actors)
  end
  
  t1 = create_t1
  t2 = create_t2
  
  digest_obj = Digest::MD5.new()
  
  t1.calc_digest(digest_obj)
  
  digest_obj.reset
  
  t2.calc_digest(digest_obj)
  
  #puts "#{t1.leaf_nodes}\n"
  
  script = XDiff::XDiff.xdiff(t1, t2)

  puts "#{t1.to_s}\n"
  puts "#{t2.to_s}\n\n\n"
  
  p script.inspect
  
  script.flatten.each { |s| s.perform t1 }
  
  puts "new trees\n"
  puts "#{t1.to_s}\n"
  puts "#{t2.to_s}\n\n\n"
  
  #movie1 = XDiff::XText::new("movie1")
  #title1 = XDiff::XElement.new("Title", [], [movie1])
    
  #script = []
  #script << @title1.create_delete
  #script << title1.create_insert
  
  #tx = XDiff::Transformation.new(@movies, script)
  
  #p "cost: #{tx.cost}"
  #tx.perform
  
  #puts "#{t2.to_s}\n"
end
