require 'sinatra'
require './acronym'

set :static_cache_control, [:public, max_age: 60 * 60 * 24]

suggester = AcronymSuggester.new(
  File.readlines('adjectives.txt'),
  File.readlines('nouns.txt'),
  File.readlines('agent_nouns.txt')
)

get '/' do
  haml :index
end

get '/:acronym' do
  suggester.suggest_for(params[:acronym].upcase)
end
