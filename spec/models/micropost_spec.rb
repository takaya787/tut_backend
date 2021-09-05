require "rails_helper"

RSpec.describe Micropost, type: :model do
  before do
    @micropost = create(:micropost)
  end

  describe "micropost validation" do
    it "should be valid" do
      expect(@micropost).to be_valid
    end

    it "content should be present" do
      @micropost.content = " "
      expect(@micropost).not_to be_valid
    end

    it "content should be less than 140" do
      @micropost.content = "a" * 150
      expect(@micropost).not_to be_valid
    end

    it "user.id should be present" do
      @micropost.user_id = nil
      expect(@micropost).not_to be_valid
    end

    it "user id should be vaild" do
      user = User.find(@micropost.user_id)
      expect(user).to be_valid
    end
  end

  describe "micropost.model function" do
    let(:edit_micropost) { { content: "Lorem ipsum" } }
    it "with image" do
      image_micropost = build(:image_micropost)
      expect(image_micropost.image.attached?).to be_truthy
    end

    it "can edit content" do
      micropost = create(:micropost)
      micropost.update(edit_micropost)
      expect(micropost).to be_valid
      expect(micropost.content).to eq("Lorem ipsum")
    end
    describe "(like model related fuction)" do
      before do
        @like = create(:michael_like)
        @michael = User.find(@like.user_id)
        @liked_micropost = Micropost.find(@like.micropost_id)
      end
      it "can count liked users" do
        expect(@liked_micropost.liked_users.count).to be(1)
        expect(@liked_micropost.liked_users.first).to eq(@michael)
      end

      it "can count likes" do
        expect(@liked_micropost.likes.count).to be(1)
      end
    end
  end
end
