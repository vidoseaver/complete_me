class Node

  attr_reader :children, :letter


  def initialize(letter = nil)
    @letter = letter
    @children = Hash.new
    @final_letter = false
  end

  def add_child(node)
    @children[node.letter] = node
  end

  def word?
    @final_letter
  end

  def toggle_end_of_word
    @final_letter = !@final_letter
  end
end
