class User < ActiveRecord::Base
  attr_accessor :address

  validates :name, presence: true
  validates_length_of :name, maximum: 50
  validates_presence_of :email
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates_format_of :email, with: VALID_EMAIL_REGEX
  validates_uniqueness_of :email, case_sensitive: false
  validates :password, length: {minimum: 6}

  has_secure_password

  before_save { self.email = email.downcase }

  def my_addy
    puts "I live in #{@address}"
  end

  def hungry?
    true
  end
end
