class Survey < ActiveRecord::Base
  has_many :questions
  has_many :choices, :through => :questions
end
