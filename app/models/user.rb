class User < ApplicationRecord
  has_many :microposts, dependent: :destroy
  before_save :downcase_email
  before_create :create_activation_digest
  attr_accessor :remember_token, :activation_token,
                :reset_token

  def activate
    update_columns activated: true, activated_at: Time.zone.now
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def self.digest string
    cost = if ActiveModel::SecurePassword.min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create string, cost: cost
  end

  class << self
    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def authenticated? attribute, token
    digest = send "#{attribute}_digest"
    return false unless digest

    BCrypt::Password.new(digest).is_password? token
  end

  def forget
    update_column :remember_digest, nil
  end

  def remember
    self.remember_token = User.new_token
    update_column :remember_digest, User.digest(remember_token)
  end

  def password_reset_expired?
    reset_sent_at < Settings.mail.reset.expired.hours.ago
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_columns reset_digest: User.digest(reset_token),
                   reset_sent_at: Time.zone.now
  end

  def feed
    microposts
  end

  private

  validates :email, format: {with: Settings.users.email.regex},
                    length: {maximum: Settings.users.email.max_length},
                    presence: true, uniqueness: true
  validates :name, presence: true
  validates :password, presence: true,
                       length: {minimum: Settings.users.password.min_length},
                       allow_nil: true

  def downcase_email
    email.downcase!
  end

  has_secure_password

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
