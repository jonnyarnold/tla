require './logic/word_score'

# A word and its associated metadata
class Word < String
  
  # The possible types (word classes) of word.
  Types = [:adjective, :noun, :agent_noun]

  attr_reader :type

  # Creates a word. 
  # 
  # [word] The word string.
  # [type] The class of word. This must belong to the list of types defined in +Word::Types+.
  # [scoring] A +WordScore+ for the word.
  def initialize(word, type=nil, scoring=nil)
    super word

    raise ArgumentError.new("Type #{type} is not in Word.Types") unless Types.include? type
    @type = type

    if scoring.nil?
      @scoring = WordScore.new
    elsif scoring.is_a? WordScore
      @scoring = scoring
    else
      raise StandardError.new("Invalid scoring argument: #{scoring}")
    end
  end

  # Gets the score for the word.
  def score
    @scoring.score
  end

  # Registers an upvote for the word.
  def upvote
    @scoring.upvote
  end

  # Registers a downvote for the word.
  def downvote
    @scoring.downvote
  end

  # Gets the number of votes registered for this word.
  def votes
    @scoring.votes
  end 

  # Gets the string representation of the word's voting.
  def vote_str
    @scoring.to_s
  end

end
