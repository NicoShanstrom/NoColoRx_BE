require 'rails_helper'

RSpec.describe "Api::V1::Sessions", type: :request do
  let!(:user) { create(:user, email: "test@example.com", password: "password123") }

  describe "POST /api/v1/login" do
    it "logs in the user with valid credentials" do
      post "/api/v1/login", params: { email: user.email, password: "password123" }
      expect(response).to have_http_status(:ok)
      expect(session[:user_id]).to eq(user.id)
    end
  end

  describe "DELETE /api/v1/logout" do
    before do
      post "/api/v1/login", params: { email: user.email, password: "password123" }
    end

    it "logs out the user if logged in" do
      delete "/api/v1/logout"
      expect(response).to have_http_status(:ok)
      expect(session[:user_id]).to be_nil
    end
  end
end
