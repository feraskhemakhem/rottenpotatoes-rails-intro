class Movie < ActiveRecord::Base
    # reference: https://guides.rubyonrails.org/active_record_querying.html#selecting-specific-fields
    # another reference: https://stackoverflow.com/questions/9658881/rails-select-unique-values-from-a-column
    def self.ratings
        Movie.distinct.pluck(:rating)
    end
end
