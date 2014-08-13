require 'active_record'
require './lib/choice'
require './lib/question'
require './lib/survey'
require './lib/response'


database_configurations = YAML::load(File.open('./db/config.yml'))
development_configuration = database_configurations['development']
ActiveRecord::Base.establish_connection(development_configuration)
# database_configurations.i18n.enforce_available_locales = true


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
  puts "2) Edit survey"
  puts "3) List surveys"
  puts "4) View survey results"
  case gets.chomp.to_i
    when 1 then create_survey
    when 2 then edit_survey
    when 3 then Survey.all.each { |survey| puts survey.name }
    when 4 then view_results
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
    puts "That wasn't a valid entry:"
    new_object.errors.full_messages.each {|message| puts message}
  end
end

def validate_question_update(existing_object, input)
  if existing_object.update(question: input)
    puts "#{existing_object.class} updated!"
  else
    puts "That wasn't a valid entry:"
    existing_object.errors.full_messages.each {|message| puts message}
  end
end

def list_survey
  Survey.all.each { |survey| puts "#{survey.id}) #{survey.name} " }
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

def question_type
  puts "Is this question:"
  puts "1) Multiple choice"
  puts "2) Multiple choice with an other/write-in option"
  puts "3) Text response"
  @other = false
  @text = false
  case gets.chomp.to_i
  when 2 then @other = true
  when 3 then @text = true
  end
end

def new_question
  question_type
  puts "Enter the question"
  @new_question = @current_survey.questions.new(question: gets.chomp, text: @text, other: @other)
  validate_new(@new_question)
end

def take_survey
  list_survey
  puts "Enter the number of the survey you'd like to take"
  survey_id = gets.chomp.to_i
  if Survey.exists?(survey_id)
    @current_survey = Survey.find(survey_id)
    @current_survey.questions.each do |question|
      system('clear')
      puts question.question
      if question.text
        text_choice(question)
      elsif question.other
        other_choice(question)
      else
        multiple_choice(question)
      end
    end
  else
    puts "Not a valid entry please try again."
    take_survey
  end
  login
end

def text_choice question
  puts "Enter your response."
  new_response = question.responses.new(response: gets.chomp)
  validate_new(new_response)
end

def other_choice question
  question.choices.each do |choice|
    puts choice.id.to_s + ") " + choice.choice
  end
  puts "Enter the number of your response or 0 if other"
  choice = gets.chomp.to_i
  if choice == 0
    puts "Enter your response."
    new_response = question.responses.new(response: gets.chomp)
    validate_new(new_response)
  else
    Choice.find(choice).pick
  end
end

def multiple_choice question
  more = 1
  until more == 0
    question.choices.each do |choice|
      puts choice.id.to_s + ") " + choice.choice
    end
    puts "Enter the number of your response or 0 if done"
    more = gets.chomp.to_i
    Choice.find(more).pick if more != 0
   end
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
    if question.text || question.other
      question.responses.each {|response| puts response.response}
    end
  end
end

def edit_survey
  list_survey
  puts "Enter the number of the survey you'd like to edit"
  @current_survey = Survey.find(gets.chomp.to_i)
  puts "1) Add new question"
  puts "2) Edit question wording"
  puts "3) Add a new choice for an existing question"
  puts "4) Remove a choice for an existing question"
  puts "5) Designers menu"
  case gets.chomp.to_i
  when 1 then new_question
  when 2 then edit_question_wording
  when 3 then add_a_choice
  when 4 then remove_a_choice
  when 5 then designers_menu
  end
  edit_survey
end

def edit_question_wording
  select_question
  puts "What would you like the updated question to say?"
  input = gets.chomp
  validate_question_update(@new_question, input)
end

def select_question
  @current_survey.questions.each do |question|
    puts question.id.to_s + ") " + question.question
  end
  puts "Enter the number of the question you'd like to edit"
  @new_question = Question.find(gets.chomp.to_i)
end

def add_a_choice
  select_question
  puts "What is the new choice for this question?"
  new_choice = @new_question.choices.new(choice: gets.chomp)
  validate_new(new_choice)
end

def remove_a_choice
  select_question
  @new_question.choices.each do |choice|
    puts choice.id.to_s + ") " + choice.choice
  end
  puts "Enter the choice number to delete"
  Choice.find(gets.chomp.to_i).destroy
end

login
