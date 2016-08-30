require_relative "../test/test_helper.rb"
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

  def test_select_returns_invalid_selection_if_word_does_not_exist_in_dictionary
    @complete.populate_from_file("mock_dictionary.txt")
    assert_equal "Invalid Selection", @complete.select("aard", "aardwork")
  end

  def test_select_will_add_wieght_to_a_word
    @complete.populate_from_file("mock_dictionary.txt")
    assert_equal ["aardvark", "aardwolf"], @complete.suggest("aard")
    @complete.select("aard", "aardwolf")
    assert_equal ({"aardwolf"=>1}), @complete.library["aard"]
    @complete.select("aard", "aardwolf")
    assert_equal ({"aardwolf"=>2}), @complete.library["aard"]
    @complete.select("aard", "aardvark")
    assert_equal ({"aardwolf"=>2, "aardvark" => 1}), @complete.library["aard"]
  end

  def returns_wieghted_array_of_results_by_weight
    @complete.populate_from_file("mock_dictionary.txt")
    assert_equal ["aardvark", "aardwolf"], @complete.suggest("aard")
    @complete.select("aard", "aardwolf")
    assert_equal ["aardwolf", "aardvark"], @complete.suggest("aard")
    @complete.select("aard", "aardvark")
    @complete.select("aard", "aardwolf")
    assert_equal ["aardwolf", "aardvark"], @complete.all_results_by_weight("aard")
  end

  def test_suggest_returns_weighted_words_in_weight_order
    @complete.populate_from_file("mock_dictionary.txt")
    assert_equal ["aardvark", "aardwolf"], @complete.suggest("aard")
    @complete.select("aard", "aardwolf")
    assert_equal ["aardwolf", "aardvark"], @complete.suggest("aard")
    @complete.select("aard", "aardvark")
    @complete.select("aard", "aardwolf")
    assert_equal ["aardwolf", "aardvark"], @complete.suggest("aard")
  end

  def test_we_can_load_addresses
    @complete.populate_from_csv("short_addresses.csv")
    assert_equal 999, @complete.count
  end
end
