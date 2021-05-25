class Micropost < ApplicationRecord
  belongs_to :user, dependent: :destroy
  scope :recent_posts, ->{order created_at: :desc}
  has_one_attached :image
  validates :content, presence: true,
              length: {maximum: Settings.users.micropost.max_length}
  validates :image, content_type: {in: %w(image/jpeg image/gif image/png),
                                   message: I18n.t("micropost.image_format")},
                    size:         {less_than: Settings.image.max.megabytes,
                                   message: I18n.t("micropost.less_than_5MB")}

  def display_image
    image.variant resize_to_limit: [500, 500]
  end
end
