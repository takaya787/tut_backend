require "rails_helper"

RSpec.describe "Auths", type: :request do
  context "login successed" do
    before do
      @michael = create(:michael)
      @user = create(:user)
      payload = { user_id: @user.id }
      token = JWT.encode(payload, "s3cr3t")
      @headers = {
        "Authorization" => "Bearer #{token}",
      }
    end

    describe "POST /login" do
      let (:login_params) { { email: @michael.email, password: "password" } }
      before do
        post api_login_path, params: login_params
        @response = response
        @json = JSON.parse(response.body)
      end

      it "has status 200" do
        expect(@response.status).to eq(200)
      end

      it "has user key and token key" do
        expect(@json.has_key?("user")).to be_truthy
        expect(@json.has_key?("token")).to be_truthy
      end

      it "can find correct user from token" do
        token = @json["token"]
        decoded_token = JWT.decode(token, "s3cr3t", true, algorothm: "HS256")
        expect(decoded_token).to be_truthy
        expect(@michael).to eq(User.find(decoded_token[0]["user_id"]))
      end
    end

    describe "GET /auto_login" do
      before do
        get api_auto_login_path, headers: @headers
        @response = response
        @json = JSON.parse(response.body)
      end

      it "has status ok" do
        expect(@response.status).to eq(200)
      end

      it "has user_info" do
        expect(@json.has_key?("user")).to be_truthy
        expect(@json["user"]).to include("id", "name", "email", "gravator_url", "microposts")
      end

      it "user id should be a correct user id" do
        expect(@user).to eq(User.find(@json["user"]["id"]))
      end
    end

    describe "GET /auto_relationships" do
      before do
        get api_auto_relationships_path, headers: @headers
        @response = response
        @json = JSON.parse(response.body)
      end

      it "has status 200" do
        expect(@response.status).to eq(200)
      end
    end

    describe "GET /auto_feed" do
      let (:feed_params) { { Offset: 0, Limit: 10 } }
      before do
        get api_auto_feed_path, headers: @headers, params: feed_params
        @response = response
        @json = JSON.parse(response.body)
      end

      it "has status 200" do
        expect(@response.status).to eq(200)
      end

      it "json has microposts key" do
        # puts(@json)
        expect(@json.has_key?("microposts")).to be_truthy
      end

      it "length is Limited less than 10 " do
        expect(@json["microposts"].length).to be < 10
      end
    end
  end

  context "login failed" do
    describe "GET /auto_login" do
      before do
        get api_auto_login_path
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

    describe "GET /auto_relationships" do
      before do
        get api_auto_relationships_path
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
