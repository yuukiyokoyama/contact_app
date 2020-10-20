class Membership < ApplicationRecord
  belongs_to :talk
  belongs_to :user

  validates :user_id, uniquenss: {scope: :talk_id}
end