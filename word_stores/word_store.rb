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

    on_change
  end

  # Gets a word.
  # Note that this is a default implementation
  # based on @words being in existence.
  def get_word(starting_letter=nil, word_type=nil)
    filtered_words = @words
    filtered_words = filtered_words.select { |w| w.start_with? starting_letter } unless starting_letter.nil?
    filtered_words = filtered_words.select { |w| w.type == word_type } unless word_type.nil?

    raise StandardError.new("No words for: starting_letter #{starting_letter}, word_type #{word_type}.") if filtered_words.empty?
    pick_word(filtered_words)
  end

  # Upvotes a word in the store.
  # Note that in client applications this should be 
  # used instead of +Word.upvote+, as this is persisted
  # to the store.
  def upvote(word)
    word = find_word(word) if word.instance_of? String
    word.upvote
    on_change
  end

  # Downvotes a word in the store.
  # Note that in client applications this should be 
  # used instead of +Word.downvote+, as this is persisted
  # to the store.
  def downvote(word)
    word = find_word(word) if word.instance_of? String
    word.downvote
    on_change
  end

  # Returns the top 10 words by score
  def top(count=10)
    @words
      .sort_by { |word| -word.score }
      .take(count)
  end

  # Returns the bottom 10 words by score
  def bottom(count=10)
    @words
      .sort_by { |word| word.score }
      .take(count)
  end

  protected

  # Converts a word string into a +Word+ object.
  def find_word(string)
    word = @words.find { |w| w == string }
    raise StandardError.new("Could not find word #{string} in WordStore!") if word.nil?

    word
  end

  # Picks a word, based on its score
  def pick_word(words)
    # Each word has a score between 0 and 1.
    # We use the score as a probability of
    # choosing the word.
    word = nil
    loop do
      word = words.sample
      if word.score > @randomiser.rand
        break
      end
    end

    word
  end
end
