require "rails_helper"

RSpec.describe "Likes", type: :request do
  context "login successed" do
    before do
      @micropost = create(:micropost)
      @user = create(:user)
      payload = { user_id: @user.id }
      token = JWT.encode(payload, "s3cr3t")
      @headers = {
        "Authorization" => "Bearer #{token}",
      }
    end

    describe "GET /likes/create?micropost_id=xx" do
      describe "when success to like," do
        before do
          post api_likes_path(:micropost_id => @micropost.id), headers: @headers
          @response = response
          @json = JSON.parse(response.body)
        end

        it "has status 200" do
          expect(@response.status).to eq(200)
        end

        it "has success message" do
          expect(@json["message"]).to eq("like the micropost successfully")
        end

        it "has correct micropost info" do
          expect(@json["micropost"]["id"]).to eq(@micropost.id)
        end

        it "user can get liked micropost" do
          liked_micropost = @user.liked_microposts.first
          expect(liked_micropost).to be_valid
          expect(liked_micropost.id).to eq(@micropost.id)
        end

        it "confirm the increment of liked microposts" do
          new_micropost = create(:micropost)
          expect { post api_likes_path(:micropost_id => new_micropost.id), headers: @headers }.to change { @user.liked_microposts.count }.by(1)
        end
      end
      describe "when failing to create like," do
        it "the same user can not create the same like" do
          post api_likes_path(:micropost_id => @micropost.id), headers: @headers
          expect(response.status).to eq(200)
          post api_likes_path(:micropost_id => @micropost.id), headers: @headers
          expect(response.status).to eq(400)
        end

        it "query params is missing" do
          post api_likes_path, headers: @headers
          expect(response.status).to eq(400)
          json = JSON.parse(response.body)
          expect(json["message"]).to eq("Micropost id params is missing")
        end
      end
    end

    describe "DELETE /likes/destroy?micropost_id=xx" do
      describe "In successfull cases," do
        before do
          post api_likes_path(:micropost_id => @micropost.id), headers: @headers
          delete api_likes_path(:micropost_id => @micropost.id), headers: @headers
          @response = response
          @json = JSON.parse(response.body)
        end
        it "has status 204" do
          expect(@response.status).to eq(202)
        end

        it "has successfull message" do
          expect(@json["message"]).to eq("Like is cancelled successfully")
        end
        it "confirm the decrement of liked microposts" do
          sample_like = create(:michael_like)
          sample_user = User.find(sample_like.user_id)
          payload = { user_id: sample_user.id }
          token = JWT.encode(payload, "s3cr3t")
          headers = {
            "Authorization" => "Bearer #{token}",
          }

          expect { delete api_likes_path(:micropost_id => sample_like.micropost_id), headers: headers }.to change { sample_user.liked_microposts.count }.by(-1)
        end
      end
      describe "In failure cases," do
        describe "when destroying the not existential like " do
          before do
            delete api_likes_path(:micropost_id => @micropost.id), headers: @headers
            @response = response
            @json = JSON.parse(response.body)
          end
          it "has status 400" do
            expect(@response.status).to eq(400)
          end

          it "has a not founded message" do
            expect(@json["message"]).to eq("Like is not founded")
          end
        end

        describe "when user is not correct user," do
          before do
            post api_likes_path(:micropost_id => @micropost.id), headers: @headers
            second_user = create(:user)
            payload = { user_id: second_user.id }
            token = JWT.encode(payload, "s3cr3t")
            headers = {
              "Authorization" => "Bearer #{token}",
            }
            delete api_likes_path(:micropost_id => @micropost.id), headers: headers
            @response = response
            @json = JSON.parse(response.body)
          end

          it "has status 400" do
            expect(@response.status).to eq(400)
          end
          it "has a not founded message" do
            expect(@json["message"]).to eq("Like is not founded")
          end
        end
      end
    end
  end
  context "login failed" do
    describe "GET /likes/create?micropost_id=xx" do
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

    describe "DELETE /likes/destroy?micropost_id=xx" do
      before do
        @like = create(:michael_like)
        delete api_likes_path(:micropost_id => @like.micropost_id)
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
