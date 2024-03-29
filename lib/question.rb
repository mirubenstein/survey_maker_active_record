class Question < ActiveRecord::Base
  validates :question, :presence => true, :uniqueness => true

  belongs_to :survey
  has_many :choices
  has_many :responses
end
