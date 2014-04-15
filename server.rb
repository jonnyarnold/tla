require 'sinatra'
require './acronym'
require './word'

set :static_cache_control, [:public, max_age: 60 * 60 * 24]

suggester = AcronymSuggester.new(
  Word.load_from_file('words.txt')
)

get '/' do
  haml :index
end

get '/:acronym' do
  suggester.suggest_for(params[:acronym].upcase)
end
