class User < ActiveRecord::Base
  attr_accessor :address
  has_many :microposts, dependent: :destroy
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: "followed_id", class_name:  "Relationship", dependent: :destroy
  has_many :followers, through: :reverse_relationships, source: :follower

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
    # Micropost.where("user_id = ?", id)
    Micropost.from_users_followed_by self
  end

  def following?(other_user)
    relationships.find_by(followed_id: other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by(followed_id: other_user.id).destroy!
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
