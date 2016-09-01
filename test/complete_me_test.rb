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
    assert_instance_of CompleteMe, @complete
  end

  def test_complete_me_initializes_with_a_instance_of_trie
    assert_instance_of Trie, @complete.trie
  end

  def test_we_can_insert_a_word
    @complete.insert("pizza")

    assert_equal 1, @complete.count
  end

  def test_we_can_insert_an_address
    @complete.insert("4995 N Enid Way")

    assert_equal 1, @complete.count
  end

  def test_populate_populates_from_a_string
    string = ["aardvark", "aardwolf", "aaron", "aaronic", "aaronical", "aaronite", "aaronitic", "aaru", "ab", "aba"].join("\n")

    assert_equal 0, @complete.count
    @complete.populate(string)

    assert_equal 10, @complete.count
  end

  def test_it_can_populate_a_dictionary_with_an_outside_file
    @complete.populate_from_txt("test/fixtures/mock_dictionary.txt")

    assert_equal 10, @complete.count
  end

  def test_it_can_load_addresses
    @complete.populate_from_csv("test/fixtures/short_addresses.csv")

    assert_equal 999, @complete.count
  end

  def test_it_suggests_all_the_possible_word_outcomes
    expected = ["aardvark", "aardwolf", "aaron", "aaronic", "aaronical", "aaronite", "aaronitic", "aaru", "ab", "aba"]
    @complete.populate_from_txt("test/fixtures/mock_dictionary.txt")

    assert_equal expected, @complete.suggest("a")
  end

  def test_it_suggests_all_the_possible_address_outcomes
    expected = ["4942 n altura st", "4940 e 39th ave", "4943 n altura st", "4949 n lowell blvd", "4947 n colorado blvd", "4944 w 46th ave"]
    @complete.populate_from_csv("test/fixtures/short_addresses.csv")

    assert_equal expected, @complete.suggest("494")
  end

  def test_select_returns_invalid_selection_if_word_does_not_exist_in_dictionary
    @complete.populate_from_txt("test/fixtures/mock_dictionary.txt")

    assert_equal "Invalid Selection", @complete.select("aard", "aardwork")
  end

  def test_library_initializes_as_an_empty_hash
    assert_equal ({}), @complete.library
  end

  def test_select_will_add_wieght_to_a_word
    @complete.populate_from_txt("test/fixtures/mock_dictionary.txt")

    assert_equal ["aardvark", "aardwolf"], @complete.suggest("aard")
    @complete.select("aard", "aardwolf")

    assert_equal ({"aardwolf"=>1}), @complete.library["aard"]
    @complete.select("aard", "aardwolf")

    assert_equal ({"aardwolf"=>2}), @complete.library["aard"]
    @complete.select("aard", "aardvark")

    assert_equal ({"aardwolf"=>2, "aardvark" => 1}), @complete.library["aard"]
  end

  def test_select_will_impact_addresses_suggestions
    @complete.populate_from_csv("test/fixtures/short_addresses.csv")
    expected = ["4942 n altura st", "4940 e 39th ave", "4943 n altura st", "4949 n lowell blvd", "4947 n colorado blvd", "4944 w 46th ave"]

    assert_equal expected, @complete.suggest("494")

    @complete.select("494", "4940 e 39th ave")
    new_expected = ["4940 e 39th ave", "4942 n altura st", "4943 n altura st", "4949 n lowell blvd", "4947 n colorado blvd", "4944 w 46th ave"]

    assert_equal new_expected, @complete.suggest("494")
  end

  def returns_wieghted_array_of_results_by_weight
    @complete.populate_from_txt("test/fixtures/mock_dictionary.txt")

    assert_equal ["aardvark", "aardwolf"], @complete.suggest("aard")
    @complete.select("aard", "aardwolf")

    assert_equal ["aardwolf", "aardvark"], @complete.suggest("aard")
    @complete.select("aard", "aardvark")
    @complete.select("aard", "aardwolf")

    assert_equal ["aardwolf", "aardvark"], @complete.all_results_by_weight("aard")
  end

  def test_suggest_returns_weighted_words_in_weight_order
    @complete.populate_from_txt("test/fixtures/mock_dictionary.txt")

    assert_equal ["aardvark", "aardwolf"], @complete.suggest("aard")
    @complete.select("aard", "aardwolf")

    assert_equal ["aardwolf", "aardvark"], @complete.suggest("aard")
    @complete.select("aard", "aardvark")
    @complete.select("aard", "aardwolf")

    assert_equal ["aardwolf", "aardvark"], @complete.suggest("aard")
  end


end
