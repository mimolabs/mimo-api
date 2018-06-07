# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::PersonTimelinesController, type: :controller do

  context 'accessing timeline as location admin' do
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
        person = Person.create
        get :index, format: :json, params: { location_id: location.slug, person_id: person.id }
        expect(response).to_not be_successful
      end

      it 'should render the person_timeline index' do
        person = Person.create
        PersonTimeline.create location_id: location.id, person_id: person.id

        get :index, format: :json, params: { location_id: location.slug, person_id: person.id }
        expect(response).to be_successful

        parsed_body = JSON.parse(response.body)
        expect(parsed_body['timelines'].length).to eq 1
      end
    end
  end

  context 'portal access' do
    let(:location) { Location.create }

    describe 'accessing portal timeline index' do
      it 'should not send index - no timeline events' do
        person = Person.create location_id: location.id
        get :portal_timeline, format: :json, params: { person_id: person.id, code: SecureRandom.hex }
        expect(response).to_not be_successful
        parsed_body = JSON.parse(response.body)
        expect(parsed_body['message']).to include 'Unable to authenticate code'
      end

      it 'should send the user\'s timeline events' do
        person = Person.create location_id: location.id
        pt = PersonTimeline.create location_id: location.id, person_id: person.id
        access_code = SecureRandom.hex
        REDIS.setex("timelinePortalCode:#{person.id}", 10, access_code)
        get :portal_timeline, format: :json, params: { person_id: person.id, code: access_code }
        expect(response).to be_successful
        parsed_body = JSON.parse(response.body)
        expect(parsed_body['timelines'][0]['id']).to eq pt.id.to_s
      end

      it 'should not send the user\'s timeline events - incorrect access code' do
        person = Person.create location_id: location.id
        pt = PersonTimeline.create location_id: location.id, person_id: person.id
        access_code = SecureRandom.hex
        REDIS.setex("timelinePortalCode:#{person.id}", 10, access_code)
        get :portal_timeline, format: :json, params: { person_id: person.id, code: SecureRandom.hex }
        expect(response).not_to be_successful
        parsed_body = JSON.parse(response.body)
        expect(parsed_body['message']).to include 'Unable to authenticate code'
      end
    end
  end
end
