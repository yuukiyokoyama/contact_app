class AddInReplyToToMicroposts < ActiveRecord::Migration[6.0]
  def change
    add_column :microposts, :in_reply_to, :integer
  end
end
