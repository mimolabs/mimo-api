require 'rails_helper'

describe Api::V1::PeopleController, :type => :controller do

  let(:token) { double :acceptable? => true }

  before do
    allow(controller).to receive(:doorkeeper_token) { token }
  end

  let!(:application) { FactoryBot.create :application } # OAuth application
  let!(:user)        { FactoryBot.create :doorkeeper_testing_user }
  let!(:token)       { FactoryBot.create :access_token, :application => application, :resource_owner_id => user.id }

  let(:location) { Location.create user_id: user.id }

  describe "testing the routes mostly" do
    it "should not render the splash pages index" do
      location = Location.create id: 1, user_id: 123978123

      get :index, format: :json, params: { location_id: location.slug }
      expect(response).to_not be_successful
    end

    it "should render the people index" do
      Person.create location_id: location.id

      get :index, format: :json, params: { location_id: location.slug }
      expect(response).to be_successful

      parsed_body = JSON.parse(response.body)
      expect(parsed_body['people'].length).to eq 1
    end

    context 'show action' do
      it 'should allow the user to view a person' do
        s = Person.create location_id: location.id

        get :show, format: :json, params: { id: s.id, location_id: location.slug }
        expect(response).to be_successful
      end
    end

    context 'create action' do
      it 'should allow the user to create a splash page' do
        post :create, format: :json, params: { location_id: location.slug, person: { last_name: 'Morley' } }
        expect(response).to be_successful
        s = Person.last
        expect(s.last_name).to eq 'Morley'
      end
    end

    context 'show action' do
      it 'should allow the user to view their location' do
        s = Person.create location_id: location.id
        patch :update, format: :json, params: { location_id: location.slug, id: s.id, person: { first_name: 'Simon' } }
        expect(response).to be_successful
        expect(s.reload.first_name).to eq 'Simon'
      end
    end

    context 'delete action' do
      it 'should allow the user to view their splash' do
        s = Person.create location_id: location.id
        delete :destroy, format: :json, params: { location_id: location.slug, id: s.id }
        expect(response).to be_successful
      end
    end

  end
end
