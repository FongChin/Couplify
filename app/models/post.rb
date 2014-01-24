class Post < ActiveRecord::Base
  attr_accessible :body, :couple_id, :image, :user_id
  
  validates :user_id, :couple_id, :presence => true
  
  belongs_to :couple
  belongs_to :owner, :class_name => "User"
  
  has_attached_file :image, :styles => { 
    :medium => "500x500>"
  }, :source_file_options =>  {:all => '-auto-orient'}
  
  def image_url
    (self.image_file_name.nil?) ? nil : self.image.url
  end
  
  def to_json
    p "to_json is called"
    super(:methods => [:image_url])
  end
end
