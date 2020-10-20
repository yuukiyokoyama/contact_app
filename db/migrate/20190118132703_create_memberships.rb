class CreateMemberships < ActiveRecord::Migration[5.1]
  def change 
    create_table :menberships do |t|
      t.refarences :talk, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :memberships, [:user_id, :talk_id], unique: true
  end
end
