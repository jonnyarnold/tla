# Container for all votes for a word
class WordScore

  # Scaling factor; if the number of votes
  # is below this number the range in which the
  # score can lie is scaled proportionally
  # to avoid small amounts of votes greatly
  # affecting its score.
  VotesBeforeNoScaling = 10

  # Class constructor
  # Can be initialized with a vote list or +1 and -1's
  def initialize(votes=[])
    raise ArgumentError, "Votes is not iterable: #{votes}" unless votes.respond_to? :each
    @votes = votes
  end

  # Registers an upvote
  def upvote
    @votes.push 1
  end

  # Registers a downvote
  def downvote
    @votes.push -1
  end

  # Gets the total number of registered votes
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

  # Converts the votes into a string of +'s and -'s
  def to_s
    @votes
      .map{ |v| if v > 0 then "+" else "-" end }
      .join
  end

  # Creates a +WordScore+ from a string of +'s and -'s
  def self.from_s(str)
    votes = []
    str.each_char do |c|
      if c == '+'
        votes.push 1
      elsif c == '-'
        votes.push -1
      else
        raise StandardError.new("Invalid character #{c} in voting string #{str}")
      end
    end

    self.new(votes)
  end

end
