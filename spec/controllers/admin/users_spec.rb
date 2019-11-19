require 'rails_helper'

RSpec.describe Admin::UsersController do
  describe 'GET index' do
    it_behaves_like 'requires admin' do
      let(:action) { get :index }
    end

    it_behaves_like 'requires sign in' do
      let(:action) { get :index }
    end

    context 'with valid admin credentials' do
      let(:admin) { Fabricate(:user, admin: true) }
      before do
        sign_in(admin)
        get :index
      end

      it 'renders the index template' do
        expect(response).to render_template :index
      end
    end
  end

  describe 'POST send_testimonial_link' do
    it_behaves_like 'requires admin' do
      let(:action) { post :send_testimonial_link, params: { id: 1 } }
    end

    it_behaves_like 'requires sign in' do
      let(:action) { post :send_testimonial_link, params: { id: 1 } }
    end

    context 'with valid admin credentials and valid user' do
      let(:admin) { Fabricate(:user, admin: true) }
      let(:user) { Fabricate(:user) }

      before(:each) do
        sign_in(admin)
        post :send_testimonial_link, params: { id: user.id }
      end

      it 'sets the flash success message' do
        expect(flash[:success]).to be_present
      end

      it 'redirects to the customers path' do
        expect(response).to redirect_to admin_customers_path
      end

      it 'sends out an email to the customer' do
        expect(ActionMailer::Base.deliveries.count).to eq(1)
      end
    end
  end
end
