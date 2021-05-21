json.extract! @user, :id, :name, :email,:created_at
json.gravator_url @gravator_url
json.following_count @following_count
json.followers_count @followers_count
json.microposts do
  json.array! @microposts do |micropost|
    json.extract! micropost, :id, :content, :user_id,:created_at,:updated_at
    json.image_url rails_blob_url(micropost.image) if micropost.image.attached?
  end
end
