class CreateTasks < ActiveRecord::Migration
  def self.up
    create_table :tasks do |t|
      t.string :description
      t.boolean :completed, :default => false
      t.integer :position
      t.integer :created_by_id
      t.integer :assigned_to_id

      t.timestamps
    end
    add_index :tasks, :created_by_id
    add_index :tasks, :assigned_to_id
  end

  def self.down
    drop_table :tasks
  end
end
