class User < ActiveRecord::Base
  attr_accessor :address
  has_many :microposts, dependent: :destroy

  validates :name, presence: true
  validates_length_of :name, maximum: 50
  validates_presence_of :email
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates_format_of :email, with: VALID_EMAIL_REGEX
  validates_uniqueness_of :email, case_sensitive: false
  validates :password, length: {minimum: 6}

  has_secure_password

  before_save { self.email = email.downcase }
  before_create :create_remember_token

  def feed
    # This is preliminary. See "Following users" for the full implementation.
    Micropost.where("user_id = ?", id)
  end

  def my_addy
    puts "I live in #{@address}"
  end

  def hungry?
    true
  end

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  private
  def create_remember_token
    self.remember_token = User.encrypt(User.new_remember_token)
  end
end
