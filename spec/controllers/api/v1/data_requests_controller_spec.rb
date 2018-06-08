# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::DataRequestsController, type: :controller do

  let(:location) { Location.create }

  describe 'accessing portal timeline index' do
    it 'should not send index - no timeline events' do
      person = Person.create location_id: location.id
      get :timeline, format: :json, params: { person_id: person.id, code: SecureRandom.hex }
      expect(response).to_not be_successful
      parsed_body = JSON.parse(response.body)
      expect(parsed_body['message']).to include 'Unable to authenticate code'
    end

    it 'should send the user\'s timeline events' do
      person = Person.create location_id: location.id
      pt = PersonTimeline.create location_id: location.id, person_id: person.id
      access_code = SecureRandom.hex
      REDIS.setex("timelinePortalCode:#{person.id}", 10, access_code)
      get :timeline, format: :json, params: { person_id: person.id, code: access_code }
      expect(response).to be_successful
      parsed_body = JSON.parse(response.body)
      expect(parsed_body['timelines'][0]['id']).to eq pt.id.to_s
    end

    it 'should not send the user\'s timeline events - incorrect access code' do
      person = Person.create location_id: location.id
      pt = PersonTimeline.create location_id: location.id, person_id: person.id
      access_code = SecureRandom.hex
      REDIS.setex("timelinePortalCode:#{person.id}", 10, access_code)
      get :timeline, format: :json, params: { person_id: person.id, code: SecureRandom.hex }
      expect(response).not_to be_successful
      parsed_body = JSON.parse(response.body)
      expect(parsed_body['message']).to include 'Unable to authenticate code'
    end
  end

  describe 'download timeline data' do
    it 'should allow users to download their data' do
      person = Person.create location_id: location.id, email: Faker::Internet.email
      access_code = SecureRandom.hex
      REDIS.setex("timelinePortalCode:#{person.id}", 10, access_code)
      expect(Sidekiq::Client).to receive(:push).with('class' => 'DownloadPersonTimeline', 'args' => [{person_id: person.id, email: person.email}])
      patch :update, format: :json, params: { person_id: person.id, code: access_code, email: person.email }
      expect(response).to be_successful
      expect(REDIS.get("timelineDataDownloaded:#{person.id}").present?).to eq true
    end

    it 'will not allow download - too soon since last download' do
      person = Person.create location_id: location.id, email: Faker::Internet.email
      access_code = SecureRandom.hex
      REDIS.setex("timelinePortalCode:#{person.id}", 10, access_code)
      patch :update, format: :json, params: { person_id: person.id, code: access_code, email: person.email }
      expect(response).to be_successful
      expect(REDIS.get("timelineDataDownloaded:#{person.id}").present?).to eq true
      patch :update, format: :json, params: { person_id: person.id, code: access_code, email: person.email }
      expect(response).not_to be_successful
      parsed_body = JSON.parse(response.body)
      expect(parsed_body['message']).to include 'Cannot download user timeline data more than once a day'
    end

    it 'will not allow download - incorrect code' do
      person = Person.create location_id: location.id, email: Faker::Internet.email
      access_code = SecureRandom.hex
      REDIS.setex("timelinePortalCode:#{person.id}", 10, access_code)
      expect(Sidekiq::Client).not_to receive(:push).with('class' => 'DownloadPersonTimeline', 'args' => [{person_id: person.id, email: person.email}])
      patch :update, format: :json, params: { person_id: person.id, code: SecureRandom.hex, email: person.email }
      expect(response).not_to be_successful
      parsed_body = JSON.parse(response.body)
      expect(parsed_body['message']).to include 'Unable to authenticate'
      expect(REDIS.get("timelineDataDownloaded:#{person.id}").present?).to eq false
    end
  end

  describe 'get person data' do
    it 'will get the general person data' do
      person = Person.create location_id: location.id, email: Faker::Internet.email
      access_code = SecureRandom.hex
      REDIS.setex("timelinePortalCode:#{person.id}", 10, access_code)
      get :show, format: :json, params: { person_id: person.id, code: access_code }
      expect(response).to be_successful
      parsed_body = JSON.parse(response.body)
      expect(parsed_body['id']).to eq person.id.to_s
    end

    it 'will not get person data - incorrect code' do
      person = Person.create location_id: location.id, email: Faker::Internet.email
      access_code = SecureRandom.hex
      REDIS.setex("timelinePortalCode:#{person.id}", 10, access_code)
      get :show, format: :json, params: { person_id: person.id, code: SecureRandom.hex }
      expect(response).not_to be_successful
      parsed_body = JSON.parse(response.body)
      expect(parsed_body['message']).to include 'Unable to authenticate code'
    end
  end

  describe 'destroy person data', focus: true do
    it 'will get the general person data' do
      person = Person.create location_id: location.id, email: Faker::Internet.email,
                             first_name: Faker::Name.first_name, last_name: Faker::Name.last_name
      access_code = SecureRandom.hex
      REDIS.setex("timelinePortalCode:#{person.id}", 10, access_code)
      test_options = {
        person_id: person.id,
        location_id: person.location_id,
        portal_request: true
      }
      expect(Sidekiq::Client).to receive(:push).with('class' => 'PersonDestroyRelations', 'args' => [test_options])
      delete :destroy, format: :json, params: { person_id: person.id, code: access_code }
      expect(response).to be_successful
      expect(REDIS.get("timelinePortalCode:#{person.id}").present?).to eq false
      expect(Person.all.size).to eq 0
    end

    it 'should not destroy - incorrect code' do
      person = Person.create location_id: location.id, email: Faker::Internet.email,
                             first_name: Faker::Name.first_name, last_name: Faker::Name.last_name
      access_code = SecureRandom.hex
      REDIS.setex("timelinePortalCode:#{person.id}", 10, access_code)
      expect(Sidekiq::Client).not_to receive(:push)
      delete :destroy, format: :json, params: { person_id: person.id, code: SecureRandom.hex }
      expect(response).not_to be_successful
      expect(REDIS.get("timelinePortalCode:#{person.id}").present?).to eq true
      expect(Person.last.id).to eq person.id
    end
  end
end
