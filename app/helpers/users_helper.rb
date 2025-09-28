module UsersHelper
  def gravator_for(user, options = { size: 80 })
    size = options[:size]
    gravator_id = Digest::MD5.hexdigest(user.email.downcase)
    gravator_url = "https://secure.gravatar.com/avatar/#{gravator_id}?s=#{size}"
    image_tag gravator_url, atl: user.name, class: "avator"
  end
end
