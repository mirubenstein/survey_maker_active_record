require 'active_record'
require './lib/choice'
require './lib/question'
require './lib/survey'

database_configurations = YAML::load(File.open('./db/config.yml'))
development_configuration = database_configurations['development']
ActiveRecord::Base.establish_connection(development_configuration)

def login
  choice = 0
  until choice == 3
    puts "Welcome to the Survey Program!"
    puts "1) Take a survey"
    puts "2) Survey designers"
    puts "3) Exit"
    choice = gets.chomp.to_i
    case choice
    when 1
      take_survey
    when 2
      designers_menu
    else
      "Enter a valid option"
    end
  end
end

def designers_menu
  puts "1) Create a new survey"
  puts "2) List surveys"
  puts "3) View survey results"
  case gets.chomp.to_i
    when 1 then create_survey
    when 2 then Survey.all.each { |survey| puts survey.name }
    when 3 then view_results
  end
  designers_menu
end

def create_survey
  puts "Enter the name of the survey"
  @current_survey = Survey.new(name: gets.chomp)
  validate_new(@current_survey)
  survey_menu
end

def validate_new(new_object)
  if new_object.save
    puts "#{new_object.class} created!"
  else
    puts "That wasn't a valid #{new_object.class.downcase}:"
    new_object.errors.full_messages.each {|message| puts message}
  end
end

def list_survey
  Survey.all.each { |survey| puts "'#{survey.id}') #{survey.name} " }
end

def survey_menu
  puts "1) Add a question"
  puts "2) Add a choice"
  puts "10) Return to designers menu"
  case gets.chomp.to_i
    when 1 then new_question
    when 2 then new_choice
    when 10 then designers_menu
  end
  survey_menu
end

def new_question
  puts "Enter the question"
  @new_question = @current_survey.questions.new(question: gets.chomp)
  validate_new(@new_question)
end

def take_survey
  list_survey
  puts "Enter the number of the survey you'd like to take"
  @current_survey = Survey.find(gets.chomp.to_i)
  @current_survey.questions.each do |question|
    system('clear')
    puts question.question
    question.choices.each do |choice|
      puts choice.id.to_s + ") " + choice.choice
    end
    puts "Enter the number of your response"
    Choice.find(gets.chomp.to_i).pick
  end
  login
end

def new_choice
  puts "Enter the choice"
  new_choice = @new_question.choices.new(choice: gets.chomp)
  validate_new(new_choice)
end

def view_results
  list_survey
  puts "Enter the number of the survey you'd like to view"
  @current_survey = Survey.find(gets.chomp.to_i)
  system('clear')
  puts @current_survey.name + " Results"
  @current_survey.questions.each do |question|
    puts question.question
    question.choices.each do |choice|
      puts choice.count.to_s + "\t" + choice.percent.to_s + "%\t" + choice.choice
    end
  end
end

login
