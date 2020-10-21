class Talk < ApplicationRecord
  has_many :memberships, dependent: :destroy
  has_many :members, class_name: "User" ,throuth: :memberships,, source: :User
  has_messages :messages, dependet: :destroy
end