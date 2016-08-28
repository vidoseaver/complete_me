
require_relative 'node'
require 'pry'

class Trie

  attr_reader :root, :count

  def initialize
    @root = Node.new
    @count = 0
    @storage = Array.new
    @stored = Array.new
  end

  def insert(word, node = @root)
    setup = validate_sanitize_and_format(word)
    placer(setup)
    @count += 1
  end

  def sanitize(word)
    word.downcase
  end

  def validate?(word)
    word.class == String ? true : false
  end

  def format_input(word)
    word.chars.map do |letter|
      Node.new(letter)
    end
  end

  def placer(node_list, parent = @root)
    return if node_list.empty?
    set_final_letter(node_list, parent)            if node_list.length == 1
    node = node_list.shift
    placer(node_list, parent.children[node.letter])if key_exists?(node, parent)
    set_child(node, node_list, parent)             if !key_exists?(node, parent)
  end

  def set_final_letter(node_list, parent = @root)
    node = node_list.last
    existing_node = parent.children[node.letter]
    node.final_letter_setter          if existing_node.nil?
    existing_node.final_letter_setter if !existing_node.nil?
  end

  def key_exists?(node, parent)
    parent.children.has_key?(node.letter)
  end

  def set_child(node, node_list, parent)
    parent.add_child(node)
    placer(node_list, node)
  end

  def populate(string)
    list = string.split("\n")
    list.each do |word|
      insert(word)
    end
  end

  def populate_from_file(file_path)
    file = File.open(file_path)
    file.readlines.each do |word|
      insert(word.chomp)
    end
  end

  def delete(word)
    setup = validate_sanitize_and_format(word)
    node = climb_down_the_tree(setup)
    return if node.nil?
    return node.final_letter_setter if !node.children.empty? && node.final_letter?
    node.final_letter_setter
    recursive_delete(@storage)
    @count -= 1
    @storage = Array.new
  end

  def climb_down_the_tree(node_list, parent = @root)
    return nil if parent.nil?
    return @storage.last if node_list.empty?
    node = node_list.shift
    @storage << parent.children[node.letter]
    climb_down_the_tree(node_list, parent.children[node.letter])
  end

  def delete_node(node, node_list)
    parent = parent_finder(node, node_list)
    parent.children.delete(node.letter)
  end

  def parent_finder(node, node_list)
    return node.list.last if node_list.length == 1
    node = node_list.last
  end

  def recursive_delete(node_list)
    node = node_list.last
    return if node.final_letter? || node == @root || !node.children.empty?
    node = node_list.pop
    delete_node(node, node_list) if node.children.empty?
    recursive_delete(node_list)
  end

  def is_word_in_dictionary?(word)
    setup = validate_sanitize_and_format(word)
    node = climb_down_the_tree(setup)
    return false if node.nil?
    stored = @storage
    @storage = Array.new
    stored.last.final_letter? ? true : false
  end

  def find_all_possible_words(string)
    setup = validate_sanitize_and_format(string)
    node = climb_down_the_tree(setup)
    return [] if node.nil?
    find_all_child_words(node,string)
    stored = @stored
    @stored = Array.new
    stored
  end

  def find_all_child_words(node, string)
    @stored << string if node.final_letter?
    if !node.children.empty?
      node.children.each do |letter, child_node|
        new_string = string
        new_string += letter
        find_all_child_words(child_node, new_string)
      end
    end
  end

  def validate_sanitize_and_format(string)
    return puts "Invalid entry" if validate?(string) != true
    sanitized_word = sanitize(string)
    formatted_node_list = format_input(sanitized_word)
  end

  def suggest(string)
    find_all_possible_words(string)
  end

end
