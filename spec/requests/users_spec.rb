require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /users" do
    before do
      10.times{
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
      expect(@json.first).to include("id","name","email","gravator_url")
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
      expect(@json).to include("id","name","gravator_url","email")
    end
  end
end
