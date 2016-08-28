require 'simplecov'
require "pry"
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

  def final_letter?
    @final_letter
  end

  def final_letter_setter
    @final_letter = !@final_letter
  end
end
