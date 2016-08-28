require 'minitest/autorun'
require 'minitest/pride'
require "./test/test_helper.rb"
require 'pry'
require_relative '../lib/complete_me'
require_relative '../lib/trie'
require_relative '../lib/node'


class CompleteMeTest <Minitest::Test

  def setup
    @complete = CompleteMe.new
  end

  def test_complete_me_creates_an_instance_of_trie
    assert_instance_of CompleteMe,   @complete
  end

  def test_complete_me_initializes_with_a_instance_of_trie
    assert_instance_of Trie, @complete.trie
  end

  def test_we_can_insert_a_word
    @complete.insert("pizza")
    assert_equal 1 , @complete.count
  end

  def test_populate_populates_from_a_string
    assert_equal 0, @complete.count
    string = ["aardvark", "aardwolf", "aaron", "aaronic", "aaronical", "aaronite", "aaronitic", "aaru", "ab", "aba"].join("\n")
    @complete.populate(string)
    assert_equal 10, @complete.count
  end

  def test_we_can_populate_a_dictionary_with_an_outside_file
    @complete.populate_from_file("mock_dictionary.txt")
    assert_equal 10, @complete.count
  end

  def test_it_suggests_all_the_possible_word_outcomes
    @complete.populate_from_file("mock_dictionary.txt")
    expected = ["aardvark", "aardwolf", "aaron", "aaronic", "aaronical", "aaronite", "aaronitic", "aaru", "ab", "aba"]
    assert_equal expected, @complete.suggest("a")
  end

end
