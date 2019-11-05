require 'rails_helper'

RSpec.describe Admin::ReportsController do
  let(:admin) { Fabricate(:user, admin: true) }

  describe 'GET index' do
    it_behaves_like 'requires admin' do
      let(:action) { get :index }
    end

    it_behaves_like 'requires sign in' do
      let(:action) { get :index }
    end

    context 'with valid admin credentials' do
      it 'should render the index template' do
        sign_in(admin)
        get :index
        expect(response).to render_template(:index)
      end
    end
  end

  describe 'DELETE destroy' do
    let(:report) {
      Report.create(
        :error_type => 'Error',
        :process => 'Email Workder',
        :message => "Could not find a record with 'id=3'"
      )
    }

    it_behaves_like 'requires admin' do
      let(:action) { delete :destroy, params: { :id => report.id } }
    end

    it_behaves_like 'requires sign in' do
      let(:action) { delete :destroy, params: { :id => report.id } }
    end

    context 'with valid admin credentials' do
      let(:admin) { Fabricate(:user, admin: true) }

      it 'sets the flash message' do
        sign_in(:admin)
        delete :destroy, params: { :id => report.id }
        expect(flash[:success]).to be_present
      end
    end
  end
end
