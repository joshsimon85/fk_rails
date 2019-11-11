require 'rails_helper'

RSpec.describe Admin::PasswordsController do
  describe 'GET edit' do
    it_behaves_like 'requires admin' do
      let(:action) { get :edit }
    end

    it_behaves_like 'requires sign in' do
      let(:action) { get :edit }
    end

    it 'renders the edit template with valid admin credentials' do
      admin = Fabricate(:user, admin: true)
      sign_in(admin)
      get :edit
      expect(response).to render_template :edit
    end
  end

  describe 'PATCH edit' do
    context 'with valid admin credentials and invalid data' do
      let(:admin) { Fabricate(:user, admin: true) }

      context 'with new password blank' do
        before do
          sign_in(admin)
          patch :update, :params => {
            :user => {
              :email => admin.email,
              :password => '',
              :password_confirmation => '',
              :current_password => admin.password
            }
          }
        end

        it 'sets the flash error message' do
          expect(flash[:error]).to be_present
        end

        it 'renders the edit template' do
          expect(response).to render_template :edit
        end
      end

      context 'with non matching password and password confirmation' do
        before do
          sign_in(admin)
          patch :update, :params => {
            :user => {
              :email => admin.email,
              :password => 'password',
              :password_confirmation => 'non matching',
              :current_password => admin.password
            }
          }
        end

        it 'sets the flash error message' do
          expect(flash[:error]).to be_present
        end

        it 'renders the edit template' do
          expect(response).to render_template :edit
        end
      end

      context 'with incorrect current password' do
        before do
          sign_in(admin)
          patch :update, :params => {
            :user => {
              :email => admin.email,
              :password => 'password',
              :password_confirmation => 'non matching',
              :current_password => 'none'
            }
          }
        end

        it 'sets the flash error message' do
          expect(flash[:error]).to be_present
        end

        it 'renders the edit template' do
          expect(response).to render_template :edit
        end
      end
    end

    context 'with valid admin credentials and valid inputs' do
      let(:admin) { Fabricate(:user, admin: true) }

      before do
        sign_in(admin)
        patch :update, :params => {
          :user => {
            :email => admin.email,
            :password => 'password',
            :password_confirmation => 'password',
            :current_password => admin.password
          }
        }
      end

      it 'sets the flash success message' do
        expect(flash[:success]).to be_present
      end

      it 'rediects to the admin root path' do
        expect(response).to redirect_to admin_root_path
      end

      it 'updates the password' do
        expect(User.first.encrypted_password).not_to eq(admin.encrypted_password)
      end
    end
  end
end
