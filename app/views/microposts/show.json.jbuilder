json.set! :micropost do
  json.extract! @micropost, :id, :content, :user_id,:created_at
  json.image_url @image_url
end
