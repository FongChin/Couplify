class Message < ActiveRecord::Base
  attr_accessible :body, :couple_id, :image_url, :user_id
  
  validates :user_id, :couple_id, :presence => true
  
  belongs_to :couple
  belongs_to :owner
  
  has_attached_file :image, :styles => {
    :big => "600x600>",
    :small => "100x100#"
  }
end
