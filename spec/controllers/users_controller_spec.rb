require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #check_mobile" do
    it "returns http success" do
      get :check_mobile
      expect(response).to have_http_status(:success)
    end
  end

end
