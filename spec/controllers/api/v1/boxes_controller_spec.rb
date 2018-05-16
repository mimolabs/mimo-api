# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::BoxesController, type: :controller do
  let(:token) { double acceptable?: true }

  before do
    allow(controller).to receive(:doorkeeper_token) { token }
  end

  let!(:application) { FactoryBot.create :application } # OAuth application
  let!(:user)        { FactoryBot.create :doorkeeper_testing_user }
  let!(:token)       { FactoryBot.create :access_token, application: application, resource_owner_id: user.id }

  let(:location) { Location.create user_id: user.id }

  describe 'testing the routes mostly' do
    it 'should not render the boxes index' do
      location = Location.create id: 1, user_id: 123_978_123

      get :index, format: :json, params: { location_id: location.slug }
      expect(response).to_not be_successful
    end

    it 'should render the boxes index' do
      # location = Location.create id: 1, user_id: user.id
      Box.create location_id: location.id

      get :index, format: :json, params: { location_id: location.slug }
      expect(response).to be_successful

      parsed_body = JSON.parse(response.body)
      expect(parsed_body['boxes'].length).to eq 1
    end

    context 'delete action' do
      it 'should allow the user to view their splash' do
        s = Box.create location_id: location.id
        delete :destroy, format: :json, params: { location_id: location.slug, id: s.id }
        expect(response).to be_successful
      end
    end
  end
end
