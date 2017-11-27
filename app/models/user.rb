class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze

  has_many :microposts,
           dependent: :destroy

  has_many :active_relationships,
           class_name:  'Relationship',
           foreign_key: 'follower_id',
           dependent:   :destroy

  has_many :passive_relationships,
           class_name:  'Relationship',
           foreign_key: 'followed_id',
           dependent:   :destroy

  has_many :following, #source of array following is a bunch of followed ids.
           through: :active_relationships,
           source: :followed

  has_many :followers, #array
           through: :passive_relationships,
           source: :follower


  attr_accessor :remember_token, :activation_token, :reset_token

  has_secure_password

  before_save :email_downcase
  before_create :create_activation_digest

  validates :name,
            presence: true,
            length: { maximum: 50 }

  validates :email,
            presence: true,
            length: { maximum: 255 },
            format: {with: VALID_EMAIL_REGEX},
            uniqueness: { case_sensitive: false }

  validates :password,
            presence: true,
            length: { minimum: 6 },
            allow_nil: true

  # Returns the hash digest of the given string.
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update(remember_digest: User.digest(remember_token))
  end

  # Returns true if the given token matches the digest.
  def authenticated?(attribute, token) # self.remember_digest, self.activation_digest
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # Forgets a user.
  def forget
    update(remember_digest: nil)
  end

  # Activates an account.
  def activate
    update(activated:    true)
    update(activated_at: Time.zone.now)
  end

  # Sends activation email.
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # Sets the password reset attributes.
  def create_reset_digest
    self.reset_token = User.new_token
    update(reset_digest:  User.digest(reset_token))
    update(reset_sent_at: Time.zone.now)
  end

  # Sends password reset email.
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # Returns true if a password reset has expired.
  def password_reset_expired?
    reset_sent_at < 2.hours.ago #Password reset sent earlier than two hours ago.
  end

  # Returns a user's status feed.
  def feed
    following_ids = 'SELECT followed_id FROM relationships
                     WHERE  follower_id = :user_id'
    Micropost.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: id)
  end
  # Follows a user.
  def follow(other_user)
    following << other_user
  end

  # Unfollows a user.
  def unfollow(other_user)
    following.delete(other_user)
  end

  # Returns true if the current user is following the other user.
  def following?(other_user)
    following.include?(other_user)
  end

  private

  def email_downcase
    self.email = email.downcase
  end

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

end

