require "rails_helper"

RSpec.describe User, type: :model do
  before do
    @user = create(:user)
  end

  describe "user validation" do
    it "should be valid" do
      expect(@user).to be_valid
    end

    it "name should be present" do
      @user.name = " "
      expect(@user).not_to be_valid
    end

    it "name should not be too long" do
      @user.name = "a" * 52
      expect(@user).not_to be_valid
    end

    it "email should not be too long" do
      @user.email = "a" * 244 + "@example.com"
      expect(@user).not_to be_valid
    end

    it "email validation should reject invalid addresses" do
      invalid_addresses = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com]
      invalid_addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).not_to be be_valid
      end
    end

    it "email should be unique" do
      duplicate_user = @user.dup
      @user.save
      expect(duplicate_user).not_to be_valid
      expect(@user).to be_valid
    end

    it "email addresses should be saved as lower-case" do
      mixed_case_email = "Foo@ExAMPle.CoM"
      @user.email = mixed_case_email
      @user.save
      expect(mixed_case_email.downcase).to eq(@user.reload.email)
    end

    it "password should be present" do
      @user.password = @user.password_confirmation = " " * 6
      expect(@user).not_to be_valid
    end

    it "password should have a minimum length" do
      @user.password = @user.password_confirmation = "a" * 5
      expect(@user).not_to be_valid
    end
  end

  describe "user.model function test" do
    let(:micropost) { { content: "Lorem ipsum" } }

    it "can create micropost" do
      @user.save
      expect { @user.microposts.create!(micropost) }.to change { @user.microposts.count }.by(1)
    end

    it "associated microposts should be destroyed" do
      @user.save
      @user.microposts.create!(micropost)
      expect { @user.destroy }.to change { Micropost.count }.by(-1)
    end

    describe "(like model related fuction)" do
      before do
        @like = create(:michael_like)
        @michael = User.find(@like.user_id)
        @liked_micropost = Micropost.find(@like.micropost_id)
      end
      it "can count liked microposts" do
        expect(@michael.likes.count).to be(1)
      end
      it "can get liked microposts" do
        expect(@michael.liked_microposts.first).to eq(@liked_micropost)
      end
    end
  end
end
