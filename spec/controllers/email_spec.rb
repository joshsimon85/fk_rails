require 'rails_helper'

RSpec.describe EmailsController do
  describe 'POST create' do
    context 'with all valid inputs' do
      before do
        ActionMailer::Base.deliveries.clear
        post :create, params: { email: Fabricate.attributes_for(:email , full_name: 'Jon Doe', phone_number: Faker::PhoneNumber.phone_number) }
      end

      it 'redirects to the root path' do
        expect(response).to redirect_to root_path
      end

      it 'sets a flash success message' do
        expect(flash[:success]).to be_present
      end

      it 'adds the email to the database' do
        expect(Email.first.full_name).to eq('Jon Doe')
      end

      it 'sends out an email to the email creator' do
        sleep(1)
        expect(ActionMailer::Base.deliveries.count).to eq(2)
        expect(ActionMailer::Base.deliveries.last.to).to eq(['kasey@frankenkopter.com'])
        expect(ActionMailer::Base.deliveries.first.from).to eq(['support@frankenkopter.com'])
      end
    end

    context 'with all valid inputs and no phone number' do
      it 'adds the email to the database' do
        post :create, params: { email: Fabricate.attributes_for(:email, full_name: 'Jon Doe') }
        expect(Email.first.full_name).to eq('Jon Doe')
      end
    end

    context 'with invalid inputs' do
      it 'renders the contact template' do
        post :create, params: { email: { full_name: 'Jon Doe'} }
        expect(response).to render_template('emails/new')
      end

      it 'does not save the record to the database' do
        post :create, params: { email: { email: 'jon@doe.com'} }
        expect(Email.count).to be(0)
      end
    end
  end
end
