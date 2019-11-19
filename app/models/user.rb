require 'digest/md5'

class User < ApplicationRecord
  include Tokenable
  include Paginationable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable, :timeoutable, :omniauthable, :confirmable

  validates_presence_of :full_name

  before_save :create_avatar_url

  private

  def self.authenticate(email, password)
    user = self.find_for_authentication(:email => email)
    user && user.valid_password?(password) ? user : nil
  end

  def create_avatar_url
    email_address = self.email.downcase
    hash = Digest::MD5.hexdigest(email_address)
    self.avatar_url = hash
  end
end
