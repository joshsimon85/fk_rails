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

  describe 'GET new' do
    let(:admin) { Fabricate(:user, admin: true) }

    it_behaves_like 'requires admin' do
      let(:action) { get :new }
    end

    it_behaves_like 'requires sign in' do
      let(:action) { get :new }
    end

    context 'with valid admin credentials' do
      before do
        sign_in(admin)
        get :new
      end

      it 'renders the new template' do
        expect(response).to render_template :new
      end
    end
  end

  describe 'POST create' do
    let(:admin) { Fabricate(:user, admin: true) }

    it_behaves_like 'requires admin' do
      let(:action) { post :create }
    end

    it_behaves_like 'requires sign in' do
      let(:action) { get :create }
    end

    context 'with valid admin credentials, valid testimonial and valid highlight' do
      before do
        sign_in(admin)
        post :create, :params => {
          :testimonial => {
            :creator => 'Jon Doe',
            :creator_email => 'testimonial@frankenkopter.com',
            :message => 'Testimonial message',
            :published => 'true',
            :highlight  => 'Testimonial highlight'
          }
        }
      end

      it 'sets the flash success message' do
        expect(flash[:success]).to be_present
      end

      it 'redirectes to the the admin testimonial path' do
        expect(response).to redirect_to admin_testimonials_path
      end

      it 'creates the testimonial and saves it to the db' do
        expect(Testimonial.first.creator).to eq('Jon Doe')
      end

      it 'sets the testimonial published to true' do
        expect(Testimonial.first.published).to eq(true)
      end

      it 'creates the highlight and saves it to the db' do
        expect(Testimonial.first.highlight).to be_present
      end
    end

    context 'with valid admin credentials and valid testimonial' do
      before do
        sign_in(admin)
        post :create, :params => {
          :testimonial => {
            :creator => 'Jon Doe',
            :creator_email => 'testimonial@frankenkopter.com',
            :message => 'Testimonial message',
            :published => 'false',
            :highlight => ''
          }
        }
      end

      it 'sets the flash success message' do
        expect(flash[:success]).to be_present
      end

      it 'redirectes to the the admin testimonial path' do
        expect(response).to redirect_to admin_testimonials_path
      end

      it 'creates the testimonial and saves it to the db' do
        expect(Testimonial.first.creator).to eq('Jon Doe')
      end

      it 'sets the testimonial published to false' do
        expect(Testimonial.first.published).to eq(false)
      end

      it 'creates the highlight and saves it to the db' do
        expect(Testimonial.first.highlight).not_to be_present
      end
    end

    context 'with valid admin credentials and invalid testimonial' do
      before do
        sign_in(admin)
        post :create, :params => {
          :testimonial => {
            :creator => 'Jon Doe',
            :creator_email => 'testimonial@frankenkopter.com',
            :message => '',
            :published => 'true',
            :highlight => ''
          }
        }
      end

      it 'sets the flash error message' do
        expect(flash[:error]).to be_present
      end

      it 'renders the new template' do
        expect(response).to render_template :new
      end

      it 'creates the testimonial and saves it to the db' do
        expect(Testimonial.first).not_to be_present
      end
    end

    context 'with valid admin credentials and missing creator' do
      before do
        sign_in(admin)
        post :create, :params => {
          :testimonial => {
            :creator => '',
            :creator_email => 'testimonial@frankenkopter.com',
            :message => 'Testimonial',
            :published => 'true',
            :highlight => ''
          }
        }
      end

      it 'sets the flash error message' do
        expect(flash[:error]).to be_present
      end

      it 'renders the new template' do
        expect(response).to render_template :new
      end

      it 'creates the testimonial and saves it to the db' do
        expect(Testimonial.first).not_to be_present
      end
    end

    context 'with valid admin credentials and invalid highlight' do
      before do
        sign_in(admin)
        post :create, :params => {
          :testimonial => {
            :creator => 'Jon Doe',
            :creator_email => 'testimonial@frankenkopter.com',
            :message => 'Testimonial',
            :published => 'true',
            :highlight => Faker::Lorem.characters(number: 151)
          }
        }
      end

      it 'sets the flash error message' do
        expect(flash[:error]).to be_present
      end

      it 'creates the testimonial and saves it to the db' do
        expect(Testimonial.first).to be_present
      end

      it 'does not create and save the highlight' do
        expect(Highlight.first).not_to be_present
      end

      it 'redirects to the new admin testimonail highlight path' do
        expect(response).to redirect_to new_admin_testimonial_highlight_path(Testimonial.first.id)
      end
    end
  end
end
