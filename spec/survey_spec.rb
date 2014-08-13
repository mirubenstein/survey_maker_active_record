require 'spec_helper'

describe 'Survey' do
  it 'has an array of choices' do
    test_survey = Survey.create({:name => 'Survey'})
    test_question = Question.create({:question => 'Whats your name', :survey_id => test_survey.id})
    choice_1 = Choice.create({:choice => 'A', :question_id => test_question.id})
    choice_2 = Choice.create({:choice => 'B', :question_id => test_question.id})
    choice_3 = Choice.create({:choice => 'C', :question_id => test_question.id})
    expect(test_survey.choices).to eq [choice_1, choice_2, choice_3]
  end
end
