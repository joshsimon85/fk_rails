require 'rails_helper'

RSpec.describe Users::TestimonialsController do
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
    context 'with invalid token' do
      let(:user) { Fabricate(:user) }

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
      let(:user) { Fabricate(:user) }

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
      let(:user) { Fabricate(:user) }
      let(:token) { user.testimonial_token }

      before  do
        post :create, params: { token: user.testimonial_token, testimonial: { message: Faker::Lorem.paragraphs(number: 5).join(', ') } }
      end

      it 'sets the flash success message' do
        expect(flash[:success]).to be_present
      end

      it 'redirects to the root path' do
        expect(response).to redirect_to root_path
      end

      it 'adds and saves the testimonial' do
        expect(Testimonial.count).to eq(1)
      end

      it 'generates a new user token for that user' do
        user.reload
        expect(user.testimonial_token).not_to eq(token)
      end
    end
  end

  describe 'GET edit' do
    it_behaves_like 'requires sign in' do
      let(:action) { get :edit}
    end

    context 'with valid user credentials' do
      it 'renders the edit template' do
        user = Fabricate(:user)
        sign_in(user)
        get :edit
        expect(response).to render_template :edit
      end
    end
  end

  describe 'PATCH update' do
    let!(:user) { Fabricate(:user) }
    let!(:testimonial) { Fabricate(:testimonial, user_id: user.id) }

    it_behaves_like 'requires sign in' do
      let(:action) { patch :update }
    end

    context 'with valid inputs and valid user credentials' do
      before do
        sign_in(user)
        patch :update, :params => { :testimonial => { :message => 'Message' } }
      end

      it 'should set the flash success message' do
        expect(flash[:success]).to be_present
      end

      it 'should redirect to the edit user registration path' do
        expect(response).to redirect_to edit_user_registration_path
      end

      it 'should update the testimonial message' do
        expect(Testimonial.first.message.body.to_s).to include('Message')
      end
    end

    context 'with invalid inputs and valid user credentials' do
      before do
        sign_in(user)
        patch :update, :params => { :testimonial => { :message => '' } }
      end

      it 'should set the flash error message' do
        expect(flash[:error]).to be_present
      end

      it 'should render the edit template' do
        expect(response).to render_template :edit
      end

      it 'should not update the testimonial message' do
        expect(Testimonial.first.message.body).not_to eq('')
      end
    end
  end

  describe 'DELETE destroy' do
    let!(:user) { Fabricate(:user) }
    let!(:testimonial) { Fabricate(:testimonial, user_id: user.id) }

    it_behaves_like 'requires sign in' do
      let(:action) { delete :destroy }
    end

    context 'with valid user credentials and an existing testimonial' do
      before do
        sign_in(user)
        delete :destroy
      end

      it 'sets the flash success message' do
        expect(flash[:success]).to be_present
      end

      it 'redicets to the edit user registration path' do
        expect(response).to redirect_to edit_user_registration_path
      end

      it 'deletes the record' do
        expect(Testimonial.count).to eq(0)
      end
    end
  end
end
