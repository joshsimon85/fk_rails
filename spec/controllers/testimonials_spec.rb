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

  describe 'GET edit' do
    let(:user) { Fabricate(:user) }
    let(:admin) { Fabricate(:user, admin: true) }
    let(:testimonial) { Fabricate(:testimonial, user_id: user.id) }

    context 'with valid admin credentials' do
      before do
        sign_in(admin)
        get :edit, params: { admin_id: admin.id, id: testimonial.id }
      end

      it 'renders the edit template' do
        expect(response).to render_template :edit
      end
    end

    context 'with valid user credentials' do
      before do
        sign_in(user)
        get :edit, params: { admin_id: admin.id, id: testimonial.id }
      end

      it 'sets the flash message' do
        expect(flash[:error]).to be_present
      end

      it 'does not render the edit template' do
        expect(response).to redirect_to root_path
      end
    end

    context 'with valid user credentials and user params' do
      before do
        sign_in(user)
        get :edit, params: { admin_id: user.id, id: testimonial.id }
      end

      it 'redirect to the root path' do
        expect(response).to redirect_to root_path
      end
    end

    context 'without sign in credentials' do
      before do
        get :edit, params: { admin_id: admin.id, id: testimonial.id }
      end

      it 'sets the flash message' do
        expect(flash[:alert]).to be_present
      end

      it 'redirects to the root path' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'POST update' do
    let(:user) { Fabricate(:user) }
    let(:admin) { Fabricate(:user, admin: true) }
    let(:testimonial) { Fabricate(:testimonial, user_id: user.id) }

    context 'with valid admin credentials and valid testimonial' do
      before do
        sign_in(admin)
        post :update, params: { admin_id: user.id, id: testimonial.id, :testimonial => { :created_by => 'Jon D.', :message => 'Testing', :published => true } }
      end

      it 'sets the flash success message' do
        expect(flash[:success]).to be_present
      end

      it 'redirects to the admin testimonials path' do
        expect(response).to redirect_to admin_testimonials_path(admin)
      end

      it 'updated the testimonial' do
        expect(Testimonial.first.created_by).to eq('Jon D.')
        expect(Testimonial.first.message.body.to_s).to include('Testing')
        expect(Testimonial.first.published).to eq(true)
      end
    end

    context 'with valid admin credentials and invalid testimonial' do
      before do
        sign_in(admin)
        post :update, params: { admin_id: user.id, :id => testimonial.id, :testimonial => { :created_by => 'Jon D.', :message => '', :published => true } }
      end

      it 'sets the error message' do
        expect(flash[:error]).to be_present
      end
    end

    context 'with invalid credentials' do

    end
  end
end
