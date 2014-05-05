# Stores +Word+s.
class WordStore

  def initialize
    @words = []
    @randomiser = Random.new
  end

  # Adds the given word to the store.
  def add(word)
    if word.respond_to? :each
      @words += word
    else
      @words.push word
    end
  end

  # Gets a word.
  # Note that this is a default implementation
  # based on @words being in existence.
  def get_word(starting_letter=nil, word_type=nil)
    filtered_words = @words
    filtered_words = filtered_words.select { |w| w.start_with? starting_letter } unless starting_letter.nil?
    filtered_words = filtered_words.select { |w| w.type == word_type } unless word_type.nil?

    raise StandardError.new("No words for: starting_letter #{starting_letter}, word_type #{word_type}.") if filtered_words.empty?

    # Each word has a score between 0 and 1.
    # We use the score as a probability of
    # choosing the word.
    loop do
      word = filtered_words.sample
      if word.score > @randomiser.rand
        break
      end
    end

    word
  end

  def upvote(word)
    word.upvote
  end

  def downvote(word)
    word.downvote
  end

end

# Uses a file for word storage.
class FileWordStore < WordStore

  # Creates a FileWordStore.
  def initialize(word_file)
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

# Uses Marshal for storing words
class MarshalWordStore < WordStore

  def initialize(marshal_file)
    @file_path = marshal_file
    File.write(@file_path, Marshal::dump([])) unless File.exists? @file_path
    @words = Marshal::load(File.read(marshal_file))
  end

  # Add a word or list of words to the store.
  def add(word)
    super word
    save!
  end

  def save!
    File.write(@file_path, Marshal::dump(@words))
  end

end
