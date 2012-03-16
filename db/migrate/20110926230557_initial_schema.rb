class InitialSchema < ActiveRecord::Migration
  def self.up
    create_table "users" do |t|
      t.string "login", :nil => false
      t.string "password"
      t.string "user_name"
      t.string "position"
      t.string "email"
    end
    create_table "task_times" do |t|
      t.string "days", :nil => false
      t.string "project"
      t.string "typetask"
      t.string "description"
      t.string "tasktime"
      t.string "user_id"
    end
    create_table "projects" do |t|
      t.string "name", :nil => false
      t.string "description"
      t.string "model"
      t.string "platform"
    end
  end
  def self.down
    drop_table :users
    drop_table :task_times 
    drop_table :projects
  end
end
