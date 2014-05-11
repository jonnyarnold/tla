require './config'

# Resets the database
def seed
  require './word'
  require './word_store'

  marshal_file = Configuration::WordStorePath
  File.delete marshal_file if File.exists? marshal_file

  words = FileWordStore.get_words_from_file(Configuration::InitWordsPath)
  mws = MarshalWordStore.new(marshal_file)
  mws.add words
end

task :reset do
  seed
end

task :run do
  seed unless File.exists? Configuration::WordStorePath
  port = ENV['port'] || 4567
  `ruby server.rb -p #{port}`
end
