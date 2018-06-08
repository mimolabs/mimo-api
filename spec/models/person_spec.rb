require 'rails_helper'

RSpec.describe Person, type: :model do
  describe '#portal_timeline_code' do
    it 'should get the portal access code for a person' do
      code = SecureRandom.hex
      REDIS.setex("timelinePortalCode:123", 5, code)
      expect(REDIS.get("timelinePortalCode:321")).to eq nil
      expect(REDIS.get("timelinePortalCode:123")).to eq code
    end
  end

  describe '#create_timeline' do
    it 'should create sidekiq job' do
      email = Faker::Internet.email
      expect(Sidekiq::Client).to receive(:push).with('class' => 'PersonTimelineRequest', 'args' => [email: email])
      Person.create_timeline(email)
    end
  end

  describe '#download_timeline' do
    it 'should create sidekiq job + save processed download to redis' do
      person = Person.create email: Faker::Internet.email
      expect(Sidekiq::Client).to receive(:push).with('class' => 'DownloadPersonTimeline', 'args' => [person_id: person.id, email: person.email])
      person.download_timeline(person.email)
      expect(REDIS.get("timelineDataDownloaded:#{person.id}")).to eq 'true'
    end

    it 'should not process download twice within one day' do
      person = Person.create email: Faker::Internet.email
      person.download_timeline(person.email)
      expect(Sidekiq::Client).not_to receive(:push)
      person.download_timeline(person.email)
    end

    it 'should not process download - no email' do
      person = Person.create
      expect(Sidekiq::Client).not_to receive(:push)
      person.download_timeline(person.email)
      expect(REDIS.get("timelineDataDownloaded:#{person.id}")).to eq nil
    end
  end

  describe 'destroy process' do
    it 'should run sidekiq destroy relations job' do
      person = Person.create location_id: 123
      expect(Sidekiq::Client).to receive(:push).with('class' => 'PersonDestroyRelations', 'args' => [person_id: person.id, location_id: 123])
      person.destroy
    end

    it 'should record portal request for worker + clear access code' do
      person = Person.create id: 456, location_id: 123
      REDIS.setex("timelinePortalCode:#{456}", 5, SecureRandom.hex)
      expect(Sidekiq::Client).to receive(:push).with('class' => 'PersonDestroyRelations', 'args' => [person_id: person.id, location_id: 123, portal_request: true])
      person.portal_request_destroy
      expect(REDIS.get("timelinePortalCode:#{456}")).to eq nil
    end
  end
end