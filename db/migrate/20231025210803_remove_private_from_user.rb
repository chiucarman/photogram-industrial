class RemovePrivateFromUser < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :private, :boolean
  end
end
