class ApplicationController < ActionController::API

  def gravator_for(user)
    gravator_id = Digest::MD5::hexdigest(user.email)
    gravator_url = "https://secure.gravatar.com/avatar/#{gravator_id}"
    gravator_url
  end

  #JWTでuserIDをtoken化させる
  def encode_token(payload)
    JWT.encode(payload,'s3cr3t')
  end

  def auth_header
    #{Authorization: 'Bearer <token>'}
    request.headers['Authorization']
  end

  def decoded_token
    if auth_header
      token = auth_header.split(' ')[1]
      #Header: {Authorization: 'Bearer <token>'}
      begin
        JWT.decode(token, 's3cr3t', true, algorothm: 'HS256')
      rescue JWT::DecodeError
        nil
      end
    end
  end

  def logged_in_user
    if decoded_token
      user_id = decoded_token[0]['user_id']
      @current_user = User.find(user_id)
    end
  end

  def logged_in?
    !!logged_in_user
  end
#authorizedをpassすることで、@current_userが設定される
  def authorized
    render json: { message: 'Please log in'}, status: :unauthorized unless logged_in?
  end

end
