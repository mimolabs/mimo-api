# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::UsersController, type: :controller do
  let(:token) { double acceptable?: true }

  before do
    allow(controller).to receive(:doorkeeper_token) { token }
  end

  let!(:application) { FactoryBot.create :application } # OAuth application
  let!(:user)        { FactoryBot.create :doorkeeper_testing_user }
  let!(:token)       { FactoryBot.create :access_token, application: application, resource_owner_id: user.id }

  let(:location) { Location.create user_id: user.id }

  describe 'testing the routes mostly' do
    it 'the users index should render the show page' do
      get :index, format: :json, params: { location_id: location.slug }
      expect(response).to be_successful
      parsed = JSON.parse(response.body)

      expect(parsed['id']).to eq user.id
    end

    # context 'show action' do
    #   it 'should allow the user to view their location' do
    #     s = User.create location_id: location.id
    #     patch :update, format: :json, params: { location_id: location.slug, id: s.id, user: { weight: 10_000 } }
    #     expect(response).to be_successful
    #     expect(s.reload.weight).to eq 10_000
    #   end
    # end

    # context 'delete action' do
    #   it 'should allow the user to view their splash' do
    #     s = User.create location_id: location.id
    #     delete :destroy, format: :json, params: { location_id: location.slug, id: s.id }
    #     expect(response).to be_successful
    #   end
    # end
  end
end
