class AddColumnCreatorAvatarUrlToTestimonials < ActiveRecord::Migration[6.0]
  def change
    add_column :testimonials, :creator_avatar_url, :string
  end
end
