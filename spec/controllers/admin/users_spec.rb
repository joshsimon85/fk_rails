require 'rails_helper'

RSpec.describe Admin::UsersController do
  describe 'GET index' do
    it_behaves_like 'requires admin' do
      let(:action) { get :index }
    end

    it_behaves_like 'requires sign in' do
      let(:action) { get :index }
    end

    context 'with valid admin credentials' do
      let(:admin) { Fabricate(:user, admin: true) }
      before do
        sign_in(admin)
        get :index
      end

      it 'renders the index template' do
        expect(response).to render_template :index
      end
    end
  end
end
