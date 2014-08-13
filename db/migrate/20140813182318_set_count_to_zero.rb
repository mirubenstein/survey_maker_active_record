class SetCountToZero < ActiveRecord::Migration
  def change
    change_column :choices, :count, :integer, :default => 0
  end
end
