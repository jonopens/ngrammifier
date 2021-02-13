class NgramTracker

  def initialize
    @tracker = {}
    @numerical_tracker = {}
    @words_array = []
  end

  def self.stop_words
    @@stop_words
  end

  # getters
  
  def tracker
    @tracker
  end  

  def num_tracker
    @numerical_tracker
  end 

  def words_array
    @words_array
  end 

  # setters

  def words_array=(array)
    @words_array = array
  end

  def add_gram(gram)
    @tracker[gram] ? @tracker[gram] += 1 : @tracker[gram] = 1
  end

  def fill_numerical_tracker
    num_keys = @tracker.values.uniq # get unique number values/counts of across all words

    num_keys.each { |k| @numerical_tracker[k] = [] } # set an empty array for each unique value

    @tracker.keys.map do |key|
      num_key = @tracker[key]
      @numerical_tracker[num_key] << key
    end
  end

  # computed values

  def sort_tracker
    @tracker.sort_by { |key, val| -val }.to_h
  end

  def most_used_words
    @numerical_tracker[@numerical_tracker.keys.max]
  end

end
