class Post < ApplicationRecord
  belongs_to :user
  attr_accessor :date
  mount_uploader :picture, PicturesUploader
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :title, presence:true, length:{ maximum: 50 }
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
    
end
