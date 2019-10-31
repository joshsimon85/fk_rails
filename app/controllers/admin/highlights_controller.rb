class Admin::HighlightsController < Admin::BaseController
  def new
    @testimonial = Testimonial.find(params[:testimonial_id])
    @highlight = Highlight.new
  end

  def create
    @highlight = Highlight.create(highlight_params.merge(:testimonial_id => params[:testimonial_id]))
    @testimonial = Testimonial.find(params[:testimonial_id])
    if @highlight.valid?
      flash[:success] = 'The testimonial highlight has been created'
      redirect_to edit_admin_testimonial_path(@highlight.testimonial)
    else
      flash[:error] = 'An error was encounterd submitting your highlight'
      render :new
    end
  end

  def edit
    @testimonial = Testimonial.find(params[:testimonial_id])
    @highlight = @testimonial.highlight
  end

  def update
    @testimonial = Testimonial.find(params[:testimonial_id])
    @highlight = @testimonial.highlight
    @highlight.update(highlight_params)
    if @highlight.valid?
      flash[:success] = 'Your highlight has been updated'
      redirect_to edit_admin_testimonial_path(@testimonial)
    else
      flash.now[:error] = 'A problem was encountered while submitting your hightlight'
      render :edit
    end
  end

  private

  def highlight_params
    params.require(:highlight).permit(:highlight)
  end
end
