class Post < ApplicationRecord
  belongs_to :user
  mount_uploader :picture, PicturesUploader
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :title, length:{ maximum: 50 }, allow_nil: true
  validates :content, presence: true
  validate :time_order

  def edit_empty_field
    self.content = "by #{self.user.name}" if self.title.present? && self.content.blank?
    self.title = "無題" if self.title.blank? && self.content.present?
  end
  
  def time_order
    if started_at && ended_at && started_at > ended_at
      self.errors.add(:post, "終了時間は開始時間より後になるようにしてください。")
    end
  end
  
  def reply(original_post)
    update_attribute(:post_id, original_post.id)
  end
    
end
