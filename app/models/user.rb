class User < ApplicationRecord
  attr_accessor :activation_token,:reset_token
  before_save{ self.email.downcase!}
  before_create :create_activation_digest

  validates(:name,presence:true,length:{maximum: 50})
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates(:email,presence:true,length:{maximum: 255},format:{with: VALID_EMAIL_REGEX},uniqueness:{case_sensitive: false})
  validates(:password,presence:true,length:{minimum:6}, allow_nil: true)
  #security code
  has_secure_password

   # 渡された文字列のハッシュ値を返す
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST:
    BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # 渡したTokenが保存されているdigestと等しいかを検証
  def authenticated?(attribute, token)
    digest = self.send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # アカウントを有効にする
  def activate
    update_columns(activated: true,activated_at: Time.zone.now)
  end

  # 有効化用のメールを送信する
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # パスワード再設定の属性を設定する
  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest: User.digest(reset_token),reset_sent_at: Time.zone.now)
  end

  # パスワード再設定のメールを送信する
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  private
    # ランダムなトークンを返す
    def User.new_token
      SecureRandom.urlsafe_base64
    end

    # 有効化トークンとダイジェストを作成および代入する user.create前に実行される
    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end

end
