class Admin::SearchesController < Admin::BaseController
  def index
    search_term = params[:q]

    @testimonials = Testimonial.query_by_term(search_term)
    @customers = User.query_by_term(search_term)
    @emails = Email.query_by_term(search_term)
    @record_count = @testimonials.size + @customers.size + @emails.size
  end
end
