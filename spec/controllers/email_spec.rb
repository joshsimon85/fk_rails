require 'rails_helper'

RSpec.describe EmailsController do
  describe 'POST create' do
    before(:each) do
      sleep(0.1)
      ActionMailer::Base.deliveries.clear
    end

    context 'with all valid inputs' do
      before(:each) do
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
        sleep(0.1)
        expect(ActionMailer::Base.deliveries.count).to eq(2)
        expect(ActionMailer::Base.deliveries.last.to).to eq(['support@frankenkopter.com'])
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

  describe 'GET index' do
    context 'with logged in valid admin' do
      let(:admin) { Fabricate(:user, admin: true) }

      it 'renders the index template with valid admin' do
        sign_in(admin, scope: :user)
        get :index, params: { admin_id: admin.id }
        expect(response).to render_template(:index)
      end
    end

    context 'with logged in user that is not an admin' do
      let(:user) { Fabricate(:user) }

      before(:each) do
        sign_in(user, scope: :user)
        get :index, params: { admin_id: user.id }
      end

      it 'redirects to the root path' do
        expect(response).to redirect_to(root_path)
      end

      it 'sets the flash error message' do
        expect(flash[:error]).to be_present
      end
    end

    context 'with non authenticated user' do
      let(:user) { Fabricate(:user) }

      before(:each) do
        get :index, params: { admin_id: user.id }
      end

      it 'redirects to the sign in path' do
        expect(response).to redirect_to(new_user_session_path)
      end

      it 'sets the flash alert message' do
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe 'GET show' do
    let(:email) { Fabricate(:email) }

    context 'with authenticated admin' do
      let(:admin) { Fabricate(:user, admin: true) }

      it 'renders the show page' do
        sign_in(admin, scope: :user)
        get :show, params: { admin_id: admin.id, id: email.id }
        expect(response).to render_template(:show)
      end
    end

    context 'with authenticated user without admin credentials' do
      let(:user) { Fabricate(:user) }

      before(:each) do
        sign_in(user, scope: :user)
        get :show, params: { admin_id: user.id, id: email.id }
      end

      it 'redirects to the root path' do
        expect(response).to redirect_to(root_path)
      end

      it 'sets the flash error message' do
        expect(flash[:error]).to be_present
      end
    end

    context 'without authenticated user' do
      let(:user) { Fabricate(:user) }

      before(:each) do
        get :show, params: { admin_id: user.id, id: email.id }
      end

      it 'redirects to the root path' do
        expect(response).to redirect_to(new_user_session_path)
      end

      it 'sets the flash error message' do
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe 'POST destroy' do
    let(:email) { Fabricate(:email) }

    context 'with authenticated admin' do
      let(:admin) { Fabricate(:user, admin: true) }

      before(:each) do
        sign_in(admin, scope: :user)
        delete :destroy, params: { admin_id: admin.id, id: email.id }
      end

      it 'sets the flash success message' do
        expect(flash[:success]).to be_present
      end

      it 'redirects to the admin emails page and sets the query string to default page 1 and order desc' do
        expect(response).to redirect_to(admin_emails_path(admin, :order => 'desc', :page => 1))
      end

      it 'deletes the record from the database' do
        expect(Email.count).to eq(0)
      end
    end

    context 'with authenticated user without admin credentials' do
      let(:user) { Fabricate(:user) }

      before(:each) do
        sign_in(user, scope: :user)
        delete :destroy, params: { admin_id: user.id, id: email.id }
      end

      it 'redirects to the root path' do
        expect(response).to redirect_to(root_path)
      end

      it 'sets the flash error message' do
        expect(flash[:error]).to be_present
      end
    end

    context 'with unauthenticated user' do
      let(:user) { Fabricate(:user) }

      before(:each) do
        delete :destroy, params: { admin_id: user.id, id: email.id }
      end

      it 'redirects to the root path' do
        expect(response).to redirect_to(new_user_session_path)
      end

      it 'sets the flash error message' do
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe 'POST destroy_multiple' do
    let(:email) { Fabricate(:email) }
    let(:email_2) { Fabricate(:email) }
    let(:admin) { Fabricate(:user, admin: true) }
    let(:user) { Fabricate(:user) }

    context 'with authenticated admin' do
      before(:each) do
        sign_in(admin, scope: :user)
        delete :destroy_multiple, params: { admin_id: admin.id, emails: { "#{email.id}": 'true', "#{email_2.id}": 'true'}}
      end

      it 'sets the flash success message' do
        expect(flash[:success]).to be_present
      end

      it 'redirects to the admin emails page' do
        expect(response).to redirect_to(admin_emails_path(admin, :order => 'desc', :page => 1))
      end

      it 'deletes the record from the database' do
        expect(Email.count).to eq(0)
      end
    end

    context 'with authenticated user without admin credentials' do
      before(:each) do
        sign_in(user, scope: :user)
        delete :destroy, params: { admin_id: user.id, id: email.id }
      end

      it 'redirects to the root path' do
        expect(response).to redirect_to(root_path)
      end

      it 'sets the flash error message' do
        expect(flash[:error]).to be_present
      end
    end

    context 'with unauthenticated user' do
      before(:each) do
        delete :destroy, params: { admin_id: user.id, id: email.id }
      end

      it 'redirects to the root path' do
        expect(response).to redirect_to(new_user_session_path)
      end

      it 'sets the flash error message' do
        expect(flash[:alert]).to be_present
      end
    end
  end
end
