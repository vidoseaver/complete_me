require 'pry'
require_relative 'trie'

class CompleteMe

  attr_reader :trie

  def initialize
    @trie = Trie.new
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

end
