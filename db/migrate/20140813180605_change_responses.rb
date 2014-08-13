class ChangeResponses < ActiveRecord::Migration
  def change
    remove_column :responses, :survey_id, :integer
    remove_column :responses, :question_id, :integer
  end
end
