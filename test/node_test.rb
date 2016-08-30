require_relative "../test/test_helper.rb"
# require "minitest/autorun"
# require "minitest/pride"
require_relative "../lib/node.rb"

class NodeTest < Minitest::Test

  def setup
    @node = Node.new
    @node_c = Node.new("c")
    @node_a = Node.new("a")
    @node_t = Node.new("t")
    @node_r = Node.new("r")
  end

  def test_node_is_a_node
    assert_instance_of Node, @node
  end

  def test_node_initializes_with_empty_hash
    assert_equal ({}), @node.children
  end

  def test_we_can_add_a_child
    assert_equal ({}), @node.children
    @node.add_child(@node_c)
    assert_equal @node_c, @node.children["c"]
  end

  def test_children_keys_are_lowercase_letters
    @node.add_child(@node_c)
    @node.add_child(@node_a)
    assert_equal ["c","a"], @node.children.keys
  end

  def test_children_values_are_instances_of_nodes
    @node.add_child(@node_c)
    @node.add_child(@node_a)
    assert_instance_of Node, @node.children.values.first
    assert_instance_of Node, @node.children.values.last
  end

  def test_nodes_default_letter_is_false
    assert_equal nil, @node.letter
  end

  def test_node_knows_its_letter
    assert_equal "c", @node_c.letter
  end

  def test_nodes_default_final_letter_false
    refute @node_c.final_letter?
  end

  def test_you_can_set_final_letter_to_true
    @node_t.final_letter_setter
    assert @node_t.final_letter?
  end
end
