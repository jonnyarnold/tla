require './config'

# Resets the database
def seed  
  store = Configuration.word_store
  store.reset!

  require './word_stores/file_word_store'
  words = FileWordStore.get_words_from_file(Configuration.initial_words_path)
  store.add words
end

task :reset do
  seed
end

task :run do
  port = ENV['port'] || 4567
  `ruby server.rb -p #{port}`
end
