require "test_helper"

class UserMailerTest < ActionMailer::TestCase

  def setup
    @user = users(:michael)
  end

  # test "account_activation" do
  #   mail = UserMailer.account_activation(@user)
  #   assert_equal "Account activation", mail.subject
  #   assert_equal [@user.email], mail.to
  #   assert_equal ["localhost:3000"], mail.from
  #   assert_match "Hi", mail.body.encoded
  # end

  # test "password_reset" do
  #   mail = UserMailer.password_reset(@user)
  #   assert_equal "Password reset", mail.subject
  #   # assert_equal [@user.email], mail.to
  #   # assert_equal ["localhost:3000"], mail.from
  #   assert_match "Hi", mail.body.encoded
  # end

end
