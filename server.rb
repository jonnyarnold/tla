require 'sinatra'
require './acronym'
require './word'
require './word_store'

set :static_cache_control, [:public, max_age: 60 * 60 * 24]

words = MarshalWordStore.new('marshal_word_store')
suggester = AcronymSuggester.new(words)

get '/' do
  content_type 'html'
  erb :index
end

get "/ranking" do
  @top = words.top
  @bottom = words.bottom
  erb :ranking
end

get %r{/([A-Za-z]{2,4})$} do |acronym|
  suggester.suggest_for(acronym.upcase)
end

post "/+1/:phrase" do
  suggester.upvote(params[:phrase])
end

post "/-1/:phrase" do
  suggester.downvote(params[:phrase])
end
