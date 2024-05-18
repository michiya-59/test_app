class User < ApplicationRecord
  has_secure_password

  before_create :generate_confirmation_token

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
  validates :password, presence: true, length: { minimum: 8 }, if: :password_required?
  validates :password_confirmation, presence: true, if: :password_required?

  def confirm!
    if confirmation_token_valid?
      if update_columns(confirmed_at: Time.current, confirmation_token: nil)
        true
      else
        errors.add(:base, "アカウントの確認に失敗しました。")
        false
      end
    else
      errors.add(:confirmation_token, "の有効期限が切れています。")
      false
    end
  end

  private

  def generate_confirmation_token
    self.confirmation_token = SecureRandom.urlsafe_base64.to_s
    self.confirmation_sent_at = Time.current
  end

  def confirmation_token_valid?
    (confirmation_sent_at + 15.minutes) > Time.current
  end

  def password_required?
    new_record? || password.present?
  end
end
