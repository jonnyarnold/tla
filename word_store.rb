# Stores +Word+s.
class WordStore

  # Adds the given word to the store.
  def add(word)
  end

  # Gets a word.
  def get_word(starting_letter=nil, word_type=nil)
  end

end

# Uses a file for word storage.
class FileWordStore < WordStore

  # Creates a FileWordStore.
  # Gets the word list from the given file.
  # 
  # The file should follow the following format:
  # - Words are given one per line.
  # - If the line starts with a hash (#) the word type is changed for any following words.
  # - The file must start with a word type declaration.
  # - All words should start with a capital letter
  # 
  # The following file:
  # #adjective
  # Happy
  # Sad
  # #noun
  # Brick
  # Tree
  # 
  # will create a word list of 4 words; two adjectives and 2 nouns.
  def initialize(word_file)
    type = nil

    @words = File.readlines(word_file).map do |line|
      line = line.chomp
      if line.start_with? '#'
        type = line[1..-1].to_sym
        nil # Cleaned up later
      else
        Word.new(line, type)
      end
    end
      .reject { |w| w.nil? }
  end

  def get_word(starting_letter=nil, word_type=nil)
    filtered_words = @words
    filtered_words = filtered_words.select { |w| w.start_with? starting_letter } unless starting_letter.nil?
    filtered_words = filtered_words.select { |w| w.type == word_type } unless word_type.nil?
    filtered_words.sample
  end

end
