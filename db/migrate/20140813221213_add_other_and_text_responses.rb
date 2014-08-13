class AddOtherAndTextResponses < ActiveRecord::Migration
  def change
    add_column :questions, :text, :boolean, :default => false

    add_column :questions, :other, :boolean, :default => false
  end
end
