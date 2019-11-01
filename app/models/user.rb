class User < ApplicationRecord
  include Tokenable
  include Paginationable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_one :testimonial

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable, :timeoutable, :omniauthable

  validates_presence_of :full_name
end
