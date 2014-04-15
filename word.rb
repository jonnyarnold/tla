# A word and its associated metadata
class Word < String
  
  # The possible types (word classes) of word.
  Types = [:adjective, :noun, :agent_noun]

  attr_reader :type

  def initialize(word, type=nil)
    super word

    raise ArgumentError.new("Type #{type} is not in Word.Types") unless Types.include? type
    @type = type
  end

  # Grabs all the words from a file and
  # converts them to Words
  def self.load_from_file(file_path)
    type = nil
    File.readlines(file_path).map do |line|
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
