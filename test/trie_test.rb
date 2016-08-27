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

  # def test_trie_insert_takes_a_word_and_a_node
  #   assert_equal 0, @trie.insert("cat")
  # end
end
