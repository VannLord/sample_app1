class User < ApplicationRecord
  before_save :downcase_email

  private

  validates :email, format: {with: Settings.users.email.regex},
                    length: {maximum: Settings.users.email.max_length},
                    presence: true, uniqueness: true
  validates :name, presence: true

  def downcase_email
    email.downcase!
  end

  has_secure_password
end
