# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::AudiencesController, type: :controller do
  let(:token) { double acceptable?: true }

  before do
    allow(controller).to receive(:doorkeeper_token) { token }
  end

  let!(:application) { FactoryBot.create :application } # OAuth application
  let!(:user)        { FactoryBot.create :doorkeeper_testing_user }
  let!(:token)       { FactoryBot.create :access_token, application: application, resource_owner_id: user.id }

  let(:location) { Location.create user_id: user.id }

  describe 'testing the routes mostly' do
    it 'should not render the splash pages index' do
      location = Location.create id: 1, user_id: 123_978_123

      get :index, format: :json, params: { location_id: location.slug }
      expect(response).to_not be_successful
    end

    it 'should render the audience index' do
      Audience.create location_id: location.id

      get :index, format: :json, params: { location_id: location.slug }
      expect(response).to be_successful

      parsed_body = JSON.parse(response.body)
      expect(parsed_body['audiences'].length).to eq 1
    end

    context 'create action' do
      it 'should allow the user to create a splash page' do
        data = [
          {
            attribute: 'last_seen',
            value: '14',
            relative: true,
            operator: '='
          }
        ].to_json
        blob = Base64.encode64(data)
        post :create, format: :json, params: { 
          location_id: location.slug, 
          audience: { 
            blob: blob 
          } 
        }
        expect(response).to be_successful
        s = Audience.last
        expect(s.location_id).to eq location.id
        expect(s.predicates[0]['attribute']).to eq 'last_seen'
        expect(s.predicates[0]['value']).to eq '14'
        expect(s.predicates[0]['relative']).to eq true
        expect(s.predicates[0]['operator']).to eq '='
      end
    end

    context 'update action' do
      it 'should allow the user to update their audience' do
        s = Audience.create location_id: location.id

        data = [
          {
            attribute: 'last_seen',
            value: '14',
            relative: true,
            operator: '='
          }
        ].to_json
        blob = Base64.encode64(data)

        patch :update, format: :json, params: { 
          location_id: location.slug,
          id: s.id,
          audience: {
            blob: blob
          }
        }
        expect(response).to be_successful

        s = Audience.last
        expect(s.predicates[0]['attribute']).to eq 'last_seen'
      end
    end

    context 'delete action' do
      it 'should allow the user to view their splash' do
        s = Audience.create location_id: location.id
        delete :destroy, format: :json, params: { location_id: location.slug, id: s.id }
        expect(response).to be_successful
      end
    end
  end
end
