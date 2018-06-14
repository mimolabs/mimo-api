# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Settings, type: :model do

  let!(:user) { FactoryBot.create :doorkeeper_testing_user }

  describe 'validation' do
    it 'should create a unique ID on creation' do
      user.update role: 0
      s = Settings.new business_name: 'Simon Corp', password: SecureRandom.hex, logo: 'file', favicon: 'file'
      s.save!
      expect(s.reload.unique_id).to be_present
    end

    it 'only requires a password when wizard settings creation' do
      opts = {business_name: 'Simon Corp', logo: 'file', favicon: 'file', wizard: true}
      Settings.create(opts)
      expect(Settings.all.size).to eq 0
      opts.delete(:wizard)
      Settings.create(opts)
      expect(Settings.all.size).to eq 1
      expect(Settings.last.business_name).to eq opts[:business_name]
    end
  end
end