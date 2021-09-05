require "rails_helper"

RSpec.describe "Likes", type: :request do
  # describe "GET /create" do
  #   it "returns http success" do
  #     get "/likes/create"
  #     expect(response).to have_http_status(:success)
  #   end
  # end

  # describe "GET /destory" do
  #   it "returns http success" do
  #     get "/likes/destory"
  #     expect(response).to have_http_status(:success)
  #   end
  # end
  context "login failed" do
    describe "GET /likes/create" do
      before do
        post api_likes_path
        @response = response
        @json = JSON.parse(response.body)
      end

      it "has status 401" do
        expect(@response.status).to eq(401)
      end

      it "has error message" do
        expect(@json.has_key?("message")).to be_truthy
      end

      it "the error message should be Please Log in" do
        message = "Please log in"
        expect(@json["message"]).to eq(message)
      end
    end

    describe "DELETE /likes/destory/:id" do
      before do
        @like = create(:michael_like)
        delete api_like_path(@like)
        @response = response
        @json = JSON.parse(response.body)
      end

      it "has status 401" do
        expect(@response.status).to eq(401)
      end

      it "has error message" do
        expect(@json.has_key?("message")).to be_truthy
      end

      it "the error message should be Please Log in" do
        message = "Please log in"
        expect(@json["message"]).to eq(message)
      end
    end
  end
end
