require 'pg'                       # PostgreSQL support
require './word_stores/word_store' # Base class
require './logic/word'             # Word class

# Uses PostgreSQL for storing words
class PostgresWordStore < WordStore

  # Class constructor
  # [connection] The connection string for PostgreSQL.
  def initialize(connection)
    super()
    @connection_settings = connection
  end

  # Resets the word store, emptying its contents
  def reset!
    ensure_connected

    @db.exec("DROP TABLE IF EXISTS words")
    @db.exec("CREATE TABLE IF NOT EXISTS words ( word varchar(50), type varchar(20), votes text )")
  end

  # Adds the given word to the store.
  def add(word)
    ensure_connected

    # Build an INSERT query
    query = "INSERT INTO words (word, type, votes) VALUES "

    values = []
    if word.respond_to? :each
      word.each { |w| values.push word_to_insert_entry(w) }
    else
      values.push word_to_insert_entry(word)
    end
    query += values.join(", ")

    @db.exec(query)
  end

  # Gets a word.
  # Note that this is a default implementation
  # based on @words being in existence.
  def get_word(starting_letter=nil, word_type=nil)
    ensure_connected

    # Build SELECT query
    filtered_words_query = "SELECT * FROM words"
    conditions = []
    conditions.push "word LIKE '#{starting_letter}%'" unless starting_letter.nil?
    conditions.push "type = '#{word_type}'" unless word_type.nil?
    unless conditions.empty?
      filtered_words_query += " WHERE "
      filtered_words_query += conditions.join(" AND ")
    end

    # Execute query and convert rows to +Word+s.
    words = []
    @db.exec(filtered_words_query) do |result|
      result.each { |row| words << row_to_word(row) }
    end

    pick_word(words)
  end

  # Upvotes a word in the store.
  # Note that in client applications this should be 
  # used instead of +Word.upvote+, as this is persisted
  # to the store.
  def upvote(word)
    word = find_word(word) if word.instance_of? String
    word.upvote
    update(word)
  end

  # Downvotes a word in the store.
  # Note that in client applications this should be 
  # used instead of +Word.downvote+, as this is persisted
  # to the store.
  def downvote(word)
    word = find_word(word) if word.instance_of? String
    word.downvote
    update(word)
  end

  private

  # Connects to the database if not already done.
  def ensure_connected
    @db = PG.connect(@connection_settings) if @db.nil?
  end

  # Converts a row (technically a Hash) into a Word object.
  def row_to_word(row)
    score = if row['votes'].empty? then nil else WordScore.from_s(row['votes']) end
    word = Word.new(row['word'], row['type'].to_sym, score)
    word
  end

  # Converts a +Word+ into a SQL INSERT row.
  def word_to_insert_entry(word)
    "('#{quoted(word.to_s)}', '#{word.type}', '#{word.vote_str}')"
  end

  # Quotes a word to ensure apostrophes can be sent to PostgreSQL.
  def quoted(word)
    word.gsub("'", "\\'")
  end

  # Converts a word string into a +Word+ object.
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

  # Updates the given +Word+ object in the store.
  def update(word)
    ensure_connected
    query = "UPDATE words SET type = '#{word.type}', votes = '#{word.vote_str}' WHERE word = '#{quoted(word.to_s)}'"
    @db.exec(query)
  end

end
