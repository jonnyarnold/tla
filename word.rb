# A word and its associated metadata
class Word < String
  
  # The possible types (word classes) of word.
  Types = [:adjective, :noun, :agent_noun]

  attr_reader :type

  # Creates a word. Type can be specified on creation.
  def initialize(word, type=nil)
    super word

    raise ArgumentError.new("Type #{type} is not in Word.Types") unless Types.include? type
    @type = type
  end

end
