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