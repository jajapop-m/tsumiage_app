class Post < ApplicationRecord
  belongs_to :user
  mount_uploader :picture, PicturesUploader
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :title, presence:true, length:{ maximum: 50 }
  validates :content, presence: true
  
  def edit_empty_field
    self.content = "by #{self.user.name}" if self.title.present? && self.content.blank?
    self.title = "無題" if self.title.blank?
  end
end
