class TextProcessor


  @@stop_words = {
    'a': true,
    'about': true,
    'above': true,
    'after': true,
    'again': true,
    'against': true,
    'all': true,
    'am': true,
    'an': true,
    'and': true,
    'any': true,
    'are': true,
    'arent': true,
    'as': true,
    'at': true,
    'be': true,
    'because': true,
    'been': true,
    'before': true,
    'being': true,
    'below': true,
    'between': true,
    'both': true,
    'but': true,
    'by': true,
    'can': true,
    'cant': true,
    'cannot': true,
    'could': true,
    'couldnt': true,
    'did': true,
    'didnt': true,
    'do': true,
    'does': true,
    'doesnt': true,
    'doing': true,
    'dont': true,
    'down': true,
    'during': true,
    'each': true,
    'few': true,
    'for': true,
    'from': true,
    'further': true,
    'had': true,
    'hadnt': true,
    'has': true,
    'hasnt': true,
    'have': true,
    'havent': true,
    'having': true,
    'he': true,
    'hed': true,
    'hell': true,
    'hes': true,
    'her': true,
    'here': true,
    'heres': true,
    'hers': true,
    'herself': true,
    'him': true,
    'himself': true,
    'his': true,
    'how': true,
    'hows': true,
    'i': true,
    'id': true,
    'ill': true,
    'im': true,
    'ive': true,
    'if': true,
    'in': true,
    'into': true,
    'is': true,
    'isnt': true,
    'it': true,
    'its': true,
    'itself': true,
    'lets': true,
    'me': true,
    'more': true,
    'most': true,
    'mustnt': true,
    'my': true,
    'myself': true,
    'no': true,
    'nor': true,
    'not': true,
    'of': true,
    'off': true,
    'on': true,
    'once': true,
    'only': true,
    'or': true,
    'other': true,
    'ought': true,
    'our': true,
    'ours': true,
    'ourselves': true,
    'out': true,
    'over': true,
    'own': true,
    'same': true,
    'shant': true,
    'she': true,
    'shed': true,
    'shell': true,
    'shes': true,
    'should': true,
    'shouldnt': true,
    'so': true,
    'some': true,
    'such': true,
    'than': true,
    'that': true,
    'thats': true,
    'the': true,
    'their': true,
    'theirs': true,
    'them': true,
    'themselves': true,
    'then': true,
    'there': true,
    'theres': true,
    'these': true,
    'they': true,
    'theyd': true,
    'theyll': true,
    'theyre': true,
    'theyve': true,
    'this': true,
    'those': true,
    'through': true,
    'to': true,
    'too': true,
    'under': true,
    'until': true,
    'up': true,
    'very': true,
    'was': true,
    'wasnt': true,
    'we': true,
    'wed': true,
    'well': true,
    'were': true,
    'weve': true,
    'werent': true,
    'what': true,
    'whats': true,
    'when': true,
    'whens': true,
    'where': true,
    'wheres': true,
    'which': true,
    'while': true,
    'who': true,
    'whos': true,
    'whom': true,
    'why': true,
    'whys': true,
    'with': true,
    'wont': true,
    'would': true,
    'wouldnt': true,
    'you': true,
    'youd': true,
    'youll': true,
    'youre': true,
    'youve': true,
    'your': true,
    'yours': true,
    'yourself': true,
    'yourselves': true
  }

  def initialize(text)
    @text = text
    @gram_size = 1
  end

  def remove_punctuation_from(word)
    word.gsub(/\W/, '')
  end
  
  def prep_words_array(text)
    text.split(' ').map {|word| self.remove_punctuation_from(word).downcase }
  end

  def concatenate_words(words_list, start_index)
    concatenated_words = ""
    @gram_size.times do |i| 
      concatenated_words = concatenated_words + words_list[i + start_index] + " "
      # concatenated_words += " " if @gram_size - 1 == i
    end
    concatenated_words.strip
  end

  def is_stop_word?(word)
    @@stop_words.keys.include?(word.to_sym)
  end

  def contains_stop_word?(phrase)
    array_from_phrase = phrase.split(' ')
    !!(array_from_phrase.select { |word| @@stop_words.keys.include?(word.to_sym) }.length > 0)
  end


  def generate_ngrams(ngram_tracker, gram_size, replace_hyphen = false)
    @gram_size = gram_size if gram_size != 1
    text_no_hyphens = @text.gsub(/-|—/, ' ')

    clean_words = (
      replace_hyphen ? self.prep_words_array(text_no_hyphens) : self.prep_words_array(@text)
    )
    ngram_tracker.words_array = clean_words

    self.fill_word_tracker(ngram_tracker)
    ngram_tracker.fill_numerical_tracker
    ngram_tracker
  end

  def fill_word_tracker(tracker)
    if @gram_size == 1
      self.add_unigrams_from_text(tracker)
    else
      # bigrams & trigrams
      self.generate_multiword_grams(tracker)
    end
  end

  def generate_multiword_grams(tracker)
    # words.class => Array
    words = tracker.words_array
    last_array_index = words.length - 1
    index_threshold = @gram_size == 2 ? 0 : 1
    # TO DO: word concatenate method

    words.each_with_index do |word, index|
      ngram = nil
      if last_array_index - index > index_threshold
        ngram = self.concatenate_words(words, index)
      end
      if ngram && !self.contains_stop_word?(ngram)
        tracker.add_gram(ngram)
      end
    end
  end

  # def add_unigrams_from_text(ngram_tracker)
  #   words = ngram_tracker.words_array
  #   tracker = ngram_tracker.tracker

  #   words.each do |word| 
  #     if !self.is_stop_word?(word)
  #       ngram_tracker.add_gram(word)
  #     end
  #   end
  # end

  # def add_bigrams_from_text(ngram_tracker)
  #   last_array_index = ngram_tracker.words_array.length - 1
  #   words = ngram_tracker.words_array
  #   tracker = ngram_tracker.tracker

  #   # words.each_with_index do |word, index|
  #   #   bigram = nil
  #   #   if last_array_index - index > 0
  #   #     bigram = "#{words[index]} #{words[index + 1]}"
  #   #   end
  #   #   if bigram && !self.contains_stop_word?(bigram)
  #   #     ngram_tracker.add_gram(bigram)
  #   #   end
  #   # end
    
  # end

  # def add_trigrams_from_text(ngram_tracker)
  #   last
  # end

  # getters

  def text
    @text
  end

  def gram_size
    @gram_size
  end

  # setters

  def gram_size=(size)
    @gram_size = size
  end


end