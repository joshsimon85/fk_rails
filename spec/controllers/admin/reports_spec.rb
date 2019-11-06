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
    let(:report) { Fabricate(:report) }

    it_behaves_like 'requires admin' do
      let(:action) { delete :destroy, params: { :id => report.id } }
    end

    it_behaves_like 'requires sign in' do
      let(:action) { delete :destroy, params: { :id => report.id } }
    end

    context 'with valid admin credentials' do
      before do
        sign_in(admin)
        delete :destroy, params: { :id => report.id }
      end

      it 'sets the flash message' do
        expect(flash[:success]).to be_present
      end

      it 'redirects to the admin reports path' do
        expect(response).to redirect_to admin_reports_path(order: 'desc', page: '1')
      end

      it 'deletes the record from the database' do
        expect(Report.count).to eq(0)
      end
    end
  end

  describe 'DELETE delete_multiple' do
    let(:report) { Fabricate(:report) }
    let(:report_1) { Fabricate(:report) }
    let(:report_2) { Fabricate(:report) }

    it_behaves_like 'requires admin' do
      let(:action) { delete :destroy_multiple, params: { reports: { "#{report.id}": 'true', "#{report_2.id}": 'true' } }}
    end

    it_behaves_like 'requires sign in' do
      let(:action) { delete :destroy_multiple, params: { reports: { "#{report.id}": 'true', "#{report_2.id}": 'true' } }}
    end

    context 'with valid admin credentials' do
      before do
        sign_in(admin)
        delete :destroy_multiple, params: { reports: { "#{report.id}": 'true', "#{report_2.id}": 'true' } }
      end

      it 'sets the flash success message' do
        expect(flash[:success]).to be_present
      end

      it 'redirect to the admin reports path' do
        expect(response).to redirect_to admin_reports_path(order: 'desc', page: '1')
      end

      it 'deletes the records that are specified' do
        expect(Report.count).to eq(1)
      end
    end
  end
end
