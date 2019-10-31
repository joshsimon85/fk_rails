require 'rails_helper'

RSpec.describe Admin::EmailsController do
  describe 'GET index' do
    context 'with logged in valid admin' do
      let(:admin) { Fabricate(:user, admin: true) }

      it 'renders the index template with valid admin' do
        sign_in(admin, scope: :user)
        get :index
        expect(response).to render_template(:index)
      end
    end

    context 'with logged in user that is not an admin' do
      let(:user) { Fabricate(:user) }

      before(:each) do
        sign_in(user, scope: :user)
        get :index
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
        get :index
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
        get :show, params: { id: email.id }
        expect(response).to render_template(:show)
      end
    end

    context 'with authenticated user without admin credentials' do
      let(:user) { Fabricate(:user) }

      before(:each) do
        sign_in(user, scope: :user)
        get :show, params: { id: email.id }
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
        get :show, params: { id: email.id }
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
        delete :destroy, params: { id: email.id }
      end

      it 'sets the flash success message' do
        expect(flash[:success]).to be_present
      end

      it 'redirects to the admin emails page and sets the query string to default page 1 and order desc' do
        expect(response).to redirect_to(admin_emails_path(:order => 'desc', :page => 1))
      end

      it 'deletes the record from the database' do
        expect(Email.count).to eq(0)
      end
    end

    context 'with authenticated user without admin credentials' do
      let(:user) { Fabricate(:user) }

      before(:each) do
        sign_in(user, scope: :user)
        delete :destroy, params: { id: email.id }
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
        delete :destroy, params: { id: email.id }
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
        delete :destroy_multiple, params: { emails: { "#{email.id}": 'true', "#{email_2.id}": 'true'}}
      end

      it 'sets the flash success message' do
        expect(flash[:success]).to be_present
      end

      it 'redirects to the admin emails page' do
        expect(response).to redirect_to(admin_emails_path(:order => 'desc', :page => 1))
      end

      it 'deletes the record from the database' do
        expect(Email.count).to eq(0)
      end
    end

    context 'with authenticated user without admin credentials' do
      before(:each) do
        sign_in(user, scope: :user)
        delete :destroy, params: { id: email.id }
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
        delete :destroy, params: { id: email.id }
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
