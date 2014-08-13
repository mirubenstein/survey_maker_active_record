require 'rspec'
require 'active_record'
require 'choice'
require 'question'
require 'survey'

database_configurations = YAML::load(File.open('./db/config.yml'))
test_configuration = database_configurations['test']
ActiveRecord::Base.establish_connection(test_configuration)


RSpec.configure do |config|
  config.before(:each) do
    Choice.all.each { |choice| choice.destroy }
    Question.all.each { |question| question.destroy }
    Survey.all.each { |survey| survey.destroy }
  end
end
