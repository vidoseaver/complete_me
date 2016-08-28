require 'minitest/autorun'
require 'minitest/pride'
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

  def test_set_final_letter_true_if_end_of_word
    formatted_first_word = @trie.format_input("art")
    @trie.placer(formatted_first_word)
    refute @trie.root.children["a"].final_letter?

    formatted_word = @trie.format_input("a")
    @trie.set_final_letter(formatted_word)
    # @trie.set_final_letter(formatted_word)
    assert @trie.root.children["a"].final_letter?
  end

  def test_key_exists_validates_correctly
    node_list = @trie.format_input("art")
    node = node_list.shift
    parent =  @trie.root

    formatted_word= @trie.format_input("art")
    @trie.placer(formatted_word)

    node = parent.children["a"]
    assert @trie.key_exists?(node, parent)
  end

  def test_set_child_places_a_child
    node_list = @trie.format_input("art")
    node = node_list.shift
    parent =  @trie.root

    assert parent.children.empty?
    @trie.set_child(node,node_list, parent)
    refute parent.children.empty?
  end

  def test_insert_adds_a_word_to_trie
    assert @trie.root.children.empty?
    @trie.insert("art")
    assert @trie.root.children["a"].children["r"].children["t"].final_letter?
  end

  def test_count_tracks_number_of_inserted_words
    assert_equal 0, @trie.count
    assert_equal 1, @trie.insert("art")
  end

  def test_populate_loads_a_full_dictionary
    skip
    assert_equal 0, @trie.count
    @trie.populate("/usr/share/dict/words")
    assert_equal 235886, @trie.count
  end

  def test_populate_loads_a_mock_dictionary
    assert_equal 0, @trie.count
    @trie.populate("mock_dictionary.txt")
    assert_equal 10, @trie.count
  end

  def test_climb_down_the_tree_return_last_node_of_word
    @trie.populate("mock_dictionary.txt")
    formatted_node_list = @trie.format_input("aaron")
    @trie.climb_down_the_tree(formatted_node_list)
    assert_instance_of Node, @trie.climb_down_the_tree(formatted_node_list)
    assert_equal "n", @trie.climb_down_the_tree(formatted_node_list).letter
  end

  def test_parent_finder_returns_parent_node
    skip
    @trie.insert("art")
    node = @trie.root.children["a"]
    parent = @trie.root

    assert_equal parent, @trie.parent_finder(node)
  end


  def test_delete_changes_state_of_final_letter
    @trie.populate("mock_dictionary.txt")
    @trie.delete("Aaron")

    refute @trie.root.children["a"].children["a"].children["r"].children["o"].children["n"].final_letter?
  end







end
