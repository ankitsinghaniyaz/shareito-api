require 'rails_helper'

RSpec.describe User, type: :model do
  before { @user = FactoryGirl.build(:user) }

  subject {@user}

  # it { should respond_to(:email) }
  # it { should respond_to(:password) }
  # it { should respond_to(:password_confirmation) }



  it { should validate_presence_of(:email) }
  xit { should validate_presence_of(:password_digest) }
  it { should validate_presence_of(:team) }
  it { should be_valid }

  describe "when email is not present" do
    before { @user.email = nil }
    it { should_not be_valid }
  end

  describe "when email is wrong format" do
    before { @user.email = "www.happy.com" }
    it { should_not be_valid }
  end

  describe "when team is nil" do
    before { @user.team = nil }
    it {should_not be_valid}
  end
end
