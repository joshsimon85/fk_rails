require 'rails_helper'

RSpec.describe Admin::HighlightsController do
  describe 'GET new' do
    let(:admin) { Fabricate(:user, admin: true) }
    let(:user) { Fabricate(:user) }
    let(:testimonial) { Fabricate(:testimonial, user_id: user.id) }

    context 'with valid admin credentials' do
      before do
        sign_in(admin)
        get :new, params: { :testimonial_id => testimonial.id }
      end
    end

    context 'with valid user credentials' do
      it 'renders the new template' do
        binding.pry
        expect(response).to render_template(:new)
      end
    end

    context 'without credentials' do

    end
  end
end
