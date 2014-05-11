require './config'

# Resets the database
def seed
  require './word_store'
  
  store = Configuration.word_store
  store.reset!

  words = FileWordStore.get_words_from_file(Configuration::InitWordsPath)
  store.add words
end

task :reset do
  seed
end

task :run do
  port = ENV['port'] || 4567
  `ruby server.rb -p #{port}`
end
