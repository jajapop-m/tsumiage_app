module UsersHelper
  def set_default_icon
    unless User.image_name?
      self.image_name = 'user_icon.png'
    end
  end
end
