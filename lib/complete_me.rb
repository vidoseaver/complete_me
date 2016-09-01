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
    @trie.word_count
  end

  def populate(string)
    @trie.populate(string)
  end

  def populate_from_txt(file_name)
    @trie.populate_from_txt(file_name)
  end

  def populate_from_csv(file_name)
    @trie.populate_from_csv(file_name)
  end

  def suggest(substring)
    if @library[substring].nil?
    suggested =  @trie.suggest(substring)
    else
      suggested =(all_results_by_weight(substring)+ @trie.suggest(substring)).uniq
    end
    suggested
  end

  def all_results_by_weight(substring)
    weighted_words =
    @library[substring].sort_by do |word, weight|
      weight
    end.reverse!
    weighted_words.map! {|word| word[0]}
  end

  def select(substring, word)
    return "Invalid Selection" unless @trie.is_word_in_dictionary?(word)
    if @library[substring].nil?
      @library[substring] = {word => 1}
    else
      @library[substring][word] ? @library[substring][word] += 1 : @library[substring][word] = 1
    end
  end
end

complete = CompleteMe.new
file = File.read("/usr/share/dict/words")
complete.populate(file)

p complete.suggest("aaron")
