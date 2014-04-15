# Suggests a three-letter acronym
class AcronymSuggester

  # Initialize the suggester
  # Takes a list for each letter, or a single list.
  def initialize(*lists)
    @lists = lists
  end

  def suggest_for(acronym)
    suggestion = (0...(acronym.length)).map do |index|
      letter = acronym[index]
      suggest_word(letter, index)
    end
      
    suggestion.join(' ')
  end

  private

  def suggest_word(letter, index)
    list = word_list_for_index(index)
    list
      .select { |word| word.start_with? letter }
      .sample
  end

  def word_list_for_index(index)
    if single_word_list? then @lists.first else @lists[index] end
  end 

  def single_word_list?
    @lists.length == 1
  end

end
