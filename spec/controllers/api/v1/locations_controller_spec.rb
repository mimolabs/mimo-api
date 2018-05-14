require 'rails_helper'

describe Api::V1::LocationsController, :type => :controller do
  # login_oauth

  let(:token) { double :acceptable? => true }

  before do
    allow(controller).to receive(:doorkeeper_token) { token }
    # allow(controller).to receive(:doorkeeper_token) {token} # => RSpec 3
  end

  let!(:application) { FactoryBot.create :application } # OAuth application
  let!(:user)        { FactoryBot.create :doorkeeper_testing_user }
  let!(:token)       { FactoryBot.create :access_token, :application => application, :resource_owner_id => user.id }

  describe "testing the routes mostly" do
    it "should render the locations index" do
      location = Location.create id: 1, user_id: 1

      get :index, format: :json
      expect(response).to be_success
              
      parsed_body = JSON.parse(response.body)
      expect(parsed_body['locations'].length).to eq 0

      location.update user_id: user.id
      get :index, format: :json
      expect(response).to be_success
              
      parsed_body = JSON.parse(response.body)
      expect(parsed_body['locations'].length).to eq 1
    end

    context 'show action' do
      it 'should not allow the user to view another location' do
        location = Location.create! user_id: 100
        get :show, format: :json, params: { id: location.id }
        expect(response).to_not be_success
      end

      it 'should allow the user to view their location' do
        location = Location.create! user_id: user.id
        get :show, format: :json, params: { id: location.id }
        expect(response).to be_success
      end
    end

    it 'should allow the user to edit their location'

    it 'should allow the user to delete their location'

  end

end
