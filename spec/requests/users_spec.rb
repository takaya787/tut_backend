require "rails_helper"

RSpec.describe "Users", type: :request do
  context "get request" do
    describe "GET /users" do
      before do
        10.times {
          FactoryBot.create(:user)
        }
        get api_users_path
        @json = JSON.parse(response.body)
      end

      it "status ok" do
        expect(response.status).to eq(200)
      end

      it "response length should be equal to count" do
        expect(@json.length).to eq(User.all.count)
      end

      it "each response include id, name.email,gravator_url" do
        expect(@json.first).to include("id", "name", "email", "gravator_url")
      end
    end

    describe "GET /user/{:id}" do
      before do
        @user = create(:user)
        get api_user_path(@user)
        @response = response
        @json = JSON.parse(response.body)
      end
      it "status ok" do
        expect(@response.status).to eq(200)
      end

      it "response has user info" do
        expect(@json).to include("id", "name", "gravator_url", "email")
      end
    end

    describe "GET /user/{:id}/following" do
      before do
        @user = create(:user)
        (1..10).each do |i|
          var = "@following#{i}"
          value = create(:user)
          eval("#{var} = value")
        end
        (1..10).each do |i|
          target = "@following#{i}"
          eval("@user.follow(#{target})")
        end
        get following_api_user_path(@user)
        @response = response
        @json = JSON.parse(response.body)
      end
      it "status ok" do
        expect(@response.status).to eq(200)
      end

      it "following count should be equal to length" do
        expect(@json["following"].length).to eq(@user.following.count)
      end

      it "response has following key" do
        expect(@json).to include("user", "following")
      end

      it "first following is equal to following1" do
        following = @json["following"]
        expect(following[0]["name"]).to eq(@following1.name)
        expect(following[0]["id"]).to eq(@following1.id)
      end
    end

    describe "GET /user/{:id}/followers" do
      before do
        @user = create(:user)
        (1..10).each do |i|
          var = "@follower#{i}"
          value = create(:user)
          eval("#{var} = value")
        end
        (1..10).each do |i|
          target = "@follower#{i}"
          eval("#{target}.follow(@user)")
        end
        get followers_api_user_path(@user)
        @response = response
        @json = JSON.parse(response.body)
      end
      it "status ok" do
        expect(@response.status).to eq(200)
      end

      it "following count should be equal to length" do
        expect(@json["followers"].length).to eq(@user.followers.count)
      end

      it "response has following key" do
        expect(@json).to include("user", "followers")
      end

      it "first follwer is equal to follower1" do
        followers = @json["followers"]
        expect(followers[0]["name"]).to eq(@follower1.name)
        expect(followers[0]["id"]).to eq(@follower1.id)
      end
    end

    describe "GET /user/{:id}/likes" do
      before do
        @user = create(:user)
        (1..10).each do |i|
          var = "@micropost#{i}"
          value = create(:micropost)
          eval("#{var} = value")
        end
        (1..10).each do |i|
          target = "@micropost#{i}"
          eval("#{target}.likes.create(user_id: @user.id)")
        end
        get likes_api_user_path(@user)
        @response = response
        @json = JSON.parse(response.body)
      end
      it "status ok" do
        expect(@response.status).to eq(200)
      end

      it "likes micropost count should be equal to length" do
        expect(@json["microposts"].length).to eq(@user.likes.count)
      end

      it "last micropost should be equal to micropost1" do
        microposts = @json["microposts"]
        expect(microposts.last["content"]).to eq(@micropost1.content)
        expect(microposts.last["id"]).to eq(@micropost1.id)
      end
    end
  end

  context "post or patch request" do
    let(:name) { "test name" }
    let(:email) { "example@railstutorial.com" }
    let(:password) { "password" }
    let(:password_confirmation) { "password" }
    let(:signup_params) { { user: { name: name, email: email, password: password, password_confirmation: password_confirmation } } }

    describe "POST /users" do
      context "successed response" do
        before do
          post api_users_path, params: signup_params
          @response = response
          @json = JSON.parse(response.body)
        end
        let(:user) { @json["user"] }
        let(:token) { @json["token"] }

        it "has status 201" do
          expect(@response.status).to eq(201)
        end

        it "has correct user object" do
          expect(user).to be_truthy
          expect(user["email"]).to eq(email)
          expect(user["name"]).to eq(name)
        end

        it "has correct user token" do
          token = @json["token"]
          expect(token).to be_truthy
          decoded_token = JWT.decode(token, "s3cr3t", true, algorothm: "HS256")
          expect(user["id"]).to eq(decoded_token[0]["user_id"])
        end
      end
      context "failed response" do
        context "has email error message" do
          let(:email) { "user@example,com" }
          before do
            post api_users_path, params: signup_params
            @response = response
            @json = JSON.parse(response.body)
          end

          it "has status 401" do
            expect(@response.status).not_to eq(401)
          end

          it "has errors and email key" do
            expect(@json.has_key?("errors")).to be_truthy
            expect(@json["errors"].has_key?("email")).to be_truthy
          end
        end
        context "has passwords related error" do
          let(:password) { "pass" }
          let(:password_confirmation) { "password" }
          before do
            post api_users_path, params: signup_params
            @response = response
            @json = JSON.parse(response.body)
          end

          it "has status 401" do
            expect(@response.status).not_to eq(401)
          end

          it "has password and password_confirmation key" do
            expect(@json.has_key?("errors")).to be_truthy
            expect(@json["errors"].has_key?("password")).to be_truthy
            expect(@json["errors"].has_key?("password_confirmation"))
          end
        end
      end
    end

    describe "PUT /users/{:id}" do
      let(:michael) { create(:michael) }
      let(:archer) { create(:archer) }
      let(:lana) { create(:lana) }
      let(:edit_params) { { user: { name: name, email: email, password: "password", password_confirmation: "password" } } }

      context "User is admin" do
        # Header???michael?????????
        let(:payload) { { user_id: michael.id } }
        let(:token) { JWT.encode(payload, "s3cr3t") }
        let(:headers) { { "Authorization" => "Bearer #{token}" } }

        context "when user edit his profile," do
          let(:name) { "edit name" }
          let(:email) { michael.email }
          before do
            put api_user_path(michael), params: edit_params, headers: headers
            @response = response
            @json = JSON.parse(response.body)
          end

          it "has status 200" do
            expect(@response.status).to eq(200)
          end

          it "confirmed changed name" do
            expect(@json["name"]).to eq("edit name")
          end
        end

        context "when user edit other's profile," do
          let(:name) { "edited by admin" }
          let(:email) { archer.email }
          before do
            put api_user_path(archer), params: edit_params, headers: headers
            @response = response
            @json = JSON.parse(response.body)
          end

          it "has status 200" do
            expect(@response.status).to eq(200)
          end

          it "confirmed changed name" do
            expect(User.find(@json["id"])).to eq(archer)
            expect(@json["name"]).to eq("edited by admin")
          end
        end
      end

      context "User is not admin," do
        # Header?????????archer?????????(admin:false)
        let(:payload) { { user_id: archer.id } }
        let(:token) { JWT.encode(payload, "s3cr3t") }
        let(:headers) { { "Authorization" => "Bearer #{token}" } }

        context "when user edit his own profile," do
          let(:name) { "edited by myself" }
          let(:email) { archer.email }
          before do
            put api_user_path(archer), params: edit_params, headers: headers
            @response = response
            @json = JSON.parse(response.body)
          end

          it "response has status 200" do
            expect(@response.status).to eq(200)
          end

          it "confirmed changed name" do
            expect(User.find(@json["id"])).to eq(archer)
            expect(@json["name"]).to eq("edited by myself")
          end
        end

        context "when user try to edit others profile," do
          let(:name) { "edited other's name" }
          let(:email) { archer.email }
          before do
            put api_user_path(lana), params: edit_params, headers: headers
            @response = response
            @json = JSON.parse(response.body)
          end

          it "response has status 403" do
            expect(@response.status).to eq(403)
          end

          it "error message should be 'You are not correct user'" do
            expect(@json.has_key?("message")).to be_truthy
            expect(@json["message"]).to eq("You are not correct user")
          end
        end
      end
    end
  end
end
