class Runner

  # add runner options
  # - gram size
  # - remove hyphens/dashes

  def self.run
    user_text = self.get_text_from_user
    grams = self.manage_input(user_text)
    self.print_results(grams)
  end

  def self.get_text_from_user
    puts "Please enter the text you'd like to analyze."
    user_text = gets.chomp
  end

  def self.manage_input(text)
    ngrams = NgramTracker.new
    processor = TextProcessor.new(text)

    processor.generate_ngrams(ngrams, 2, true)
  end

  def self.print_results(ngrams)
    gram_type = "bigrams"
    word_or_phrase = "phrase"
    # # if !!ngrams.gram_size
    # #   word_or_phrase = ngrams.gram_size > 1 ? "phrase" : "word or words"
    # # end

    # case ngrams.gram_size
    # when 3
    #   gram_type = "trigrams"
    # when 2
    #   gram_type = "bigrams"
    # else
    #   gram_type = "bigrams"
    # end

    puts "The results of the #{gram_type} analysis are as follows:\n\n"

    ngrams.tracker.keys.each do |gram|
      puts "#{gram} has appeared #{ngrams.tracker[gram]} times."
    end

    puts "The most frequently used #{word_or_phrase} in the body of text you provided is #{ngrams.most_used_words}. Anticlimactic, really."
  end
end