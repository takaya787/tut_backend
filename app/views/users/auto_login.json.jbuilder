json.user do
  json.extract! @current_user, :id, :name, :email,:created_at,:activated,:activated_at
  json.gravator_url @gravator_url
  # ここからpost情報
  json.microposts do
    json.array! @current_microposts do |micropost|
      json.extract! micropost, :id, :content, :user_id,:created_at,:updated_at
      json.image_url rails_blob_url(micropost.image) if micropost.image.attached?
    end
  end
end
