task :resetdb do
  require './word'
  require './word_store'

  marshal_file = "marshal_word_store"
  File.delete marshal_file if File.exists? marshal_file

  words = FileWordStore.get_words_from_file("words.txt")
  mws = MarshalWordStore.new(marshal_file)
  mws.add words
end
