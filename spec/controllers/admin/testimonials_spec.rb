require 'rails_helper'

RSpec.describe Admin::TestimonialsController do
  describe 'GET index' do
    let(:user) { Fabricate(:user) }
    let(:admin) { Fabricate(:user, admin: true) }

    context 'with out user credentials' do
      before { get :index }

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
        get :index
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
        get :index
      end

      it 'renders the index template' do
        expect(response).to render_template :index
      end
    end
  end

  describe 'GET edit' do
    let(:user) { Fabricate(:user) }
    let(:admin) { Fabricate(:user, admin: true) }
    let(:testimonial) { Fabricate(:testimonial, creator_email: user.email) }

    context 'with valid admin credentials' do
      before do
        sign_in(admin)
        get :edit, params: { id: testimonial.id }
      end

      it 'renders the edit template' do
        expect(response).to render_template :edit
      end
    end

    context 'with valid user credentials' do
      before do
        sign_in(user)
        get :edit, params: { id: testimonial.id }
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
        get :edit, params: { id: testimonial.id }
      end

      it 'redirect to the root path' do
        expect(response).to redirect_to root_path
      end
    end

    context 'without sign in credentials' do
      before do
        get :edit, params: { id: testimonial.id }
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
    let(:testimonial) { Fabricate(:testimonial, creator_email: user.email, creator: user.full_name) }

    context 'with valid admin credentials and valid testimonial' do
      before do
        sign_in(admin)
        post :update, params: { id: testimonial.id, :testimonial => { :message => 'Testing', :published => true } }
      end

      it 'sets the flash success message' do
        expect(flash[:success]).to be_present
      end

      it 'redirects to the admin testimonials path' do
        expect(response).to redirect_to admin_testimonials_path
      end

      it 'updated the testimonial' do
        expect(Testimonial.first.creator).to eq(user.full_name)
        expect(Testimonial.first.message.body.to_s).to include('Testing')
        expect(Testimonial.first.published).to eq(true)
      end
    end

    context 'with valid admin credentials and invalid testimonial' do
      before do
        sign_in(admin)
        post :update, params: { :id => testimonial.id, :testimonial => { :created_by => 'Jon D.', :message => '', :published => true } }
      end

      it 'sets the error message' do
        expect(flash[:error]).to be_present
      end
    end
  end

  describe 'DELETE destroy' do
    let(:user) { Fabricate(:user) }
    let(:admin) { Fabricate(:user, admin: true) }
    let(:testimonial) { Fabricate(:testimonial, creator_email: user.email) }

    it_behaves_like 'requires admin' do
      let(:action) { delete :destroy, params: { :id => 1 } }
    end

    it_behaves_like 'requires sign in' do
      let(:action) { delete :destroy, params: { :id => 1 } }
    end

    context 'with valid admin credentials' do
      before do
        sign_in(admin)
        delete :destroy, params: { :id => testimonial.id }
      end

      it 'sets the flash success message' do
        expect(flash[:success]).to be_present
      end

      it 'removes the testimonial from the database' do
        expect(Testimonial.count).to eq(0)
      end

      it 'redirects to the testimonail path' do
        expect(response).to redirect_to admin_testimonials_path
      end
    end
  end

  describe 'DELETE destroy_multiple' do
    let(:user) { Fabricate(:user) }
    let(:user_2) { Fabricate(:user) }
    let(:admin) { Fabricate(:user, admin: true) }
    let(:testimonial) { Fabricate(:testimonial, creator_email: user.email) }
    let(:testimonial_2) { Fabricate(:testimonial, creator_email: user_2.email) }

    it_behaves_like 'requires admin' do
      let(:action) { delete :destroy_multiple, params: { :id => 1 } }
    end

    it_behaves_like 'requires sign in' do
      let(:action) { delete :destroy_multiple, params: { :id => 1 } }
    end

    context 'with valid admin credentials' do
      before do
        sign_in(admin)
        delete :destroy_multiple, params: { testimonials: { "#{testimonial.id}": 'true', "#{testimonial_2.id}": 'true'} }
      end

      it 'sets the flash success message' do
        expect(flash[:success]).to be_present
      end

      it 'removes the testimonial from the database' do
        expect(Testimonial.count).to eq(0)
      end

      it 'redirects to the testimonail path' do
        expect(response).to redirect_to admin_testimonials_path
      end
    end
  end
end
