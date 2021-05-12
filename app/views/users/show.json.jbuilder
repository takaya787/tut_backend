# json.array! @users do |user|
#   json.extract! user, :id, :name, :email
#   gravator_id = Digest::MD5::hexdigest(user.email)
#   gravator_url = "https://secure.gravatar.com/avatar/#{gravator_id}"
#   json.gravator_url gravator_url
# end
# {user: {cloumns: value}}


json.set! :user do
  json.extract! @user, :id, :name, :email,:created_at
  json.gravator_url @gravator_url
  json.microposts do
    json.array! @microposts do |micropost|
      json.extract! micropost, :id, :content, :user_id,:created_at,:updated_at
      json.image_url rails_blob_url(micropost.image) if micropost.image.attached?
    end
  end
end
