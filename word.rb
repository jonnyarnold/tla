# A word and its associated metadata
class Word < String
  
  # The possible types (word classes) of word.
  Types = [:adjective, :noun, :agent_noun]

  attr_reader :type

  # Creates a word. Type can be specified on creation.
  def initialize(word, type=nil, scoring=nil)
    super word

    raise ArgumentError.new("Type #{type} is not in Word.Types") unless Types.include? type
    @type = type
    @scoring = if scoring.nil? then WordScore.new else scoring end
  end

  def score
    @scoring.score
  end

  def upvote
    @scoring.upvote
  end

  def downvote
    @scoring.downvote
  end

end

# Container for all votes for a word
class WordScore

  VotesBeforeNoScaling = 10

  def initialize(votes=[])
    @votes = votes
  end

  def upvote
    @votes.push 1
  end

  def downvote
    @votes.push -1
  end

  # Returns the likelihood of the word being funny,
  # between 0 and 1
  def score
    # The sum will be between +count and -count.
    # The mean will be between 1 and -1.
    mean = @votes.sum / @votes.count

    # If we normalised now then after 1 vote we'd
    # either have a 0 or 1 for the word. We scale
    # down the allowed range for low-vote words.
    if @votes.count < VotesBeforeNoScaling
      scale_factor = @votes.count / VotesBeforeNoScaling
      mean *= scale_factor
    end

    # Normalise from +1/-1 to 0/1
    score = (mean / 2) + 0.5
  end

end
