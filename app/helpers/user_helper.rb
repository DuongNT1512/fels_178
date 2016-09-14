module UserHelper
  def gravatar_for user, options = {size: 80}
    gravatar_id = Digest::MD5::hexdigest user.email.downcase
    size = options[size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag gravatar_url, alt: user.name, class: "gravatar"
  end

  def content activity_type
    case activity_type
    when "login"
      @user.name + t("activity.login")
    when "logout"
      @user.name + t("activity.logout")
    when "following"
      @user.name + t("activity.following")
    when "learned"
      @user.name + t("activity.learned")
    end
  end
end
