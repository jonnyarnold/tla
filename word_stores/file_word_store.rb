require './word_stores/word_store' # Base class
require './logic/word'             # Word class

# Uses a file for word storage.
class FileWordStore < WordStore

  # Creates a FileWordStore.
  def initialize(word_file)
    super()
    @words = get_words_from_file(word_file)
  end

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
  def self.get_words_from_file(word_file)
    type = nil

    File.readlines(word_file).map do |line|
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

end
