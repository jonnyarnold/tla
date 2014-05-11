# Web server for TLA

require 'sinatra'         # Web server
require './config'        # Configuration and configured objects
require './logic/acronym' # Acronym suggestion logic

# Ensure static files are cached
set :static_cache_control, [:public, max_age: 60 * 60 * 24]

# Setup the word store and suggestion objects
words = Configuration.word_store
suggester = AcronymSuggester.new(words)

# Main page
get '/' do
  content_type 'html'
  erb :index
end

# Word ranking page
get "/ranking" do
  @top = words.top
  @bottom = words.bottom
  erb :ranking
end

# Acronym suggestion
# Returns a suggestion in plain text
get %r{/([A-Za-z]{2,4})$} do |acronym|
  suggester.suggest_for(acronym.upcase)
end

# Register an upvote for the given phrase
post "/+1/:phrase" do
  suggester.upvote(params[:phrase])
end

# Register a downvote for the given phrase
post "/-1/:phrase" do
  suggester.downvote(params[:phrase])
end
