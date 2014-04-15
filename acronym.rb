# Suggests a three-letter acronym
class AcronymSuggester

  # A list containing allowed structues for acronyms.
  # For example, if the list was [a, b, c], one possible
  # structure for the acronym would be a word of type a,
  # then one of type b and one of type c.
  AllowedStructures = [
    [:adjective, :noun],
    [:adjective, :agent_noun],
    [:adjective, :noun, :agent_noun],
    [:adjective, :adjective, :noun],
    [:adjective, :adjective, :adjective, :noun]
  ]

  # Initialize the suggester
  # Takes a list of Words
  def initialize(word_list)
    @words = word_list
  end

  # Suggest a definition of the given acronym.
  # The acronym should be in uppercase.
  # The first letters of all words should be in uppercase.
  def suggest_for(acronym)
    structure = valid_structures_for(acronym).sample

    suggestion = (0...(acronym.length)).map do |index|
      letter = acronym[index]
      type = structure[index]
      suggest_word(letter, type)
    end
      
    suggestion.join(' ')
  end

  private

  # Gets structures that could match the given acronym.
  def valid_structures_for(acronym)
    AllowedStructures.select { |s| acronym.length == s.length }
  end

  # Gets a word from the word list
  # starting with the given letter
  # and of the given word type.
  def suggest_word(letter, type)
    @words
      .select { |word| word.start_with?(letter) and word.type == type }
      .sample
  end

end
