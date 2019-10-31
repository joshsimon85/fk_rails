require 'rails_helper'

RSpec.describe Admin::HighlightsController do
  describe 'GET new' do
    let(:admin) { Fabricate(:user, admin: true) }
    let(:user) { Fabricate(:user) }
    let(:testimonial) { Fabricate(:testimonial, user_id: user.id) }

    context 'with valid admin credentials' do
      before do
        sign_in(admin)
        get :new, params: { :testimonial_id => testimonial.id }
      end

      it 'renders the new template' do
        expect(response).to render_template :new
      end
    end

    context 'with valid user credentials' do
      before do
        sign_in(user)
        get :new, params: { :testimonial_id => testimonial.id }
      end

      it 'redirects to the root path' do
        expect(response).to redirect_to root_path
      end

      it 'sets the flash error message' do
        expect(flash[:error]).to be_present
      end
    end

    context 'without credentials' do
      before { get :new, params: { :testimonial_id => testimonial.id } }

      it 'sets the flash alert message' do
        expect(flash[:alert]).to be_present
      end

      it 'redirects to the sign in path' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'POST create' do
    it_behaves_like 'requires_admin' do
      let(:action) { post :create }
    end 
  end
end
