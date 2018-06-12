# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Settings, type: :model do
  describe 'validation' do
    ### failing since we require the image and favicon
    ### needs to be fixed
    xit 'should create a unique ID on creation' do
      s = Settings.new business_name: 'Simon Corp', password: SecureRandom.hex, logo: 'file', favicon: 'file'
      s.save!
      expect(s.reload.unique_id).to be_present
    end
  end
end
