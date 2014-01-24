class Post < ActiveRecord::Base
  attr_accessible :body, :couple_id, :image, :user_id
  
  validates :user_id, :couple_id, :presence => true
  
  belongs_to :couple
  belongs_to :owner, :class_name => "User"
  
  has_attached_file :image, 
                    :styles => { :medium => "500x500>" }, 
                    :processors => [:no_rotation]
  
  def image_url
    (self.image_file_name.nil?) ? nil : self.image.url
  end

  def include_image_link_json
    self.to_json(:methods => [:image_url]).html_safe
  end
end
