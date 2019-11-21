require 'rails_helper'

RSpec.describe Admin::SearchesController do
  describe 'GET index' do
    let(:admin) { Fabricate(:user, admin: true, full_name: '1', email: '1@1.com') }

    it_behaves_like 'requires admin' do
      let(:action) { get :index }
    end

    it_behaves_like 'requires sign in' do
      let(:action) { get :index }
    end

    context 'with valid admin credentials and no search testimonials' do
      it 'renders the index template' do
        sign_in(admin)
        get :index
        expect(response).to render_template :index
      end
    end

    context 'with valid admin credentials and q=similar to valid testimonial' do
      let(:user) { Fabricate(:user, email: 'jon@doe.com', :full_name => 'Jon Doe') }
      let!(:testimonial) { Fabricate(:testimonial, :creator_email => 'jon@doe.com', :creator => 'Jon Doe' ) }
      let!(:testimonial2) { Fabricate(:testimonial, :creator_email => 'jane@doe.com', :creator => 'Jane Doe') }

      context 'with full email' do
        before do
          sign_in(admin)
          get :index, :params => { :q => 'jon@doe.com' }
        end

        it 'assigns testimonials with 1 item' do
          expect(assigns(:testimonials).size).to eq(1)
        end

        it 'assigns testimonials with the testimonial from jon@doe.com' do
          expect(assigns(:testimonials)).to eq([testimonial])
        end
      end

      context 'without full email' do
        before do
          sign_in(admin)
          get :index, :params => { :q => 'jon@doe' }
        end

        it 'assigns testimonials with 1 item' do
          expect(assigns(:testimonials).size).to eq(1)
        end

        it 'assigns testimonials with the testimonial from jon@doe.com' do
          expect(assigns(:testimonials)).to eq([testimonial])
        end
      end

      context 'without @doe.com' do
        before do
          sign_in(admin)
          get :index, :params => { :q => 'jon' }
        end

        it 'assigns testimonials with 1 item' do
          expect(assigns(:testimonials).size).to eq(1)
        end

        it 'assigns testimonials with the testimonial from jon@doe.com' do
          expect(assigns(:testimonials)).to eq([testimonial])
        end
      end

      context 'with mixed upper and lowercase letters' do
        before do
          sign_in(admin)
          get :index, :params => { :q => 'jOn' }
        end

        it 'assigns testimonials with 1 item' do
          expect(assigns(:testimonials).size).to eq(1)
        end

        it 'assigns testimonials with the testimonial from jon@doe.com' do
          expect(assigns(:testimonials)).to eq([testimonial])
        end
      end

      context 'with a string with only spaces' do
        before do
          sign_in(admin)
          get :index, :params => { :q => ' ' }
        end

        it 'assigns testimonials with no items' do
          expect(assigns(:testimonials).size).to eq(0)
        end

        it 'assigns testimonials with an empty array' do
          expect(assigns(:testimonials)).to eq([])
        end
      end

      context 'with an empty string' do
        before do
          sign_in(admin)
          get :index, :params => { :q => '' }
        end

        it 'assigns testimonials with no items' do
          expect(assigns(:testimonials).size).to eq(0)
        end

        it 'assigns testimonials as am emtpy array' do
          expect(assigns(:testimonials)).to eq([])
        end
      end

      context 'with only last name' do
        before do
          sign_in(admin)
          get :index, :params => { :q => 'Doe' }
        end

        it 'assigns testimonials with 2 items' do
          expect(assigns(:testimonials).size).to eq(2)
        end

        it 'assigns testimonials with the testimonial from jon@doe.com' do
          expect(assigns(:testimonials)).to match_array([testimonial, testimonial2])
        end
      end
    end

    context 'with valid admin credentials and q= customer' do
      let!(:user) { Fabricate(:user, full_name: 'Jon Doe', email: 'jon@doe.com') }
      let!(:user2) { Fabricate(:user, full_name: 'Jane Doe', email: 'jane@doe.com') }

      before do
        sign_in(admin)
        get :index, :params => { :q => 'Jon Doe' }
      end

      it 'assigns customers with 1 item' do
        expect(assigns(:customers).size).to eq(1)
      end

      it 'assigns customers with user' do
        expect(assigns(:customers)).to eq([user])
      end
    end

    context 'with valid admin credentials and q= partial customer mixed case' do
      let!(:user) { Fabricate(:user, full_name: 'Jon Doe', email: 'jon@doe.com') }
      let!(:user2) { Fabricate(:user, full_name: 'Jane Doe', email: 'jane@doe.com') }

      before do
        sign_in(admin)
        get :index, :params => { :q => 'jO' }
      end

      it 'assigns customers with 1 item' do
        expect(assigns(:customers).size).to eq(1)
      end

      it 'assigns customers with user' do
        expect(assigns(:customers)).to eq([user])
      end
    end

    context 'with valid admin credentials and q= partial customer mixed case' do
      let!(:user) { Fabricate(:user, full_name: 'Jon Doe', email: 'jon@doe.com') }
      let!(:user2) { Fabricate(:user, full_name: 'Jane Doe', email: 'jane@doe.com') }

      before do
        sign_in(admin)
        get :index, :params => { :q => 'dO' }
      end

      it 'assigns customers with 1 item' do
        expect(assigns(:customers).size).to eq(2)
      end

      it 'assigns customers with user' do
        expect(assigns(:customers)).to match_array([user, user2])
      end
    end

    context 'with valid admin credentials and no query' do
      let!(:user) { Fabricate(:user, full_name: 'Jon Doe', email: 'jon@doe.com') }
      let!(:user2) { Fabricate(:user, full_name: 'Jane Doe', email: 'jane@doe.com') }

      it 'assigns customers to an empty array when the query string is empty' do
        sign_in(admin)
        get :index, :params => { :q => '' }
        expect(assigns(:customers).size).to eq(0)
      end

      it 'assigns customers to an empty array when the query string is only spaces' do
        sign_in(admin)
        get :index, :params => { :q => '   ' }
        expect(assigns(:customers).size).to eq(0)
      end
    end

    context 'with valid admin credentials and q= partial customer email mixed case' do
      let!(:user) { Fabricate(:user, full_name: 'Jon Doe', email: 'jon@doe.com') }
      let!(:user2) { Fabricate(:user, full_name: 'Jane Doe', email: 'jane@doe.com') }

      before do
        sign_in(admin)
        get :index, :params => { :q => 'n@do' }
      end

      it 'assigns customers with 1 item' do
        expect(assigns(:customers).size).to eq(1)
      end

      it 'assigns customers with user' do
        expect(assigns(:customers)).to match_array([user])
      end
    end

    context 'with valid admin credentials and q= email' do
      let!(:user) { Fabricate(:user, full_name: 'Jon Doe', email: 'jon@doe.com') }
      let!(:user2) { Fabricate(:user, full_name: 'Jane Doe', email: 'jane@doe.com') }
      let!(:email) { Fabricate(:email, full_name: 'Jon Doe', email: 'jon@doe.com') }
      let!(:email2) { Fabricate(:email, full_name: 'Jane Doe', email: 'jane@doe.com') }

      context 'with q= exact match name' do
        before do
          sign_in(admin)
          get :index, :params => { :q => 'Jon Doe' }
        end

        it 'assigns emails' do
          expect(assigns(:emails).size).to eq(1)
        end

        it 'assigns emails to a list including the emails' do
          expect(assigns(:emails)).to eq([email])
        end
      end

      context 'with q= partial mixed case first name' do
        before do
          sign_in(admin)
          get :index, :params => { :q => 'JO' }
        end

        it 'assigns emails' do
          expect(assigns(:emails).size).to eq(1)
        end

        it 'assigns emails to a list including the emails' do
          expect(assigns(:emails)).to eq([email])
        end
      end

      context 'with q= partial mixed case email' do
        before do
          sign_in(admin)
          get :index, :params => { :q => 'n@Do' }
        end

        it 'assigns emails' do
          expect(assigns(:emails).size).to eq(1)
        end

        it 'assigns emails to a list including the emails' do
          expect(assigns(:emails)).to eq([email])
        end
      end

      context 'with q= partial mixed case email' do
        before do
          sign_in(admin)
          get :index, :params => { :q => '@Doe' }
        end

        it 'assigns emails' do
          expect(assigns(:emails).size).to eq(2)
        end

        it 'assigns emails to a list including the emails' do
          expect(assigns(:emails)).to match_array([email, email2])
        end
      end
    end
  end
end
