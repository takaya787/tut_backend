json.set! :micropost do
  json.extract! @micropost, :id, :content, :user_id, :created_at
  json.image_url rails_blob_url(@micropost.image) if @micropost.image.attached?
  json.liked @micropost.likes.count
end
json.set! :user do
  json.extract! @user, :name, :id
  json.gravator_url @gravator_url
end
