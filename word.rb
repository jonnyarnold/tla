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

  def votes
    @scoring.votes
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

  def votes
    @votes.count
  end

  # Returns the likelihood of the word being funny,
  # between 0 and 1
  def score
    # The sum will be between +count and -count.
    # The mean will be between 1 and -1.
    mean = if @votes.empty? then 0.0 else @votes.reduce(0.0, :+).to_f / @votes.count end

    # If we normalised now then after 1 vote we'd
    # either have a 0 or 1 for the word. We scale
    # down the allowed range for low-vote words.
    if 0 < @votes.count and @votes.count < VotesBeforeNoScaling
      scale_factor = @votes.count.to_f / VotesBeforeNoScaling
      mean *= scale_factor
    end

    # Normalise from +1/-1 to 0/1
    score = (mean / 2.0) + 0.5
    score
  end

end
