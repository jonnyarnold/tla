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
* Go and get Ruby (2.0.0 and above)
* Pull the repository
* Use ```gem install bundle``` to install bundle, dependency management tool. 
* Use ```bundle install``` to install the required packages
* Run ```ruby server.rb``` to start the development instance

The Words
---------

Words come from Linux's words file, ```/usr/share/dict/words```, using the following regular expressions:
* Adjectives: ```^[a-z](.*)(ous|al|ive|ible|able|ful)$```
* Agent nouns: ```^[a-z](.*)(or|er|ist)$```
* Nouns: ```^[a-z](.*)(ness|ity|ance|ence|tion|sion|ment|ship|hood)$```
