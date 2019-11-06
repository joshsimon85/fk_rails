require 'rails_helper'

RSpec.describe Admin::AdminsController do
  let(:admin) { Fabricate(:user, full_name: 'Jane Doe', admin: true) }

  describe 'GET index' do
    it_behaves_like 'requires admin' do
      let(:action) { get :index }
    end

    it_behaves_like 'requires sign in' do
      let(:action) { get :index }
    end

    context 'with valid admin credentails' do
      it 'renders the index template' do
        sign_in(admin)
        get :index
        expect(response).to render_template(:index)
      end
    end
  end

  describe 'GET edit' do
    it_behaves_like 'requires admin' do
      let(:action) { get :edit }
    end

    it_behaves_like 'requires sign in' do
      let(:action) { get :edit }
    end

    context 'with valid admin credentials' do
      it 'renders the edit template' do
        sign_in(admin)
        get :edit
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'PATCH update' do
    it_behaves_like 'requires admin' do
      let(:action) { patch :update }
    end

    it_behaves_like 'requires sign in' do
      let(:action) { patch :update }
    end

    context 'with valid admin credentials and invalid inputs' do
      before do
        sign_in(admin)
        patch :update, params: { user: { :full_name => '' } }
      end

      it 'sets the flash error message' do
        expect(flash[:error]).to be_present
      end

      it 'renders the edit template' do
        expect(response).to render_template(:edit)
      end
    end

    context 'with valid admin credentials and valid inputs' do
      before do
        sign_in(admin)
        patch :update, params: { user: { :full_name => 'Jon Doe' } }
      end

      it 'sets the flash success message' do
        expect(flash[:success]).to be_present
      end

      it 'redirects to the admin root path' do
        expect(response).to redirect_to admin_root_path
      end

      it 'updates the signed in admins profile' do
        expect(User.first.full_name).to eq('Jon Doe')
      end
    end
  end
end
