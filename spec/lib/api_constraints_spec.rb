require 'rails_helper'
require 'api_constraints'

describe ApiConstraints do
  let(:api_constrains_v1) { ApiConstraints.new(version: 1, default: true) }

  describe "matches?" do
    it "returns true when the version matches the given version" do
      request = double(host: 'api.shareito.com',
        headers: {"Accept" => "application/api.shareito.v1"}
      )
      expect(api_constrains_v1.matches?(request)).to be true
    end

    it "returns default version when no version provided" do
      request = double(host: 'api.shareito.com')
      expect(api_constrains_v1.matches?(request)).to be true
    end
  end
end
