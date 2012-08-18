class AddIndexToUsersEmail < ActiveRecord::Migration
  def change
  	add_index :users, :email, uniquie: true
  end
end
