# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Settings, type: :model do
  describe 'validation' do
    it 'should create a unique ID on creation' do
      s = Settings.new
      s.save!
      expect(s.reload.unique_id).to be_present
    end
  end
end
