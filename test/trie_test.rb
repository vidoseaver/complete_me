require_relative "../test/test_helper.rb"
require 'pry'
require_relative '../lib/trie'
require_relative '../lib/node'

class TrieTest < Minitest::Test

  def setup
    @trie = Trie.new
    @root_node = Node.new
    @node_c = Node.new("c")
    @node_a = Node.new("a")
    @node_t = Node.new("t")
    @node_r = Node.new("r")
  end

  def test_trie_exists
    assert_instance_of Trie, @trie
  end

  def test_trie_has_a_root
    assert_instance_of Node, @trie.root
  end

  def test_trie_word_sanitizer_downcase
    assert_equal "cat", @trie.sanitize("CaT")
  end

  def test_trie_validate_check_if_input_is_string
    assert @trie.validate?("CaT")
    refute @trie.validate?(6)
  end

  def test_trie_format_input_makes_an_array_of_nodes
    assert_instance_of Node, @trie.format_input("cat").first
    assert_instance_of Node, @trie.format_input("cat").last
    assert_equal "c", @trie.format_input("cat").first.letter
    assert_equal "t", @trie.format_input("cat").last.letter
  end

  def test_trie_node_placer_can_make_a_new_path
    formatted_word = @trie.format_input("ca")
    first = formatted_word.first
    last = formatted_word.last
    assert_equal nil , @trie.root.children["c"]
    @trie.placer(formatted_word)
    assert_equal first, @trie.root.children["c"]
    assert_equal last, @trie.root.children["c"].children["a"]
  end

  def test_trie_node_placer_does_not_overwrite_previous_path
    formatted_word = @trie.format_input("ca")
    first_ca = formatted_word.first
    last_ca = formatted_word.last

    assert_equal nil , @trie.root.children["c"]
    @trie.placer(formatted_word)
    assert_equal first_ca, @trie.root.children["c"]
    assert_equal last_ca, @trie.root.children["c"].children["a"]

    formatted_word = @trie.format_input("ct")
    first_ct = formatted_word.first
    last_ct = formatted_word.last
    @trie.placer(formatted_word)

    assert_equal first_ca, @trie.root.children["c"]
    assert_equal last_ct, @trie.root.children["c"].children["t"]
  end

  def test_it_can_set_an_existing_node_as_end_of_word
    formatted_first_word = @trie.format_input("art")
    @trie.placer(formatted_first_word)
    refute @trie.root.children["a"].word?

    formatted_word = @trie.format_input("a")
    @trie.set_as_word(formatted_word)
    assert @trie.root.children["a"].word?
  end

  def test_child_exists_validates_correctly
    node_list = @trie.format_input("art")
    node = node_list.shift
    parent =  @trie.root

    formatted_word= @trie.format_input("art")
    @trie.placer(formatted_word)

    node = parent.children["a"]
    assert @trie.child_exists?(node, parent)
  end

  def test_set_child_places_the_child
    child  = @node_a
    parent = @trie.root

    assert @trie.root.children.empty?
    @trie.set_child(child, parent)
    assert_equal child, @trie.root.children["a"]
  end


  def test_set_child_places_a_child
    node_list = @trie.format_input("art")
    child = node_list.shift
    parent =  @trie.root

    assert parent.children.empty?
    @trie.set_child(child, parent)
    refute parent.children.empty?
  end

  def test_insert_adds_a_word_to_trie
    assert @trie.root.children.empty?
    @trie.insert("art")

    assert @trie.root.children["a"].children["r"].children["t"].word?
  end

  def test_word_count_tracks_number_of_inserted_words
    assert_equal 0, @trie.word_count
    assert_equal 1, @trie.insert("art")
  end

  def test_populate_takes_a_string_and_inserts_all_the_words
    assert_equal 0, @trie.word_count
    @trie.populate("pizza\ndog\ncat")

    assert_equal 3, @trie.word_count
  end

  def test_populate_from_txt_loads_a_full_dictionary
    skip
    assert_equal 0, @trie.word_count
    @trie.populate_from_txt("/usr/share/dict/words")

    assert_equal 235886, @trie.word_count
  end

  def test_populate_from_txt_loads_a_mock_dictionary
    assert_equal 0, @trie.word_count
    @trie.populate_from_txt("test/fixtures/mock_dictionary.txt")

    assert_equal 10, @trie.word_count
  end

  def test_it_can_populate_addresses_from_csv
    @trie.populate_from_csv("test/fixtures/short_addresses.csv")

    assert_equal 999, @trie.word_count
  end

  def test_climb_down_the_tree_return_last_node_of_word
    @trie.populate_from_txt("test/fixtures/mock_dictionary.txt")
    formatted_node_list = @trie.format_input("aaron")
    @trie.climb_down_the_tree(formatted_node_list)

    assert_instance_of Node, @trie.climb_down_the_tree(formatted_node_list)
    assert_equal "n", @trie.climb_down_the_tree(formatted_node_list).letter
  end

  def test_parent_finder_returns_parent_node
    @trie.insert("art")
    parent = @trie.root
    child = @trie.root.children["a"]
    node_list = [ @trie.root.children["a"], @trie.root]

    assert_equal parent, @trie.parent_finder(child, node_list)
  end


  def test_delete_changes_state_of_final_letter
    @trie.populate_from_txt("test/fixtures/mock_dictionary.txt")

    assert @trie.root.children["a"].children["a"].children["r"].children["o"].children["n"].word?
    @trie.delete("Aaron")
    refute @trie.root.children["a"].children["a"].children["r"].children["o"].children["n"].word?
  end

  def test_delete_node_removes_the_link_to_the_deleted_node
    @trie.populate_from_txt("test/fixtures/mock_dictionary.txt")

    assert_equal "u",  @trie.root.children["a"].children["a"].children["r"].children["u"].letter
    @trie.delete("aaru")
    assert_equal nil,  @trie.root.children["a"].children["a"].children["r"].children["u"]
  end

  def test_the_recursive_delete_deletes_all_empty_children
    @trie.populate_from_txt("test/fixtures/mock_dictionary.txt")

    assert_equal "v",  @trie.root.children["a"].children["a"].children["r"].children["d"].children["v"].letter
    @trie.delete("aardvark")
    assert_equal nil,  @trie.root.children["a"].children["a"].children["r"].children["d"].children["v"]
  end

  def test_word_count_goes_up_and_down_with_delete
    assert_equal 0, @trie.word_count
    @trie.populate_from_txt("test/fixtures/mock_dictionary.txt")
    assert_equal 10, @trie.word_count
    @trie.delete("aardvark")
    assert_equal 9, @trie.word_count
    @trie.delete("aardvark")
    assert_equal 9, @trie.word_count
  end

  def test_is_word_in_dictionary?
    @trie.populate_from_txt("test/fixtures/mock_dictionary.txt")

    assert @trie.is_word_in_dictionary?("aardvark")
    @trie.delete("aardvark")
    refute @trie.is_word_in_dictionary?("aardvark")
    refute @trie.is_word_in_dictionary?("notinthedictionary")
  end

  def test_find_all_child_words_returns_array_of_children
    @trie.populate_from_txt("test/fixtures/mock_dictionary.txt")

    node = @trie.root.children["a"].children["a"].children["r"].children["d"]
    assert_equal ["aardvark","aardwolf"], @trie.find_all_possible_words("aard")
  end

  def test_find_all_possible_words_returns_array_of_all_possible_words
    @trie.populate_from_txt("test/fixtures/mock_dictionary.txt")

    assert_equal ["aardvark","aardwolf"], @trie.find_all_possible_words("aard")
  end

  def test_find_all_possible_words_returns_empty_array_if_substring_doesnt_exist
    @trie.populate_from_txt("test/fixtures/mock_dictionary.txt")

    assert_equal [], @trie.find_all_possible_words("bil")
  end

  def test_validate_sanitize_and_format
    @trie.insert("and")

    assert_instance_of Node, @trie.validate_sanitize_and_format("and").first
    assert_equal "a", @trie.validate_sanitize_and_format("and").first.letter
  end

  def test_sugget_return_an_array_of_all_possible_words_based_on_substring
    @trie.populate_from_txt("test/fixtures/mock_dictionary.txt")

    assert_equal ["aaron", "aaronic", "aaronical", "aaronite", "aaronitic"] , @trie.suggest("aaron")
    assert_equal ["aardvark", "aardwolf", "aaron", "aaronic", "aaronical", "aaronite", "aaronitic", "aaru", "ab", "aba"] , @trie.suggest("a")
  end
end
