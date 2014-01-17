class Message < ActiveRecord::Base
  attr_accessible :body, :couple_id, :image
  
  belongs_to :couple
  
  has_attached_file :image, :styles => {
    :big => "600x600>",
    :small => "100x100#"
  }
end
