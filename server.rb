require 'sinatra'
require './acronym'
require './word'
require './word_store'

set :static_cache_control, [:public, max_age: 60 * 60 * 24]

suggester = AcronymSuggester.new(MarshalWordStore.new('marshal_word_store'))

get '/' do
  content_type 'html'
  erb :index
end

get %r{/([A-Za-z]{2,4})$} do |acronym|
  suggester.suggest_for(acronym.upcase)
end
