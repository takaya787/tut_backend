require "rails_helper"

RSpec.describe Like, type: :model do
  before do
    @like = create(:michael_like)
    @user = User.find(@like.user_id)
    @micropost = Micropost.find(@like.micropost_id)
  end
  describe "like Model" do
    it "should be valid" do
      expect(@like).to be_valid
    end
    it "should have valid user_id" do
      expect(@like.user_id).to be_truthy
      expect(@user).to be_truthy
    end
    it "should have micropost_id" do
      expect(@like.user_id).to be_truthy
      expect(@micropost).to be_valid
      expect(User.find(@micropost.user_id)).to be_valid
    end
    it "should be unique" do
      duplicated_like = @like.dup
      expect(duplicated_like).not_to be_valid
    end
  end
end
