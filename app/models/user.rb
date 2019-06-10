class User < ApplicationRecord
	validates_presence_of :nickname
	# validates :email, uniqueness: true

	def self.age(date)
	  date_f = date.to_date
	  now = Time.now.utc.to_date
	  now.year - date_f.year - ((now.month > date_f.month || (now.month == date_f.month && now.day >= date_f.day)) ? 0 : 1)
	end
end
