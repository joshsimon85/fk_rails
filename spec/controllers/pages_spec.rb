require 'rails_helper'
require 'spec_helper'

RSpec.describe PagesController do
  describe 'GET index' do
    it 'renders the pages index template' do
      get :index
      expect(response).to render_template(:index)
    end
  end
end
