require 'pg'

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

  def upvote(word)
    word = find_word(word) if word.instance_of? String
    word.upvote
    on_change
  end

  def downvote(word)
    word = find_word(word) if word.instance_of? String
    word.downvote
    on_change
  end

  def top(count=10)
    @words
      .sort_by { |word| -word.score }
      .take(count)
  end

  def bottom(count=10)
    @words
      .sort_by { |word| word.score }
      .take(count)
  end

  protected

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

# Uses PostgreSQL for storing words
class PostgresWordStore < WordStore

  def initialize(connection)
    super()
    @connection_settings = connection
  end

  def reset!
    ensure_connected

    @db.exec("DROP TABLE IF EXISTS words")
    @db.exec("CREATE TABLE IF NOT EXISTS words ( word varchar(50), type varchar(20), votes text )")
  end

  # Adds the given word to the store.
  def add(word)

    ensure_connected
    query = "INSERT INTO words (word, type, votes) VALUES "

    values = []
    if word.respond_to? :each
      word.each { |w| values.push "('#{quoted(w.to_s)}', '#{w.type}', '#{w.vote_str}')" }
    else
      values.push "('#{quoted(word.to_s)}', '#{word.type}', '#{word.vote_str}')"
    end

    query += values.join(", ")
    @db.exec(query)
  end

  # Gets a word.
  # Note that this is a default implementation
  # based on @words being in existence.
  def get_word(starting_letter=nil, word_type=nil)
    ensure_connected

    filtered_words_query = "SELECT * FROM words"
    conditions = []
    conditions.push "word LIKE '#{starting_letter}%'" unless starting_letter.nil?
    conditions.push "type = '#{word_type}'" unless word_type.nil?
    unless conditions.empty?
      filtered_words_query += " WHERE "
      filtered_words_query += conditions.join(" AND ")
    end

    words = []
    @db.exec(filtered_words_query) do |result|
      result.each { |row| words << row_to_word(row) }
    end

    pick_word(words)
  end

  def upvote(word)
    word = find_word(word) if word.instance_of? String
    word.upvote
    update(word)
  end

  def downvote(word)
    word = find_word(word) if word.instance_of? String
    word.downvote
    update(word)
  end

  private

  def ensure_connected
    @db = PG.connect(@connection_settings) if @db.nil?
  end

  def quoted(word)
    word.gsub("'", "\\'")
  end

  def row_to_word(row)
    score = if row['votes'].empty? then nil else WordScore.from_s(row['votes']) end
    word = Word.new(row['word'], row['type'].to_sym, score)
    word
  end

  def find_word(string)
    ensure_connected

    query = "SELECT * FROM words WHERE word = '#{quoted(string)}' LIMIT 1"
    
    word = ""
    @db.exec(query) do |result|
      raise StandardError.new("Could not find word #{string} in WordStore!") if result.count == 0
      word = row_to_word(result[0])
    end

    word
  end

  def update(word)
    ensure_connected
    query = "UPDATE words SET type = '#{word.type}', votes = '#{word.vote_str}' WHERE word = '#{quoted(word.to_s)}'"
    @db.exec(query)
  end

end
