class PagesController < ApplicationController
  def index
    @highlights = Highlight.joins(:testimonial)
                           .where(testimonials: { published: true })
                           .limit(10)
    render layout: 'landing_page'
  end

  def about; end

  def contact; end

  def privacy_policy; end
end
