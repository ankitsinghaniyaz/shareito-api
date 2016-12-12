require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'POST #create' do
    context "when it is successfully created" do
      before(:each) do
        @user_params = FactoryGirl.attributes_for :correct_user_params
        post :create, params: {user: @user_params}, format: :json
      end

      it "send status in reply" do
        user_response = json_response
        expect(user_response).to have_key(:status)
      end

      it { should respond_with 201 }
    end

    context "when it is not created successfully" do
      before(:each) do
        @user_params = FactoryGirl.attributes_for :wrong_user_params
        post :create, params: {user: @user_params}, format: :json
      end

      it "sends error in reply" do
        user_response = json_response
        expect(user_response).to have_key(:errors)
      end

      it { should respond_with 400 }
    end

    context "when given mismatch passowrd" do
      before(:each) do
        @user_params = FactoryGirl.attributes_for :mismatch_passowrd_user_params
        post :create, params: {user: @user_params}, format: :json
      end

      it "sends error in reply" do
        user_response = json_response
        expect(user_response).to have_key(:errors)
      end

      it { should respond_with 400 }
    end

  end

  describe 'POST #confirm'do
    context "given corrent token" do
      before(:each) do
        @user = FactoryGirl.create :user
        @user.confirmation_token = '10digittoken'
        @user.save
        post :confirm, params: {token: '10digittoken'}, format: :json
      end

     it "send status message for successful confirmation" do
      user_response = json_response
      expect(user_response[:status]).to eq("Email confirmed successfully")
     end

     it {should respond_with 200}
    end

    context "given incorrent token" do
      before(:each) do
        @user = FactoryGirl.create :user
        post :confirm, params: {token: 'wrongtoken'}, format: :json
      end

     it "send status message for unsuccessful confirmation" do
      user_response = json_response
      expect(user_response[:status]).to eq("Email could not be verified")
     end

     it { should respond_with 404 }
    end
  end

  describe 'POST #login' do
    context "Given correct credentail and confirmed" do
      before(:each) do
        @password = "hello"
        @user = FactoryGirl.create :correct_user_params
        @user.mark_as_confirmed!
        post :login, params: {email: @user.email, password: @password}
      end

      it "send auth token" do
        user_response = json_response
        expect(user_response).to have_key(:auth_token)
      end

      it { should respond_with 200 }
    end

    context "Given correct credentail and not confirmed" do
      before(:each) do
        @password = "hello"
        @user = FactoryGirl.create :correct_user_params
        post :login, params: {email: @user.email, password: @password}
      end

      it "send auth token" do
        user_response = json_response
        expect(user_response[:error]).to eq("Email not verified")
      end

      it { should respond_with 401 }
    end

    context "Given wrong credentail and confirmed" do
      before(:each) do
        @password = "magic"
        @user = FactoryGirl.create :correct_user_params
        @user.mark_as_confirmed!
        post :login, params: {email: @user.email, password: @password}
      end

      it "send auth token" do
        user_response = json_response
        expect(user_response[:error]).to eq("Invalid username or password")
      end

      it { should respond_with 401}
    end

    context "Given wrong credentail and not confirmed" do
      before(:each) do
        @password = "magic"
        @user = FactoryGirl.create :correct_user_params
        post :login, params: {email: @user.email, password: @password}
      end

      it "send auth token" do
        user_response = json_response
        expect(user_response[:error]).to eq("Invalid username or password")
      end

      it { should respond_with 401}
    end
  end

  describe 'POST #facebook_login' do
    context "with right access token and user does not exist" do
      before(:each) do
        allow(Facebook).to receive(:profile).
          with("token").
          and_return({"name" => "Hello", "id" => "14314141", "email" => "hello@me.com"})
        post :facebook_login, params: {token: "token"}
      end

      it "will create a user and reply with jwt" do
        user_response = json_response
        expect(user_response).to have_key(:auth_token)
      end

      it { should respond_with 201 }
    end

    context "with right access token and user exist" do
      before(:each) do
        FactoryGirl.create :user_with_origin_111
        allow(Facebook).to receive(:profile).
          with("token").
          and_return({"name" => "Hello", "id" => "111", "email" => "hello@me.com"})
        post :facebook_login, params: {token: "token"}
      end
      it "will reply with the jwt" do
        user_response = json_response
        expect(user_response).to have_key(:auth_token)
      end

      it { should respond_with 200 }
    end

    context "with wrong access token" do
      before(:each) do
        allow(Facebook).to receive(:profile).
          with("token").
          and_return(nil)
        post :facebook_login, params: {token: "token"}
      end

      it "will say unauthorized" do
        user_response = json_response
        expect(user_response).to have_key(:error)
      end

      it { should respond_with 401 }

    end
  end
end
