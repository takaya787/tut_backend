require "rails_helper"

RSpec.describe "Microposts", type: :request do
  context "login successed" do
    content_sample = "Content Sample"
    let (:micropost_params) { { micropost: { content: content_sample } } }
    before do
      @michael = create(:michael)
      @user = create(:user)
      payload = { user_id: @user.id }
      token = JWT.encode(payload, "s3cr3t")
      @headers = {
        "Authorization" => "Bearer #{token}",
      }
    end

    describe "POST /create" do
      before do
        post api_microposts_path, params: micropost_params, headers: @headers
        @response = response
        @json = JSON.parse(response.body)
      end
      it "has status 200" do
        expect(@response.status).to eq(200)
      end

      it "has a successful message" do
        expect(@json["message"]).to eq("Micropost created")
      end
      it "has a correct micropost" do
        expect(@json["micropost"]["content"]).to eq(content_sample)
        expect(@json["micropost"]["user_id"]).to eq(@user.id)
      end

      it "increment a count of microposts by 1" do
        expect { post api_microposts_path, params: micropost_params, headers: @headers }.to change { Micropost.count }.by(1)
      end
    end
    describe "POST /update" do
      content_edited = "Micropost updated"
      micropost_edit_params = { micropost: { content: content_edited } }
      before do
        micropost = create(:micropost, user: @user)
        put api_micropost_path(micropost.id), params: micropost_edit_params, headers: @headers
        @response = response
        @json = JSON.parse(response.body)
      end
      it "has status 200" do
        expect(@response.status).to eq(200)
      end

      it "has a successful message" do
        expect(@json["message"]).to eq("Micropost updated Successfully")
      end
      it "can edit content" do
        expect(@json["micropost"]["content"]).to eq(content_edited)
      end
    end
  end
end
