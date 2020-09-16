class Movie < ActiveRecord::Base

  # Part2 BEGIN
  def self.get_all_ratings
    return self.pluck(:rating).uniq
  end

  def self.with_ratings(ratings)
    return self.where(rating: ratings)
  end
  # Part2 END
  
  # Part3 BEGIN
  def self.with_ratings_sort(ratings, sort_by)
    return self.where(rating: ratings).order(sort_by)
  end
  # Part3 END
end
