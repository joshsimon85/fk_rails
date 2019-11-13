class User < ApplicationRecord
  include Tokenable
  include Paginationable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable
  has_one :testimonial

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable, :timeoutable, :omniauthable

  validates_presence_of :full_name

  private

  def self.authenticate(email, password)
    user = self.find_for_authentication(:email => email)
    user && user.valid_password?(password) ? user : nil
  end
end
