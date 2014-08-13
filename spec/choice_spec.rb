require 'spec_helper'

describe 'Choice' do
  describe 'pick' do
    it 'selects a choice' do
      choice = Choice.create({:choice => 'A'})
      choice.pick
      choice.pick
      expect(choice.count).to eq 2
    end
  end

  describe 'percent' do
    it 'selects a choice' do
      question1 = Question.create(:question => 'A or B')
      choice1 = Choice.create({:choice => 'A', :question_id => question1.id})
      choice2 = Choice.create({:choice => 'B', :question_id => question1.id})
      choice3 = Choice.create({:choice => 'B'})
      choice1.pick
      choice2.pick
      expect(choice1.percent).to eq 50
    end
  end
end

