class Users::PhotosController < ApplicationController
  def index
    @images = Dir.glob('app/assets/images/photos/*.jpg')
    @images.map! { |img| img.split('/').last }
  end
end
