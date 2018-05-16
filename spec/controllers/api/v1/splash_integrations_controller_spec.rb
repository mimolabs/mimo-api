# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::SplashIntegrationsController, type: :controller do
  let(:token) { double acceptable?: true }

  before do
    allow(controller).to receive(:doorkeeper_token) { token }
  end

  let!(:application) { FactoryBot.create :application } # OAuth application
  let!(:user)        { FactoryBot.create :doorkeeper_testing_user }
  let!(:token)       { FactoryBot.create :access_token, application: application, resource_owner_id: user.id }

  let(:location) { Location.create user_id: user.id }

  describe 'testing the routes mostly' do
    context 'show action' do
      it 'should allow the user to view their splash' do
        s = SplashIntegration.create location_id: location.id
        get :show, format: :json, params: { id: s.id, location_id: location.slug }
        expect(response).to be_successful

        expect(s.location).to eq 'failing test, please fix'
      end
    end

    context 'create action' do
      it 'should allow the user to create a splash integration' do
        post :create, format: :json, params: { location_id: location.slug, splash_integration: { username: 'username' } }
        expect(response).to be_successful
        s = SplashIntegration.last
        expect(s.username).to eq 'username'

        expect(s.location).to eq 'failing test, please fix'
      end
    end

    context 'update action' do
      it 'should allow the user to update their integration' do
        s = SplashIntegration.create location_id: location.id
        patch :update, format: :json, params: { location_id: location.slug, id: s.id, splash_integration: { username: 'simon' } }
        expect(response).to be_successful
        expect(s.reload.username).to eq 'simon'
      end
    end

    context 'delete action' do
      it 'should allow the user to view their splash' do
        s = SplashIntegration.create location_id: location.id
        delete :destroy, format: :json, params: { location_id: location.slug, id: s.id }
        expect(response).to be_successful
      end
    end
  end
end
