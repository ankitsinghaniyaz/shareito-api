class User < ApplicationRecord
  has_secure_password

  belongs_to                :team

  before_save               :downcase_email
  before_create             :generate_confirmation_instructions

  validates_presence_of     :name
  validates_presence_of     :team
  validates_presence_of     :email
  validates_uniqueness_of   :email, case_sensetive: false
  validates_format_of       :email, with: /@/
  # validates_presence_of     :password_digest


  def downcase_email
    self.email = self.email.delete(' ').downcase
  end

  def generate_confirmation_instructions
    self.confirmation_token = SecureRandom.hex(10)
    self.confirmation_sent_at = Time.current.utc
  end

  def confirmation_token_valid?
    (self.confirmation_sent_at + 30.days) > Time.current.utc
  end

  def mark_as_confirmed!
    self.confirmation_token = nil
    self.confirmed_at = Time.current.utc
    save
  end
end
