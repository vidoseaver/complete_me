require_relative 'node'
require 'pry'

class Trie

  attr_reader :root

  def initialize
    @root = Node.new
  end

  def insert(word, node = @root)
    validate(word)
    return puts "Invalid entry" if validate?(word) != true
    sanitize(word)
    format_input(word)
  end

  def sanitize(word)
    word.downcase!
  end

  def validate?(word)
    word.class == String ? true : false
  end

  def format_input(word)
    word.chars.map do |letter|
      Node.new(letter)
    end
  end

  def placer(node_list, parent_node = @root)
    return if node_list.empty?
    set_final_letter(node_list, parent_node)
    node = node_list.shift
    if parent_node.children.has_key?(node.letter)
        placer(node_list, parent_node.children[node.letter])
      end
    if !parent_node.children.has_key?(node.letter)
      parent_node.add_child(node)
      placer(node_list, node)
      end
  end

  def set_final_letter(node_list, parent_node)
    if parent_node == nil 
    ending_node = parent_node.children[node_list.last.letter]
    binding.pry
    if ending_node.letter == node.list.last.letter && node_list.length == 1
      ending_node.final_letter_setter
    else
      node_list.last.final_letter_setter
    end
  end


end
