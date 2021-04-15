class ApplicationController < ActionController::API
  #JWTでuserIDをtoken化させる
  def encode_token(payload)
    JWT.encode(payload,'s3cr3t')
  end

end
