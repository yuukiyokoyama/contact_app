class Micropost < ApplicationRecord
  belongs_to       :user
  belongs_to :in_reply_to, class_name: "User", foreign_key: "in_reply_to_id", optional: true
  has_one_attached :image
  default_scope -> { order(created_at: :desc) }
  scope :search_by_keyword, -> (keyword) {
    where("microposts.content LIKE :keyword", keyword: "%#{sanitize_sql_like(keyword)}%") if keyword.present?
  }
  has_many :likes, dependent: :destroy
  has_many :favorite_relationships, dependent: :destroy
  has_many :liked_by, through: :favorite_relationships, source: :user
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validates :image,   content_type: { in: %w[image/jpeg image/gif image/png],
                                      message: "must be a valid image format" },
                      size:         { less_than: 5.megabytes,
                        validates      :content, length: { maximum: 140 }
validates      :content_object, presence: true
                                      message: "should be less than 5MB" }
                                      validates_with ReplyValidator, if: -> { content_object.reply? }

  # 表示用のリサイズ済み画像を返す
  def display_image
    image.variant(resize_to_limit: [500, 500])
  end
end

composed_of :content_object, class_name: "MicropostContent",
mapping: %w(content micropost_content)

before_validation :assign_in_reply_to

before_validation :set_in_reply_to # ここ

validates :user_id, presence: true
validates :content, presence: true, length: {maximum: 140}
validates :in_reply_to, presence: false
validate :picture_size, :reply_to_user # ここ

private

    def assign_in_reply_to
      if content_object.reply?
        self.in_reply_to = User.find_by(id: content_object.reply_name.user_id)
      end
    end

    def self.including_replies(user_id)
      where("user_id = :user_id OR in_reply_to_id = :user_id", user_id: user_id)
    end

      # マイクロポストをいいねする
  def iine(user)
    likes.create(user_id: user.id)
  end

  # マイクロポストのいいねを解除する（ネーミングセンスに対するクレームは受け付けません）
  def uniine(user)
    likes.find_by(user_id: user.id).destroy
  end

  def Micropost.including_replies(id)
    where(in_reply_to: [id, 0]).or(Micropost.where(user_id: id))
end

def set_in_reply_to
  if @index = content.index("@")
    reply_id = []
    while is_i?(content[@index+1])
      @index += 1
      reply_id << content[@index]
    end
    self.in_reply_to = reply_id.join.to_i
  else
    self.in_reply_to = 0
  end
end

def is_i?(s)
  Integer(s) != nil rescue false
end

def reply_to_user
  return if self.in_reply_to == 0 # 1
  unless user = User.find_by(id: self.in_reply_to) # 2
    errors.add(:base, "User ID you specified doesn't exist.")
  else
    if user_id == self.in_reply_to # 3
      errors.add(:base, "You can't reply to yourself.")
    else
      unless reply_to_user_name_correct?(user) # 4
        errors.add(:base, "User ID doesn't match its name.")
      end
    end
  end
end

def reply_to_user_name_correct?(user)
  user_name = user.name.gsub(" ", "-")
  content[@index+2, user_name.length] == user_name
end