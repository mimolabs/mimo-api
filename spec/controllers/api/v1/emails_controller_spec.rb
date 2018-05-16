# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::EmailsController, type: :controller do
  let(:token) { double acceptable?: true }

  before do
    allow(controller).to receive(:doorkeeper_token) { token }
  end

  let!(:application) { FactoryBot.create :application } # OAuth application
  let!(:user)        { FactoryBot.create :doorkeeper_testing_user }
  let!(:token)       { FactoryBot.create :access_token, application: application, resource_owner_id: user.id }

  let(:location) { Location.create user_id: user.id }
  let(:person) { Person.create }

  describe 'testing the routes mostly' do
    it 'should not render the emails index' do
      location = Location.create id: 1, user_id: 123_978_123

      get :index, format: :json, params: { location_id: location.slug, person_id: person.id }
      expect(response).to_not be_successful
    end

    it 'should render the email index' do
      Email.create location_id: location.id

      get :index, format: :json, params: { location_id: location.slug, person_id: person.id }
      expect(response).to be_successful

      parsed_body = JSON.parse(response.body)
      expect(parsed_body['emails'].length).to eq 1
    end

    context 'show action' do
      it 'should allow the user to view an email' do
        s = Email.create location_id: location.id

        get :show, format: :json, params: { id: s.id, location_id: location.slug, person_id: person.id }
        expect(response).to be_successful
      end
    end
  end
end
