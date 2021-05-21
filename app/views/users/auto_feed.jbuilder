json.microposts do
  json.array! @current_microposts do |micropost|
    json.extract! micropost, :id, :content, :user_id,:created_at
    json.image_url rails_blob_url(micropost.image) if micropost.image.attached?
    gravator_id = Digest::MD5::hexdigest(micropost.user.email)
    gravator_url = "https://secure.gravatar.com/avatar/#{gravator_id}"
    json.gravator_url gravator_url
  end
end
