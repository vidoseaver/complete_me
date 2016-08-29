require 'pry'
require_relative 'trie'

class CompleteMe
  attr_reader :trie, :library

  def initialize
    @trie = Trie.new
    @library = Hash.new
  end

  def insert(word)
    @trie.insert(word)
  end

  def count
    @trie.count
  end

  def populate(string)
    @trie.populate(string)
  end

  def populate_from_file(file_name)
    @trie.populate_from_file(file_name)
  end

  def suggest(user_input)
    @trie.suggest(user_input)
  end

  def select(substring, word)
    return "Invalid Selection" if !@trie.is_word_in_dictionary?(word)
    if @library[substring].nil?
      @library[substring] = {word => 1}
    else
      @library[substring][word] ? @library[substring][word] +=1 : @library[substring][word] = 1
    end
  end

end
