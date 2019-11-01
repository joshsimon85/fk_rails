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

      it 'renders the new template' do
        expect(response).to render_template :new
      end
    end

    context 'with valid user credentials' do
      before do
        sign_in(user)
        get :new, params: { :testimonial_id => testimonial.id }
      end

      it 'redirects to the root path' do
        expect(response).to redirect_to root_path
      end

      it 'sets the flash error message' do
        expect(flash[:error]).to be_present
      end
    end

    context 'without credentials' do
      before { get :new, params: { :testimonial_id => testimonial.id } }

      it 'sets the flash alert message' do
        expect(flash[:alert]).to be_present
      end

      it 'redirects to the sign in path' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'POST create' do
    let(:admin) { Fabricate(:user, admin: true) }
    let(:user) { Fabricate(:user) }
    let(:testimonial) { Fabricate(:testimonial, user_id: user.id) }

    it_behaves_like 'requires admin' do
      let(:action) { post :create, params: { :testimonial_id => 1, :highlight => { :highlight => 'Highlight' } } }
    end

    it_behaves_like 'requires sign in' do
      let(:action) { post :create, params: { :testimonial_id => 1, :highlight => { :highlight => 'Highlight' } } }
    end

    context 'with valid adimin credentials' do
      before { sign_in(admin) }

      context 'with valid highlight' do
        before do
          post :create, params: { :testimonial_id => testimonial.id, :highlight => { :highlight => 'Highlight' } }
        end

        it 'sets the flash success message' do
          expect(flash[:success]).to be_present
        end

        it 'adds the highlight to the db and associates it with the testimonial' do
          expect(Highlight.count).to eq(1)
          expect(Highlight.first.testimonial_id).to eq(testimonial.id)
        end
      end

      context 'with invalid hightlight' do
        before do
          post :create, params: { :testimonial_id => testimonial.id, :highlight => { :highlight => '' } }
        end

        it 'sets the flash error message' do
          expect(flash[:error]).to be_present
        end

        it 'does renders the new template' do
          expect(response).to render_template :new
        end

        it 'does not add the highlight to the database' do
          expect(Highlight.count).to eq(0)
        end
      end
    end
  end

  describe 'GET edit' do
    let(:admin) { Fabricate(:user, admin: true) }
    let(:user) { Fabricate(:user) }
    let(:testimonial) { Fabricate(:testimonial, user_id: user.id) }
    let(:hightlight) { Fabricate(:highlight, testimonial_id: testimonial.id) }

    it_behaves_like 'requires admin' do
      let(:action) { get :edit, params: { :testimonial_id => 1 } }
    end

    it_behaves_like 'requires sign in' do
      let(:action) { get :edit, params: { :testimonial_id => 1 } }
    end

    context 'with valid admin credentials' do
      before do
        sign_in(admin)
        get :edit, params: { :testimonial_id => testimonial.id }
      end

      it 'should render the edit template' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'PATCH update' do
    it_behaves_like 'requires admin' do
      let(:action) { patch :update, params: { :testimonial_id => 1 } }
    end

    it_behaves_like 'requires sign in' do
      let(:action) { patch :update, params: { :testimonial_id => 1 } }
    end

    context 'with valid admin and blank highlight' do
      let(:admin) { Fabricate(:user, admin: true) }
      let(:user) { Fabricate(:user) }
      let(:testimonial) { Fabricate(:testimonial, user_id: user.id) }

      before do
        Highlight.create(testimonial_id: testimonial.id, highlight: 'Testing')
        sign_in(admin)
        patch :update, params: { :testimonial_id => testimonial.id, highlight: { :highlight => '' } }
      end

      it 'renders sets the flash error message' do
        expect(flash[:error]).to be_present
      end

      it 'does not update the highlight' do
        expect(Highlight.first.highlight.to_s).to include('Testing')
      end

      it 'reders the edit template' do
        expect(response).to render_template :edit
      end
    end

    context 'with valid admin a highlight thats length is too long' do
      let(:admin) { Fabricate(:user, admin: true) }
      let(:user) { Fabricate(:user) }
      let(:testimonial) { Fabricate(:testimonial, user_id: user.id) }

      before do
        Highlight.create(testimonial_id: testimonial.id, highlight: 'Testing')
        sign_in(admin)
        patch :update, params: { :testimonial_id => testimonial.id, highlight: { :highlight =>  Faker::Lorem.characters(number: 151) } }
      end

      it 'renders sets the flash error message' do
        expect(flash[:error]).to be_present
      end

      it 'does not update the highlight' do
        expect(Highlight.first.highlight.to_s).to include('Testing')
      end

      it 'reders the edit template' do
        expect(response).to render_template :edit
      end
    end

    context 'with admin credentials and valid inputs' do
      let(:admin) { Fabricate(:user, admin: true) }
      let(:user) { Fabricate(:user) }
      let(:testimonial) { Fabricate(:testimonial, user_id: user.id) }

      before do
        Highlight.create(testimonial_id: testimonial.id, highlight: 'Testing')
        sign_in(admin)
        @highlight = Faker::Lorem.characters(number: 150)
        patch :update, params: { :testimonial_id => testimonial.id, highlight: { :highlight => @highlight } }
      end

      it 'sets the flash success message' do
        expect(flash[:success]).to be_present
      end

      it 'redircets to the testimonial path' do
        expect(response).to redirect_to edit_admin_testimonial_path(testimonial)
      end

      it 'updates the highlight' do
        expect(Highlight.first.highlight.to_s).to include(@highlight)
        expect(Highlight.first.highlight.to_s).not_to include('Testing')
      end
    end
  end

  describe 'DELETE destroy' do
    it_behaves_like 'requires admin' do
      let(:action) { delete :destroy, params: { :testimonial_id => 1 } }
    end

    it_behaves_like 'requires sign in' do
      let(:action) { delete :destroy, params: { :testimonial_id => 1 } }
    end

    context 'with valid admin and blank highlight' do
      let(:admin) { Fabricate(:user, admin: true) }
      let(:user) { Fabricate(:user) }
      let(:testimonial) { Fabricate(:testimonial, user_id: user.id) }

      before do
        Highlight.create(testimonial_id: testimonial.id, highlight: 'Testing')
        sign_in(admin)
        delete :destroy, params: { :testimonial_id => testimonial.id }
      end

      it 'sets the flash success message' do
        expect(flash[:success]).to be_present
      end

      it 'removes the highlight from the testimonial' do
        expect(testimonial.highlight).to_not be_present
      end

      it 'redirect to the testimonial path' do
        expect(response).to redirect_to edit_admin_testimonial_path(testimonial)
      end
    end
  end
end
