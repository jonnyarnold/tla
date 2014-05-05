require 'sinatra'
require './acronym'
require './word'
require './word_store'

set :static_cache_control, [:public, max_age: 60 * 60 * 24]

suggester = AcronymSuggester.new(FileWordStore.new('words.txt'))

get '/' do
  content_type 'html'
  erb :index
end

get %r{/([A-Za-z]{2,4})$} do |acronym|
  suggester.suggest_for(acronym.upcase)
end
