class Relationship < ApplicationRecord
  belongs_to :following, class_name: "User"
  belongs_to :followed, class_name: "User"
  validates :following, presence: true
  validates :followed,  presence: true
end
