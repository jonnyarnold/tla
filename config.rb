# Contains configuration settings for each environment
module Configuration

  # The possible environments given in this configuration
  Environments = [:dev, :heroku]

  # Gets the current environment.
  # 
  # This checks the environment variable ENVIRONMENT.
  # The method defaults to :dev if not environment variable is set.
  # Raises an error if the current environment is unknown.
  def self.environment
    env = ENV['ENVIRONMENT'] || 'dev'
    env_sym = env.to_sym
    raise StandardError, "Unexpected environment #{env_sym}" unless Environments.include? env_sym
    env_sym
  end

  # Gets a configured +WordStore+ for the current environment.
  def self.word_store
    require './word_stores/postgres_word_store'

    case environment
    when :dev
      PostgresWordStore.new(dbname: 'tla')
    when :heroku
      PostgresWordStore.new(explode_postgres_url(ENV['DATABASE_URL']))
    end
  end

  # Gets the path to the file containing the initial words
  # to populate a database with.
  def self.initial_words_path
    "words.txt"
  end

  private

  def self.explode_postgres_url(url)
    url_decoder = %r{^postgres://(?<user>[^:]*):(?<pass>[^@]*)@(?<host>[^:]*):(?<port>[^/]*)/(?<dbname>.*)$}
    matches = url.match(url_decoder)
    {
      dbname: matches['dbname'],
      host: matches['host'],
      port: matches['port'],
      user: matches['user'],
      password: matches['pass']
    }
  end

end
