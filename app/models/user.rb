class User < ActiveRecord::Base

  # Associations
  has_many :events, dependent: :restrict_with_error

  # Validations
  validates :name, :device_token, presence: true
  validates :device_token, allow_blank: true, uniqueness: { case_sensitive: false }
end
