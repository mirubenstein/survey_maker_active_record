class CreateOpenEndedResponses < ActiveRecord::Migration
  def change
    create_table :responses do |t|
      t.string :response
      t.belongs_to :question

      t.timestamp
    end
  end
end
