class AddSourceToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :source, :string
  end
end
