require 'rails_helper'

RSpec.describe TestimonialsController do
  describe 'GET new' do
    context 'with invalid token' do
      before do
        get :new, params: { :token => 'abc' }
      end

      it 'sets the flash error message' do
        expect(flash[:error]).to be_present
      end

      it 'redirects to the expired token path' do
        expect(response).to redirect_to expired_token_path
      end
    end

    context 'without a token' do
      let(:user) { Fabricate(:user) }

      it 'renders the new template' do
        get :new, params: { :token => user.testimonial_token }
        expect(response).to render_template :new
      end
    end
  end

  describe 'POST create' do
    let(:user) { Fabricate(:user) }

    context 'with invalid token' do
      before  do
        post :create, params: { token: 'abc', testimonial: { message: 'Lorem Ipsum' } }
      end

      it 'sets the flash error message' do
        expect(flash[:error]).to be_present
      end

      it 'redirects to expired token path' do
        expect(response).to redirect_to expired_token_path
      end

      it 'does not create the testimonial' do
        expect(Testimonial.count).to eq(0)
      end
    end

    context 'with valid token without a valid message' do
      before  do
        post :create, params: { token: user.testimonial_token, testimonial: { message: '' } }
      end

      it 'sets the flash error message' do
        expect(flash[:error]).to be_present
      end

      it 'renders the new template' do
        expect(response).to render_template :new
      end

      it 'does not create the testimonial' do
        expect(Testimonial.count).to eq(0)
      end
    end

    context 'with valid token and valid message' do
      it 'sets the flash success message' do
        post :create, params: { token: user.testimonial_token, testimonial: { message: Faker::Lorem.paragraphs(number: 5).join(', ') } }
        expect(flash[:success]).to be_present
      end

      it 'redirects to the root path' do
        post :create, params: { token: user.testimonial_token, testimonial: { message: Faker::Lorem.paragraphs(number: 5).join(', ') } }
        expect(response).to redirect_to root_path
      end

      it 'adds saves the testimonial' do
        post :create, params: { token: user.testimonial_token, testimonial: { message: Faker::Lorem.paragraphs(number: 5).join(', ') } }
        expect(Testimonial.count).to eq(1)
      end

      it 'generates a new user token for that user' do
        token = user.testimonial_token
        post :create, params: { token: user.testimonial_token, testimonial: { message: Faker::Lorem.paragraphs(number: 5).join(', ') } }
        user.reload
        expect(user.testimonial_token).not_to eq(token)
      end
    end
  end

  describe 'GET index' do
    let(:user) { Fabricate(:user) }
    let(:admin) { Fabricate(:user, admin: true) }

    context 'with out user credentials' do
      before { get :index, params: { admin_id: admin.id } }

      it 'sets the flash alert message' do
        expect(flash[:alert]).to be_present
      end

      it 'redirects to sign in path' do
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'with valid user without admin credentials' do
      before do
        sign_in(user)
        get :index, params: { admin_id: admin.id }
      end

      it 'sets the flash error message' do
        expect(flash[:error]).to be_present
      end

      it 'redirects to the root path' do
        expect(response).to redirect_to root_path
      end
    end

    context 'with valid admin credentials' do
      before do
        sign_in(admin)
        get :index, params: { admin_id: admin.id }
      end

      it 'renders the index template' do
        expect(response).to render_template :index
      end
    end
  end
end
