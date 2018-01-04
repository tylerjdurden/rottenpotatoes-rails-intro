class Movie < ActiveRecord::Base
	def self.unique_ratings
		self.uniq.pluck(:rating).sort
	end
end
