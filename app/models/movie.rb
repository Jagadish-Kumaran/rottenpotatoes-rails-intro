class Movie < ActiveRecord::Base
    
    def self.all_ratings
        Movie.distinct.pluck(:Rating)
    end  

end
