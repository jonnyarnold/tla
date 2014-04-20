require 'sinatra'
require 'json'
require './acronym'
require './word'

set :static_cache_control, [:public, max_age: 60 * 60 * 24]

suggester = AcronymSuggester.new(Word.load_from_file('words.txt'))
Version = `git rev-parse --short HEAD`.chomp

get '/' do
  content_type 'html'
  erb :index
end

get %r{/([A-Za-z]{2,4})$} do |acronym|
  suggestion = suggester.suggest_for(acronym.upcase)
  {:acronym => acronym, :suggestion => suggestion}.to_json
end
