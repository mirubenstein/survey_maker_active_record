class Question < ActiveRecord::Base
  validates :question, :presence => true

  belongs_to :survey
  has_many :choices
end
