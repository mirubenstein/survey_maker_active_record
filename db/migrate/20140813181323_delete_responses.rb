class DeleteResponses < ActiveRecord::Migration
  def change
    drop_table :responses

    add_column :choices, :count, :integer
  end
end
