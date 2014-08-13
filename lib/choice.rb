class Choice < ActiveRecord::Base
  belongs_to :question

  def pick
    self.update(count: self.count + 1)
  end

  def percent
    total = 0.0
    self.question.choices.each do |choice|
      total += choice.count
    end
    self.count/total * 100
  end
end
