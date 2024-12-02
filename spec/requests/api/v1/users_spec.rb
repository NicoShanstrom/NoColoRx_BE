require 'rails_helper'

RSpec.describe "Api::V1::Users", type: :request do
  describe "POST /api/v1/users" do
    it "creates a new user with valid attributes" do
      user_params = { email: "test@example.com", password: "password123", password_confirmation: "password123" }

      post "/api/v1/users", params: { user: user_params }
      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)["user"]["email"]).to eq("test@example.com")
    end

    it "returns errors with invalid attributes" do
      user_params = { email: "", password: "password123", password_confirmation: "password123" }

      post "/api/v1/users", params: { user: user_params }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)["errors"]).to include("Email can't be blank")
    end
  end

  describe "GET /api/v1/users/:id" do
    it "returns the user details if the user exists" do
      user = create(:user)

      get "/api/v1/users/#{user.id}"
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["user"]["email"]).to eq(user.email)
    end

    it "returns an error if the user does not exist" do
      get "/api/v1/users/999"
      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)["error"]).to eq("User not found")
    end
  end

  describe "PATCH /api/v1/users/:id" do
    it "updates the user with valid attributes" do
      user = create(:user)
      updated_params = { email: "updated@example.com" }

      patch "/api/v1/users/#{user.id}", params: { user: updated_params }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["user"]["email"]).to eq("updated@example.com")
    end

    it "returns errors with invalid attributes" do
      user = create(:user)
      updated_params = { email: "" }

      patch "/api/v1/users/#{user.id}", params: { user: updated_params }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)["errors"]).to include("Email can't be blank")
    end
  end

  describe "DELETE /api/v1/users/:id" do
    it "deletes the user" do
      user = create(:user)

      delete "/api/v1/users/#{user.id}"
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["message"]).to eq("User deleted successfully")
    end
  end
end
