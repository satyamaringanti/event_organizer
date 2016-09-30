class Organization < ApplicationRecord
  has_many :organization_events
  has_many :events, through: :organization_events
  validates :name, presence: true, uniqueness: true
end
