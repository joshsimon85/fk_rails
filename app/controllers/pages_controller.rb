class PagesController < ApplicationController
  def index
    render layout: 'landing_page'
  end

  def about; end

  def contact; end

  def privacy_policy; end
end
