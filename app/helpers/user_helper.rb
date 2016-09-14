module UserHelper
  def gravatar_for user, options = {size: 80}
    gravatar_id = Digest::MD5::hexdigest user.email.downcase
    size = options[size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag gravatar_url, alt: user.name, class: "gravatar"
  end

  def activity_username
    user_name = (@user == current_user) ? "You" : @user.name
    link_to "#{user_name}", @user
  end

  def activity_target target, target_id
    if target.present?
      if target.class.name == "Category"
        link_to target.name, category_path(target)
      elsif target.class.name == "User"
         link_to target.name, user_path(target)
      end
    elsif target_id.present?
      "(has been deleted)"
    end
  end
end
