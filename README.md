tla
===

Three-Letter Acronym Suggester

Current Usage
-------------

```
http://tla.herokuapp.com/<your_acronym_here>
```

Supports 2, 3 and 4 letters. Sense guaranteed.

Developers
----------
* Go and get Ruby (2.0.0 and above) and PostgreSQL (8.4 and above)
* Pull the repository
* Use ```gem install bundle``` to install bundle, dependency management tool. 
* Use ```bundle install``` to install the required packages
* Create the database 'tla' on PostgreSQL (on Linux, this is the ```createdb``` command.)
* Run ```bundle exec rake run``` to start the development instance

The Words
---------

Words come from Linux's words file, ```/usr/share/dict/words```, using the following regular expressions:
* Adjectives: ```^[a-z](.*)(ous|al|ive|ible|able|ful)$```
* Agent nouns: ```^[a-z](.*)(or|er|ist)$```
* Nouns: ```^[a-z](.*)(ness|ity|ance|ence|tion|sion|ment|ship|hood)$```

They have sinced been hacked away to get rid of incorrectly classed words and 'unfunny' words.

Words are stored in a PostgreSQL repository, because it's free on Heroku. Installation is easy on Linux; Windows is untested.

Scoring
-------

Word scoring is done as follows:
* Individual words have their votes recorded (if the word 'interplay' is considered important, this may need to change)
* A word can get +1 or -1 per vote.
* Scoring is calculated in word.rb, in WordScore.score
