require 'rails_helper'

describe Api::V1::SplashPagesController, :type => :controller do

  let(:token) { double :acceptable? => true }

  before do
    allow(controller).to receive(:doorkeeper_token) { token }
    # allow(controller).to receive(:doorkeeper_token) {token} # => RSpec 3
  end

  let!(:application) { FactoryBot.create :application } # OAuth application
  let!(:user)        { FactoryBot.create :doorkeeper_testing_user }
  let!(:token)       { FactoryBot.create :access_token, :application => application, :resource_owner_id => user.id }

  let(:location) { Location.create user_id: user.id }

  describe "testing the routes mostly" do
    it "should render the splash pages index" do
      location = Location.create id: 1, user_id: user.id
      sp = SplashPage.create location_id: location.id

      get :index, format: :json, params: { location_id: location.slug }
      expect(response).to be_success
              
      parsed_body = JSON.parse(response.body)
      expect(parsed_body.length).to eq 0

      # location.update user_id: user.id
      # get :index, format: :json
      # expect(response).to be_success
              
      # parsed_body = JSON.parse(response.body)
      # expect(parsed_body['locations'].length).to eq 1
    end

    # context 'show action' do
    #   it 'should not allow the user to view another location' do
    #     location = Location.create! user_id: 100
    #     get :show, format: :json, params: { id: location.slug }
    #     expect(response).to_not be_success
    #   end

    #   it 'should allow the user to view their location' do
    #     location = Location.create! user_id: user.id
    #     get :show, format: :json, params: { id: location.slug }
    #     expect(response).to be_success
    #   end
    # end

    # context 'create action' do
    #   it 'should allow the user to create a location' do
    #     name = 'my location name'
    #     post :create, format: :json, params: { location: { location_name: name } }
    #     expect(response).to be_success

    #     location = Location.find_by user_id: user.id
    #     expect(location.reload.location_name).to eq name
    #   end
    # end

    # context 'show action' do
    #   it 'should not allow the user to edit another location' do
    #     name = 'my location name'
    #     location = Location.create! user_id: 100
    #     patch :update, format: :json, params: { id: location.slug, location: { location_name: name } }
    #     expect(response).to_not be_success
    #   end

    #   it 'should allow the user to view their location' do
    #     name = 'my location name'
    #     location = Location.create! user_id: user.id
    #     patch :update, format: :json, params: { id: location.slug, location: { location_name: name } }
    #     expect(response).to be_success
    #     expect(location.reload.location_name).to eq name
    #   end
    # end

    # context 'delete action' do
    #   it 'should not allow the user to delete another location' do
    #     location = Location.create! user_id: 100
    #     delete :destroy, format: :json, params: { id: location.slug }
    #     expect(response).to_not be_success
    #   end

    #   it 'should allow the user to view their location' do
    #     location = Location.create! user_id: user.id
    #     delete :destroy, format: :json, params: { id: location.slug }
    #     expect(response).to be_success
    #   end
    # end

  end

end
