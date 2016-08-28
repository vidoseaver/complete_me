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

  def populate(file_name)
    @trie.populate(file_name)
  end

  def method_name

  end

end
