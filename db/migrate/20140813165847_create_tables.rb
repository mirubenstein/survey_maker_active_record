class CreateTables < ActiveRecord::Migration
  def change
    create_table :surveys do |t|
      t.column :name, :string
      t.timestamps
    end

    create_table :questions do |t|
      t.belongs_to :survey
      t.column :question, :string
      t.timestamps
    end

    create_table :choices do |t|
      t.belongs_to :question
      t.column :choice, :string
      t.timestamps
    end

    create_table :responses do |t|
      t.belongs_to :survey
      t.belongs_to :question
      t.belongs_to :choice
      t.timestamps
    end
  end
end
